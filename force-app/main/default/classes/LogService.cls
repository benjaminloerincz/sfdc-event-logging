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
            logRecording.RunningUser__c = logEvent.RunningUserId__c;
            logRecording.ErrorId__c = logEvent.ErrorId__c;
            logRecordings.add(logRecording);
        }
        insert logRecordings;
    }

    public static String createErrorId() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }

}
