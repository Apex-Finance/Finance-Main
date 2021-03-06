// Imported Flutter packages
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:math';

// Imported Plutus files
import '../widgets/transaction_list_tile.dart';
import '../models/transaction.dart' as Transaction;
import '../models/category_icon.dart';
import '../models/category.dart' as Category;

class BudgetListTile extends StatefulWidget {
  final Category.Category category;
  final Query budgetTransactions;
  final ValueKey key;
  BudgetListTile(this.category, this.budgetTransactions, this.key);

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

    return StreamBuilder<QuerySnapshot>(
        key: widget.key,
        stream: categoryTransactions.snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return Text("There was an error loading your information",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 15));
              }
            default:
              {
                var transactionExpenses = snapshot.hasData
                    ? transactionDataProvider
                        .getTransactionExpenses(snapshot.data)
                    : 0.0;
                widget.category.calculateRemainingAmount(transactionExpenses);
                var remaining = widget.category.getRemainingAmount() < 0
                    ? 'overspent'
                    : 'remaining';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                          tileColor: Theme.of(context).backgroundColor,
                          title: Container(
                            margin:
                                const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  categoryIcon[widget.category.getCodepoint()],
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
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
                                    child: AutoSizeText(
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
                              const SizedBox(
                                height: 20,
                              ),
                              LinearPercentIndicator(
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
                                progressColor: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 4.0),
                                child: AutoSizeText(
                                  '\$${widget.category.getRemainingAmount().abs().toStringAsFixed(2)} $remaining',
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              color: Theme.of(context).cardColor,
                              height: snapshot.data.docs.isEmpty
                                  ? 100
                                  : min(snapshot.data.docs.length * 200.0, 250),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        AutoSizeText(
                                          '\$${transactionExpenses.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                              'No transaction has been added yet.',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 18),
                                              textAlign: TextAlign.center,
                                            )
                                          : Container(
                                              height: min(
                                                  snapshot.data.docs.length *
                                                      100.0,
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
                                                                      .docs[
                                                                  index]));
                                                },
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                );
              }
          }
        });
  }
}
