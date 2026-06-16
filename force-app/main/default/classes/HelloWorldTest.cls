@isTest
public class HelloWorldTest {
    @isTest
    static void testGetMessage() {
        String message = HelloWorld.getMessage();
        System.assertEquals('Hello from GitHub Actions!', message, 'Message should match');
    }
}