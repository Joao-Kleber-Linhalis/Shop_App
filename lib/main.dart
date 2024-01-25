import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_form_screen.dart';
import 'package:shop/screens/product_overviews_screen.dart';
import 'package:shop/screens/product_screen.dart';
import 'package:shop/util/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          dialogBackgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          
          
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
            background: Colors.white,
            
          ),
          fontFamily: 'Lato',
        ),
        //home: ProductOverviewScreen(),
        routes: {
          AppRoutes.AUTH:(context) => AuthScreen(),
          AppRoutes.HOME:(context) => ProductOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (context) => ProductDetailScreen(),
          AppRoutes.CART:(context) => CartScreen(),
          AppRoutes.ORDERS:(context) => OrdersScreen(),
          AppRoutes.PRODUCTS:(context) => ProductScreen(),
          AppRoutes.PRODUCTS_FORM:(context) => ProductFormScreen(),
        },
      ),
    );
  }
}
