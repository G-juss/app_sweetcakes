import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrito')),
      body: Center(child: Text('Aquí va la lista del carrito cuando se vaya agregando la compra')),
    );
  }
}
