import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_lista.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overviews_screen.dart';
import 'package:shop/util/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL:(context) => ProductDetailScreen(),
        },
      ),
    );
  }
}
