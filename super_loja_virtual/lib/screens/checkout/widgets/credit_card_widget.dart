import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:super_loja_virtual/models/checkout/credit_card.dart';
import 'package:super_loja_virtual/screens/checkout/widgets/card_front.dart';
import 'package:super_loja_virtual/screens/checkout/widgets/cart_back.dart';

class CreditCardWidget extends StatefulWidget {
  final CreditCard creditCard;

  const CreditCardWidget({this.creditCard});

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        keyboardBarColor: Colors.grey[200],
        actions: [
          KeyboardActionsItem(
            focusNode: numberFocus,
            displayDoneButton: false,
          ),
          KeyboardActionsItem(
            focusNode: dateFocus,
            displayDoneButton: false,
          ),
          KeyboardActionsItem(focusNode: nameFocus, toolbarButtons: [
            (_) {
              return GestureDetector(
                onTap: () {
                  cardKey.currentState.toggleCard();
                  cvvFocus.requestFocus();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('Continuar'),
                ),
              );
            }
          ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlipCard(
              key: cardKey,
              flipOnTouch: false,
              direction: FlipDirection.HORIZONTAL,
              speed: 700,
              front: CardFront(
                creditCard: widget.creditCard,
                numberFocus: numberFocus,
                dateFocus: dateFocus,
                nameFocus: nameFocus,
                finished: () {
                  cardKey.currentState.toggleCard();
                  cvvFocus.requestFocus();
                },
              ),
              back: CardBack(
                creditCard: widget.creditCard,
                cvvFocus: cvvFocus,
              ),
            ),
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                cardKey.currentState.toggleCard();
              },
              child: const Text('Virar cartão'),
            )
          ],
        ),
      ),
    );
  }
}
