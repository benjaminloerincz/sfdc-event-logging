public with sharing class LogService {

    public static void recordErrors(List<Log__e> logEvents) {
        List<LogRecording__c> logRecordings = new List<LogRecording__c>();
        for(Log__e logEvent : logEvents) {
            LogRecording__c logRecording = new LogRecording__c();
            logRecording.DML__c = LogEvent.DML__c;
            logRecording.Data__c = logEvent.Data__c;
            logRecording.SOQL__c = logEvent.SOQL__c;
            logRecording.Title__c = logEvent.Title__c;
            logRecordings.add(logRecording);
        }
        insert logRecordings;
    }

}
