/**
		SavePoint sp = Database.setSavepoint();
        Log.push('MyClass.methodA');
            insert new Account(Name = 'Test');
            Log.push('MyClass.methodB');
                Log.message('Doing something');
                insert new Account(Name = 'Test');
            Log.pop();
            List<Account> accounts = [select Id from Account];
            Log.push('MyClass.methodC');        
                List<Account> accounts2 = [select Id from Account];
            Log.pop();
            Log.message('Doing something else');        
        Log.pop();
        Database.rollback(sp);        
		Log.emit();
**/

/**
 * Simple in memory low cpu logging
 **/
public class Log {

    private static LogScope current;
    private static LogScope root;    
	private static final Integer DML_IDX = 0;
	private static final Integer SOQL_IDX = 1;   
    private static final Integer HTTP_IDX = 2;   
    private static final Integer CPU_IDX = 3;    
    private static final Integer HEAP_IDX = 4;    
    private static final Integer ROW_IDX = 5;    
	private static final Map<Integer, String> limitsByIdx = 
            new Map<Integer, String> { DML_IDX => 'DML', SOQL_IDX => 'SOQL',HTTP_IDX => 'Callout', 
            CPU_IDX => 'CPU', HEAP_IDX => 'Heap', ROW_IDX => 'SOQL Rows'};
    
    static {
        reset();
    }

	/**
	 * Push this named scope onto the log stack
	 **/    
    public static void push(String scope) {
		LogScope newScope = new LogScope();
        newScope.scope = scope;
        newScope.limits = new List<Integer> { 
            Limits.getDMLStatements(), 
			Limits.getQueries(),
            Limits.getCallouts(),
            Limits.getCpuTime(),
            Limits.getHeapSize(),
            Limits.getQueryRows()};
		newScope.parent = Log.current;
        Log.current.logEntries.add(newScope);
		Log.current = newScope;        
    }
    
    /**
     * Add the given message to the scope last pushed
     **/
    public static void message(String message) {
		Log.current.logEntries.add(message);        
    }

    /**
     * Add the given message to the scope last pushed
     **/
    public static void rootReason(String reason) {
		Log.root.reason = reason;
    }

    /**
     * Add exception information
     **/
    public static void rootException(Exception e) {
        Log.root.exceptionType = e.getTypeName();
        Log.root.exceptionStackTrace = e.getStackTraceString();
        Log.root.exceptionMessage = e.getMessage();
    }

    /**
     * Add the given message to the scope last pushed
     **/
    public static void recordId(Id recordId) {
		Log.root.recordId = recordId;
    }
    
    /**
     * Pop the current scope
     **/
    public static void pop() {
        Log.current.limits = new List<Integer> { 
                Limits.getDMLStatements() - Log.current.limits[DML_IDX], 
                Limits.getQueries() - Log.current.limits[SOQL_IDX],
                Limits.getCallouts() - Log.current.limits[HTTP_IDX],
                Limits.getCpuTime() - Log.current.limits[CPU_IDX],
                Limits.getHeapSize() - Log.current.limits[HEAP_IDX],
                Limits.getQueryRows() - Log.current.limits[ROW_IDX]};
     	Log.current = Log.current.parent;           
    }

	/**
	 * Flush the log entries and serialize 
	 **/    
    public static String flush() {
        List<String> logLines = new List<String>();
        logLines.add(Log.root.scope);
        Log.root.flush(logLines, 1);
        reset();
		return String.join(logLines, '/n');        
    }
    
    /** 
     * Emits the current log state to the Log__e platform event
     **/
    public static void emit() {
        
        // Log title is primarly present to allow filtering
        String title = Log.root.scope;
        Integer dml = -1;
        Integer soql = -1;
        Integer callouts = -1;
        Integer cpuTime = -1;
        Integer queryRows = -1;
        Integer heapSize = -1;
        if(Log.root.logEntries.size()>0) {
	        Object top = Log.root.logEntries[0];
            if(top instanceof LogScope) {
				LogScope logScope = (LogScope) top;
                title = logScope.scope;                
                dml = logScope.limits[DML_IDX];
                soql = logScope.limits[SOQL_IDX];
                callouts = logScope.limits[HTTP_IDX];
                cpuTime = logScope.limits[CPU_IDX];
                heapSize = logScope.limits[HEAP_IDX];
                queryRows = logScope.limits[ROW_IDX];
            } else if (top instanceof String) {
				title = (String) top;                
            }
        }
        
        // Emit the log data via Platform Events
        EventBus.publish(
            new Log__e(
                Title__c = title,
                DML__c = dml,
                SOQL__c = soql,
                Callouts__c = callouts,
                CPUTime__c = cpuTime,
                QueryRows__c = queryRows,
                HeapSize__c = heapSize,
                ExceptionType__c = root.exceptionType,
                ExceptionStackTrace__c = root.exceptionStackTrace,
                ExceptionMessage__c = root.exceptionMessage,
                Reason__c = root.reason,
                RunningUserId__c = UserInfo.getUserId(),
                Data__c = flush()));
    }    
    
    /**
     * Resets the log state
     **/
    private static void reset() {
        root = current = new LogScope();
        DateTime now = DateTime.now();
        current.scope = String.valueOf(now+'.'+now.millisecond());        
    }
    
    /**
     * Nested log scopes
     **/
    private class LogScope {
        
        public LogScope parent;
        public String scope;
        public String exceptionType;
        public String exceptionStackTrace;
        public String exceptionMessage;
        public String reason;
        public Id recordId;
        public List<Integer> limits;
        public List<Object> logEntries = new List<Object>();
        
        public void flush(List<String> logLines, Integer indent) {
            for(Object logEntry : logEntries) {
                if(logEntry instanceof LogScope) {
					LogScope logScope = (LogScope) logEntry;
                    List<String> limitDiffs = new List<String>();
                    for(Integer limitIdx : limitsByIdx.keySet()) {
                        Integer limitVariance = logScope.limits[limitIdx];
                        if(limitVariance > 0) {
							limitDiffs.add(limitsByIdx.get(limitIdx)+' ' + limitVariance);
                        }
                    }
                    String limits = limitDiffs.size() > 0 ? '(' + String.join(limitDiffs, ',') + ')' : '';
                    logLines.add(indent+':'+logScope.scope+' '+limits);
					logScope.flush(logLines, indent+1);
                } else {
					logLines.add(indent+':'+logEntry);                    
                }
            }
        }
    }    
}