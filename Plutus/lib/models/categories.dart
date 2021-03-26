import 'package:flutter/foundation.dart';

// Our main categories
enum MainCategory {
  home,
  food_and_drinks,
  bills_and_utilities,
  education,
  shopping,
  travel,
  //transportation,
  life_and_entertainment,
  //health_and_fitness,
  investments,
  //fees_and_charges,
  //gifts_and_donations,
  //kids,
  //pets,
  //business,
  goals,
  uncategorized, // Needed for getter
}

// All subcategories regardless of main
enum SubCategory {
  furnishings,
  homeImprovement,
  homeInsurance,
  homeServices,
  homeSupplies,
  lawnAndGarden,
  rent,
  mortgage,
  smartHomeDevices,
  barAndCafe,
  groceries,
  restaurant,
  fastFood,
  phone,
  water,
  electricity,
  gas,
  internet,
  television,
  books_and_supplies,
  tuition,
  educational_software,
  student_loan,
  clothing,
  footwear,
  jewelry,
  hobbies,
  hotel,
  rental_car,
  vacation,
  car_insurance,
  toll,
  gasoline,
  parking,
  service_and_parts,
  taxi,
  bux,
  movies,
  games,
  music,
  electronics_and_software,
  newspapers,
  magazines,
  sports,
  doctor,
  medicine,
  health_insurance,
  dentist,
  eyecare,
  gym,
  pharmacy,
  life_insurance,
  stock,
  etf,
  mutual_fund,
  rothIRA,
  savings,
  // 401(k)
  atm_fee,
  bank_fee,
  finance_charge,
  late_fee,
  service_fee,
  trade_commission,
  charity,
  gift,
  tithe,
  allowance,
  baby_supplies,
  babysitter,
  daycare,
  child_support,
  toys,
  pet_food,
  pet_supplies,
  pet_grooming,
  veterinary,
  advertising,
  legal,
  office_supplies,
  printing,
  shipping,
  cash_and_ATM,
  check,
}

enum home {
  furnishings,
  homeImprovement,
  homeInsurance,
  homeServices,
  homeSupplies,
  lawnAndGarden,
  rent,
  mortgage,
  smartHomeDevices,
}

enum food_and_drinks {
  barAndCafe,
  groceries,
  restaurant,
  fastFood,
}

enum bills_and_utilities {
  phone,
  water,
  electricity,
  gas,
  internet,
  television,
}

enum education {
  books_and_supplies,
  tuition,
  educational_software,
  student_loan
}

enum shopping {
  clothing,
  footwear,
  jewelry,
  hobbies,
}

enum travel {
  hotel,
  rental_car,
  vacation,
}

enum transportation {
  car_insurance,
  toll,
  gasoline,
  parking,
  service_and_parts,
  taxi,
  bux,
}

enum life_and_entertainment {
  movies,
  games,
  music,
  electronics_and_software,
  newspapers,
  magazines,
}

enum health_and_fitness {
  sports,
  doctor,
  medicine,
  health_insurance,
  dentist,
  eyecare,
  gym,
  pharmacy,
  life_insurance,
}

enum investments {
  stock,
  etf,
  mutual_fund,
  rothIRA,
  savings,
  // 401(k)
}

enum fees_and_charges {
  atm_fee,
  bank_fee,
  finance_charge,
  late_fee,
  service_fee,
  trade_commission,
}

enum gifts_and_donations {
  charity,
  gift,
  tithe,
}

enum kids {
  allowance,
  baby_supplies,
  babysitter,
  daycare,
  child_support,
  toys,
}

enum pets {
  pet_food,
  pet_supplies,
  pet_grooming,
  veterinary,
}

enum business {
  advertising,
  legal,
  office_supplies,
  printing,
  shipping,
}

enum uncategorized {
  cash_and_ATM,
  check,
}

// These next 4 functions convert an enum to a string and a string to an enum (and 2 more to make them pretty strings); will combine into 2 functions
String enumValueToString(Object o) => o.toString().split('.').last;

String stringToUserString(String category) =>
    category.substring(0, 1).toUpperCase() +
    category.substring(1).replaceAll('_', ' ');

String enumCategoryFromUserString(String category) {
  print('${category.toLowerCase().replaceAll(' ', '_')}');
  return category.toLowerCase().replaceAll(' ', '_');
}

MainCategory enumValueFromString<MainCategory>(
        String key, Iterable<MainCategory> values) =>
    values.firstWhere(
      (v) => v != null && key == enumValueToString(v),
      orElse: () => null,
    );

class Category {
  String id;
  MainCategory title;
  SubCategory subCategory;

  Category({
    @required this.id,
    @required this.title,
    this.subCategory,
  });
}
