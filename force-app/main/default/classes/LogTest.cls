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
            log.push('MyTestClass');
            log.rootReason('In a test class');
            log.rootException(e);
            Log.emit();     
        }
        Test.stopTest();
        System.assertEquals(1,[SELECT count() FROM LogRecording__c]);
	}

}