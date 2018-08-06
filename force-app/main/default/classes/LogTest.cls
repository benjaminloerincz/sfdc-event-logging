@IsTest
private class LogTest {

    @IsTest
    public static void logTest() { 
        Test.startTest();
        Log.push('MyClass.methodA');
        Log.push('MyClass.methodB');
        Log.message('Doing something');
        Log.pop();
        Log.message('Doing something more');        
        Log.pop();   
        Log.emit();     
        Test.stopTest();
        System.assertEquals(1,[SELECT count() FROM LogRecording__c]);
	}

    @IsTest
    public static void logExceptionTest() { 
        Test.startTest();
        try {
            Integer i;
            i++;
        } catch(Exception e) {
            String errorId = LogService.createErrorId();
            log.push('MyTestClass');
            log.errorId(errorId);
            log.rootReason('In a test class');
            log.rootException(e);
            Log.emit();     
        }
        Test.stopTest();
        System.assertEquals(1,[SELECT count() FROM LogRecording__c]);
	}

    @IsTest
    public static void logJsonExceptionTest() { 
        Test.startTest();
        try {
            String i = '{';
            Account acc = (Account)JSON.deserialize(i,Account.Class);
        } catch(JSONException e) {
            String errorId = LogService.createErrorId();
            log.push('MyTestClass');
            log.errorId(errorId);
            log.rootReason('In a test class');
            log.rootException(e);
            Log.emit();     
        }
        Test.stopTest();
        System.assertEquals(1,[SELECT count() FROM LogRecording__c]);
	}

}