import 'package:flutter/material.dart';

import '../models/category.dart' as Category;

List<Category.Category> mainCategory = [
  Category.Category(
    id: 'c1',
    title: 'Home',
    icon: Icons.home,
    // house icon
  ),
  Category.Category(
    id: 'c2',
    title: 'Food & Drinks',
    icon: Icons.local_dining,
    // spoon and fork icon
  ),
  Category.Category(
    id: 'c3',
    title: 'Bills & Utilities',
    icon: Icons.payment,
    // credit card icon
  ),
  Category.Category(
    id: 'c4',
    title: 'Education',
    icon: Icons.school,
    // graduation cap icon
  ),
  Category.Category(
    id: 'c5',
    title: 'Shopping',
    icon: Icons.shopping_cart,
    // shopping cart icon
  ),
  Category.Category(
    id: 'c6',
    title: 'Travel',
    icon: Icons.airplanemode_on,
    // airplane icon
  ),
  Category.Category(
    id: 'c7',
    title: 'Transportation',
    icon: Icons.directions_car,
    // car icon
  ),
  Category.Category(
    id: 'c8',
    title: 'Life & Entertainment',
    icon: Icons.tv,
    // tv icon
  ),
  Category.Category(
    id: 'c9',
    title: 'Health & Fitness',
    icon: Icons.fitness_center,
    // Barbell icon
  ),
  Category.Category(
    id: 'c10',
    title: 'Investments',
    icon: Icons.attach_money,
    // dollar sign icon
  ),
  Category.Category(
    id: 'c11',
    title: 'Fees & Charges',
    icon: Icons.home, // can't find icon for this one
  ),
  Category.Category(
    id: 'c12',
    title: 'Gifts & Donations',
    icon: Icons.wallet_giftcard,
    // giftcard icon
  ),
  Category.Category(
    id: 'c13',
    title: 'Kids',
    icon: Icons.child_friendly,
    // stroller icon
  ),
  Category.Category(
    id: 'c14',
    title: 'Pets',
    icon: Icons.pets,
    // paw icon
  ),
  Category.Category(
    id: 'c15',
    title: 'Uncategorized',
    icon: Icons.build_circle,
    // Wrench icon SHOULD CHANGE LATER
  ),
  Category.Category(
    id: 'c16',
    title: 'Business',
    icon: Icons.business,
    // business building icon
  ),

  //Custom Category
  Category.Category(
    id: 'c17',
    title: 'Custom',
    icon: Icons.add_box,
    // plus sign inside box icon
  ),
];
