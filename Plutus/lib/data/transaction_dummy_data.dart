import '../models/transaction.dart';
import '../models/categories.dart';

List<Transaction> dummyTransactions = [
  Transaction(
    id: 't1',
    title: 'Coffee',
    amount: 3.45,
    category: MainCategory.home,
  ),
  Transaction(
    id: 't2',
    title: 'Shirt',
    amount: 10.96,
    category: MainCategory.bills_and_utilities,
  ),
  Transaction(
    id: 't3',
    title: 'Water Bill',
    amount: 50.00,
    category: MainCategory.health_and_fitness,
  ),
  Transaction(
    id: 't4',
    title: 'Movies',
    amount: 25.35,
    category: MainCategory.home,
  ),
  Transaction(
    id: 't5',
    title: 'Shoes',
    amount: 35.85,
    category: MainCategory.food_and_drinks,
  ),
];
