// Imported Flutter packages
import 'package:flutter_test/flutter_test.dart';

// Imported Plutus files
import '../../../lib/models/category.dart';

void main() {
  Category ogCategory = Category();
  Category newCategory = Category();

  test('Initializing Categories', () {
    ogCategory.setID('1');
    ogCategory.setTitle('Jedi');
    ogCategory.setAmount(10000.00);

    newCategory.setID('1');
    newCategory.setTitle('Jedi');
    newCategory.setAmount(10000.00);

    expect(ogCategory.getID(), newCategory.getID());
    expect(ogCategory.getTitle(), newCategory.getTitle());
    expect(ogCategory.getAmount(), newCategory.getAmount());
  });
}
