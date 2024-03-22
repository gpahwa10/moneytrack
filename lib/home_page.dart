import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moneytrack/google_sheet_api.dart';
// import 'package:moneytrack/loading_circle.dart';
import 'package:moneytrack/plus_button.dart';
import 'package:moneytrack/transaction.dart';
import 'Top_Card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('N E W  T R A N S A C T I O N'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          const Text('Income'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textControllerAmount,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: _textControllerItem,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text('Enter',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  void _enterTransaction() {
    GsheetApi.insert(
        _textControllerItem.text, _textControllerAmount.text, _isIncome);
    setState(() {});
  }

  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GsheetApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GsheetApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 TopCard(
                  balance:(GsheetApi.calculateIncome()-GsheetApi.calculateExpense()).toString() ,
                  income:GsheetApi.calculateIncome().toString(),
                  expense:GsheetApi.calculateExpense().toString(),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: GsheetApi.currentTransactions.length,
                                itemBuilder: (context, index) {
                                  return Transactions(
                                      name: GsheetApi.currentTransactions[index]
                                          [0],
                                      money: GsheetApi
                                          .currentTransactions[index][1],
                                      expOrInc: GsheetApi
                                          .currentTransactions[index][2]);
                                }))
                      ],
                    ),
                  ),
                ),
                PlusButton(
                  func: _newTransaction,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
