import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}