@isTest
public class HelloWorldTest {
  @isTest
  static void testGetMessage() {
    String message = HelloWorld.getMessage();
    System.assertEquals(
      'Hello Team! This is the LIVE DEMO of our enterprise pipeline in action!',
      message,
      'Message should match'
    );
  }
}
