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
}