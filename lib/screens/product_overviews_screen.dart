import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_lista.dart';
import '../components/productGrid.dart';


 enum FilterOptions{
  favorite,
  all,
}

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha loja'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favorito'),
                value: FilterOptions.favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.all,
              ),
            ],
            onSelected: (FilterOptions selectedValue){
              if(selectedValue == FilterOptions.favorite){
                provider.showFavoriteOnly();
              }
              else{
                provider.showAll();
              }
            },
          )
        ],
      ),
      body: ProductGrid(),
    );
  }
}
