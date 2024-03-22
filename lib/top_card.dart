// ignore: file_names
import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;
  const TopCard(
      {super.key,
      required this.balance,
      required this.income,
      required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(4, 4),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
              const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 15.0,
                  spreadRadius: 1.0)
            ]),
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'B A L A N C E',
                style: TextStyle(fontSize: 20, color: Colors.grey[500]),
              ),
              Text(
                '\$$balance',
                style: TextStyle(fontSize: 40, color: Colors.grey[800]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: const Icon(
                            Icons.arrow_upward,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [const Text('Income'), Text('\$$income')],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: const Icon(
                            Icons.arrow_downward,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            const Text('Expenditure'),
                            Text('\$$expense')
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
