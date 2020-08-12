import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/admin/admin_orders_manager.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';
import 'package:super_loja_virtual/models/checkout/orders_manager.dart';
import 'package:super_loja_virtual/models/stores/stores_manager.dart';
import 'package:super_loja_virtual/models/user/user_manager.dart';
import 'package:super_loja_virtual/screens/address/address_screen.dart';
import 'package:super_loja_virtual/screens/base/base_screen.dart';
import 'package:super_loja_virtual/screens/cart/cart_screen.dart';
import 'package:super_loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:super_loja_virtual/screens/confirmation/confirmation_screen.dart';
import 'package:super_loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:super_loja_virtual/screens/login/login_screen.dart';
import 'package:super_loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:super_loja_virtual/screens/signup/signup_screen.dart';

import 'models/admin/admin_users_manager.dart';
import 'models/cart/cart_manager.dart';
import 'models/home/home_manager.dart';
import 'models/product/product.dart';
import 'models/product/product_manager.dart';
import 'screens/product/product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) => adminOrdersManager
            ..updateAdmin(
              adminEnabled: userManager.adminEnabled,
            ),
        ),
      ],
      child: MaterialApp(
        title: 'Loja X',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurpleAccent,
          scaffoldBackgroundColor: Colors.deepPurple.withAlpha(500),
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/login":
              return MaterialPageRoute(
                builder: (context) => LoginScreen(),
              );
            case "/signup":
              return MaterialPageRoute(
                builder: (context) => SignupScreen(),
              );
            case "/product":
              return MaterialPageRoute(
                builder: (context) =>
                    ProductScreen(settings.arguments as Product),
              );
            case "/edit_product":
              return MaterialPageRoute(
                builder: (context) =>
                    EditProductScreen(settings.arguments as Product),
              );
            case "/cart":
              return MaterialPageRoute(
                builder: (context) => CartScreen(),
                settings: settings,
              );
            case "/address":
              return MaterialPageRoute(
                builder: (context) => AddressScreen(),
              );
            case "/checkout":
              return MaterialPageRoute(
                builder: (context) => CheckoutScreen(),
              );
            case "/confirmation":
              return MaterialPageRoute(
                builder: (context) =>
                    ConfirmationScreen(settings.arguments as Order),
              );
            case "/select_product":
              return MaterialPageRoute(
                builder: (context) => SelectProductScreen(),
              );
            case "/":
            default:
              return MaterialPageRoute(
                builder: (context) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
