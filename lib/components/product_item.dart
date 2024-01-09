import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/util/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            //Edit button
            IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              color: Theme.of(context).colorScheme.primary,
              onPressed: (() {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCTS_FORM,
                  arguments: product,
                );
              }),
            ),

            //Delete Button
            IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              color: Theme.of(context).colorScheme.error,
              onPressed: (() {}),
            ),
          ],
        ),
      ),
    );
  }
}
