import 'package:bazatlima/loginPage.dart';
import "package:flutter_test/flutter_test.dart";

main() {
  test("Campos obligatorios", () {
    //Step 1: Create
    LoginPage loginTest = LoginPage();

    //Step 2: What to test
    int result = -1;

    //Step 3: Expected
    expect(result, 1);
  });
}
