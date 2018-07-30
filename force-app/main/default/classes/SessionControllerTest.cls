@IsTest
private class SessionControllerTest {

    @IsTest
    public static void sessionTest() { 
        Test.startTest();
        System.assertEquals(UserInfo.getSessionId(),SessionController.getSessionId());
        Test.stopTest();
	}

}