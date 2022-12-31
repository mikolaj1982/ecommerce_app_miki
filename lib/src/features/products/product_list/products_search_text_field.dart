import 'package:flutter/material.dart';

class ProductsSearchTextField extends StatefulWidget {
  const ProductsSearchTextField({super.key});

  @override
  State<ProductsSearchTextField> createState() => _ProductsSearchTextFieldState();
}

class _ProductsSearchTextFieldState extends State<ProductsSearchTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
            onChanged: (value) {
              //TODO
              debugPrint(value);
            },
            controller: _controller,
            autofocus: false,
            style: Theme.of(context).textTheme.headline6,
            decoration: InputDecoration(
              hintText: 'Search products',
              icon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _controller.clear();
                      },
                      icon: const Icon(Icons.clear))
                  : null,
            ));
      },
    );
  }
}
