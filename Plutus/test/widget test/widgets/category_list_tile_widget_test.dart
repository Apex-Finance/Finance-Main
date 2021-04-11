import 'package:Plutus/widgets/transaction_list_tile.dart';
import 'package:Plutus/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Transaction testTransaction = new Transaction.empty();

  testTransaction.setAmount(300);
  testTransaction.setTitle("Test Title");
  testTransaction.setDate(DateTime.now());

  testWidgets('TransactionListTile has a title and message',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(TransactionListTile(testTransaction));

    // Create the Finders.
    final titleFinder = find.text('Test Title');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
  });
}
