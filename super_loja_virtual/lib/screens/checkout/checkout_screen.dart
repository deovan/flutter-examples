import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/price_card.dart';
import 'package:super_loja_virtual/models/cart/cart_manager.dart';
import 'package:super_loja_virtual/models/checkout/checkout_manager.dart';
import 'package:super_loja_virtual/models/checkout/credit_card.dart';
import 'package:super_loja_virtual/screens/checkout/widgets/cpf_field.dart';
import 'package:super_loja_virtual/screens/checkout/widgets/credit_card_widget.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      lazy: false,
      update: (context, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Pagamento"),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
              builder: (context, checkoutManager, child) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Processando seu pagamento...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              );
            }
            return Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  CreditCardWidget(
                    creditCard: creditCard,
                  ),
                  CpfField(),
                  PriceCard(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        checkoutManager.checkout(
                            creditCard: creditCard,
                            onStockFail: (e) {
                              Navigator.popUntil(context,
                                  (route) => route.settings.name == '/cart');
                            },
                            onPayFail: (e) {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('$e'),
                                backgroundColor: Colors.red,
                              ));
                            },
                            onSuccess: (order) {
                              Navigator.popUntil(context,
                                  (route) => route.settings.name == '/');

                              Navigator.pushNamed(context, '/confirmation',
                                  arguments: order);
                            });
                      }
                    },
                    buttonText: 'Finalizar Pedido',
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
