import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:makeci/content/controller.dart';
import 'package:makeci/util/add_drink.dart';

void main() {
  late OrderController orderController;

  setUp(() {
    orderController = OrderController();
    Get.put(orderController);
  });

  testWidgets('AddDrinkPage UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddDrinkPage()));

    // Find text fields
    final drinkNameTextField = find.byKey(const Key('drinkNameTextField'));
    final priceTextField = find.byKey(const Key('priceTextField'));

    // Find elevated button
    final addButton = find.text('Tambahkan Menu');

    // Enter text into text fields
    await tester.enterText(drinkNameTextField, 'Test Drink');
    await tester.enterText(priceTextField, '10000');

    // Verify if addDrinkPrice method is called after tapping add button
    expect(
        orderController.selectedDrink.isEmpty, true); // Expect before tapping

    // Tap the add button
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify if addDrinkPrice method is called after tapping add button
    expect(
        orderController.selectedDrink.isNotEmpty, true); // Expect after tapping

    // Verify if addDrinkPrice method is called with correct parameters
    expect(orderController.selectedDrink.contains('Test Drink'),
        true); // Expect drink name to be added
    expect(orderController.totalDrinkPrice.value,
        10000); // Expect price to be added
  });
}
