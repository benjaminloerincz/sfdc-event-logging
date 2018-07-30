public with sharing class LogService {

    public static void recordErrors(List<Log__e> logEvents) {
        List<LogRecording__c> logRecordings = new List<LogRecording__c>();
        for(Log__e logEvent : logEvents) {
            LogRecording__c logRecording = new LogRecording__c();
            logRecording.DML__c = LogEvent.DML__c;
            logRecording.Data__c = logEvent.Data__c;
            logRecording.SOQL__c = logEvent.SOQL__c;
            logRecording.Title__c = logEvent.Title__c;
            logRecording.Reason__c = getReason(logEvent);
            logRecordings.add(logRecording);
        }
        insert logRecordings;
    }

    public static String getReason(Log__e logEvent) {
        if (logEvent.SOQL__c > 100) {
           return 'Query Limit Exceeded';
        } else if(logEvent.DML__c > 150) {
            return 'DML Limit Exceeded';
        } else {
            return 'Exception Thrown';
        }
    }

}
