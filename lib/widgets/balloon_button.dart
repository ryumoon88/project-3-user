import 'package:flutter/material.dart';
import 'package:project_3_tablet/models/product_category.dart';

class CategoryButton extends StatefulWidget {
  const CategoryButton({
    super.key,
    required this.category,
    required this.callback,
    required this.active,
    required this.index,
  });

  final ProductCategory category;
  final dynamic Function() callback;
  final bool active;
  final int index;

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  MaterialStatePropertyAll<Color> background =
      const MaterialStatePropertyAll(Colors.white);
  MaterialStatePropertyAll<Color> foreground =
      const MaterialStatePropertyAll(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.callback,
      style: ButtonStyle(
        backgroundColor: widget.active ? foreground : background,
        foregroundColor: widget.active ? background : foreground,
      ),
      child: Text(widget.category.name),
    );
  }
}