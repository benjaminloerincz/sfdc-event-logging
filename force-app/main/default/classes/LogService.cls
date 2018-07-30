public with sharing class LogService {

    public static void recordErrors(List<Log__e> logEvents) {
        List<LogRecording__c> logRecordings = new List<LogRecording__c>();
        for(Log__e logEvent : logEvents) {
            LogRecording__c logRecording = new LogRecording__c();
            logRecording.DML__c = LogEvent.DML__c;
            logRecording.Data__c = logEvent.Data__c;
            logRecording.SOQL__c = logEvent.SOQL__c;
            logRecording.Title__c = logEvent.Title__c;
            logRecording.Reason__c = logEvent.Reason__c;
            logRecording.Callouts__c = logEvent.Callouts__c;
            logRecording.CPUTime__c = logEvent.CPUTime__c;
            logRecording.QueryRows__c = logEvent.QueryRows__c;
            logRecording.ExceptionType__c = logEvent.ExceptionType__c;
            logRecording.ExceptionStackTrace__c = logEvent.ExceptionStackTrace__c;
            logRecording.ExceptionMessage__c = logEvent.ExceptionMessage__c;
            logRecording.HeapSize__c = logEvent.HeapSize__c;
            logRecordings.add(logRecording);
        }
        insert logRecordings;
    }

}
