@isTest
public class HelloWorldTest {
    @isTest
    static void testGetMessage() {
        String message = HelloWorld.getMessage();
        System.assertEquals('Hello Team! This is a PR from our feature branch!', message, 'Message should match');
    }
}