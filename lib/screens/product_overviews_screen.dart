import 'package:flutter/material.dart';
import '../components/productGrid.dart';

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha loja'),
        centerTitle: true,
      ),
      body: ProductGrid(),
    );
  }
}
