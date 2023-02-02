import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ItemQuantitySelector extends StatelessWidget {
  final ValueChanged<int>? onChanged;
  final int quantity;
  final int maxQuantity;
  final int? itemIndex;

  const ItemQuantitySelector({
    Key? key,
    required this.quantity,
    required this.onChanged,
    required this.maxQuantity,
    this.itemIndex,
  }) : super(key: key);

  // * Keys for testing using find.byKey()
  static Key decrementKey([int? index]) => index != null ? Key('decrement-$index') : const Key('decrement');

  static Key quantityKey([int? index]) => index != null ? Key('quantity-$index') : const Key('quantity');

  static Key incrementKey([int? index]) => index != null ? Key('increment-$index') : const Key('increment');

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
            key: decrementKey(itemIndex),
            onPressed: quantity > 1
                ? () {
                    onChanged?.call(quantity - 1);
                  }
                : null,
            icon: const Icon(Icons.remove),
          ),
          Text(
            quantity.toString(),
            key: quantityKey(itemIndex),
          ),
          IconButton(
            key: incrementKey(itemIndex),
            onPressed: quantity < maxQuantity
                ? () {
                    onChanged?.call(quantity + 1);
                  }
                : null,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
