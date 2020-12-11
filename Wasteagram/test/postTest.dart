import 'package:test/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Wasteagram/screens/AddItem.dart';

void main() {
  test('Quantity Success', () {
    const quantity = 3;

    final testPost = FoodWasteData(
      quantity: 3,
    );
    expect(testPost.quantity, quantity);
  });

  test('Url Success', () {
    const url = 'Fake';

    final testPost = FoodWasteData(
      url: 'Fake',
    );
    expect(testPost.url, url);
  });

  test('Date Success', () {
    final date = 'Thursday, January 1st, 1999';

    final testPost = FoodWasteData(date: 'Thursday, January 1st, 1999');
    expect(testPost.date, date);
  });
}
