import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final VoidCallback? func;
  const PlusButton({super.key,  this.func});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 75,
        width: 75,
        decoration:
            BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
        child: GestureDetector(
          onTap: func,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ));
  }
}
