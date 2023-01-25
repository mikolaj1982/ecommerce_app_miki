import 'package:flutter/material.dart';

class ItemQuantitySelector extends StatelessWidget {
  final ValueChanged<int>? onChanged;
  final int quantity;
  final int maxQuantity;

  const ItemQuantitySelector({
    Key? key,
    required this.quantity,
    required this.onChanged,
    required this.maxQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: quantity > 1
                ? () {
                    onChanged?.call(quantity - 1);
                  }
                : null,
            icon: const Icon(Icons.remove),
          ),
          Text(quantity.toString()),
          IconButton(
            onPressed: quantity < maxQuantity
                ? () {
                    onChanged?.call(quantity + 1);
                  }
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
