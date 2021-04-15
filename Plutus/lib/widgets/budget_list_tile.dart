import 'package:Plutus/models/categories.dart';
import 'package:Plutus/widgets/transaction_list_tile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../providers/auth.dart';
import '../models/budget.dart';
import '../models/transaction.dart' as Transaction;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/category_icon.dart';
import '../models/category.dart' as Category;

class BudgetListTile extends StatefulWidget {
  final Category.Category category;
  final Query budgetTransactions;
  BudgetListTile(this.category, this.budgetTransactions);

  @override
  _BudgetListTileState createState() => _BudgetListTileState();
}

class _BudgetListTileState extends State<BudgetListTile> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context, listen: false);
    var categoryTransactions = widget.budgetTransactions
        .where('categoryID', isEqualTo: widget.category.getID())
        .orderBy('date', descending: true);
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(Provider.of<Auth>(context, listen: false).getUserId())
    //     .collection('Transactions')
    //     .where('categoryID', isEqualTo: widget.category.getID())
    // .where(
    //   'date',
    //   isGreaterThanOrEqualTo: DateTime(
    //     widget.DateTime.now().year,
    //     widget.budgetDate.month,
    //     1,
    //   ),
    //   isLessThan: DateTime(
    //     widget.budgetDate.year,
    //     widget.budgetDate.month + 1,
    //     1,
    //   ),

    //     .snapshots();
    // final monthlyBudget =
    //     Provider.of<BudgetDataProvider>(context).monthlyBudget;
    return StreamBuilder<QuerySnapshot>(
        stream: categoryTransactions.snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return Text("There was an error loading your information");
              }
            default:
              {
                var transactionExpenses = snapshot.hasData
                    ? transactionDataProvider
                        .getTransactionExpenses(snapshot.data)
                    : 0.0;
                widget.category.calculateRemainingAmount(transactionExpenses);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(
                        20)), //BorderRadius.vertical(top: Radius.circular(20)),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                          tileColor: Colors.grey[850],
                          title: Container(
                            margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  categoryIcon[widget.category.getCodepoint()],
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                AutoSizeText(
                                  widget.category.getTitle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18),
                                ),
                                // category budget allocated
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '\$${widget.category.getAmount().toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              new LinearPercentIndicator(
                                alignment: MainAxisAlignment.center,
                                width: MediaQuery.of(context).size.width * .8,
                                lineHeight: 12.0,
                                percent: !snapshot.hasData ||
                                        snapshot.data.docs.isEmpty
                                    ? 0.0
                                    : transactionExpenses >
                                            widget.category.getAmount()
                                        ? 1
                                        : transactionExpenses /
                                            widget.category.getAmount(),
                                backgroundColor: Colors.black,
                                progressColor: Colors.amber,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  '\$${widget.category.getRemainingAmount().toStringAsFixed(2)} remaining',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_expanded)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            color: Colors.grey[550],
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${transactionExpenses.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColor,
                                  height: 10,
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                SingleChildScrollView(
                                  child: snapshot.data.docs.isEmpty
                                      ? Text(
                                          'No transaction has been added yet',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                        )
                                      : Container(
                                          height: min(
                                              snapshot.data.docs.length * 100.0,
                                              200.0),
                                          child: ListView.builder(
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (context, index) {
                                              return TransactionListTile(
                                                  Provider.of<
                                                              Transaction
                                                                  .Transactions>(
                                                          context,
                                                          listen: false)
                                                      .initializeTransaction(
                                                          snapshot.data
                                                              .docs[index]));
                                            },
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                );
                // }
              }
          }
        });
  }
}
