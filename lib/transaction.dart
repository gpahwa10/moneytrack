import 'package:flutter/material.dart';

class Transactions extends StatelessWidget {
  final String name;
  final String money;
  final String expOrInc;
  const Transactions(
      {super.key,
      required this.name,
      required this.money,
      required this.expOrInc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.grey[200],
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[400]),
                        child: const Icon(
                          Icons.attach_money_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        name,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
                Text(
                  ('${expOrInc == 'Expense' ? '-' : '+'}\$$money'),
                  style: TextStyle(
                      color:
                          (expOrInc == 'Expense' ? Colors.red : Colors.green)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
