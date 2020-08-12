import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:super_loja_virtual/models/checkout/credit_card.dart';
import 'package:super_loja_virtual/screens/checkout/widgets/card_text_field.dart';

class CardFront extends StatelessWidget {
  final MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  final FocusNode numberFocus;

  final FocusNode dateFocus;
  final FocusNode nameFocus;

  final VoidCallback finished;
  final CreditCard creditCard;

  CardFront(
      {Key key,
      this.numberFocus,
      this.dateFocus,
      this.nameFocus,
      this.finished,
      this.creditCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 200,
        color: Theme.of(context).primaryColor.withAlpha(700),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CardTextField(
                    title: "Número",
                    hint: "0000 0000 0000 0000",
                    initialValue: creditCard.number,
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    validator: (numero) {
                      if(numero==null){
                        return 'Campo Obrigatório';
                      }
                      if (numero.length != 19 ||
                          detectCCType(numero) == CreditCardType.unknown) {
                        return 'Inválido';
                      }
                      return null;
                    },
                    onSubmitted: (_) {
                      dateFocus.requestFocus();
                    },
                    onSaved: creditCard.setNumber,
                    focusNode: numberFocus,
                  ),
                  CardTextField(
                    title: "Válidade",
                    hint: "11/2020",
                    initialValue: creditCard.expirationDate,
                    textInputType: TextInputType.number,
                    bold: false,
                    inputFormatters: [
                      dateFormatter,
                    ],
                    validator: (validade) {
                      if(validade==null){
                        return 'Campo Obrigatório';
                      }
                      if (validade.isEmpty || validade.length != 7) {
                        return "Inválido";
                      }
                      return null;
                    },
                    onSubmitted: (_) {
                      nameFocus.requestFocus();
                    },
                    onSaved: creditCard.setExpirationDate,
                    focusNode: dateFocus,
                  ),
                  CardTextField(
                    title: "Titular",
                    hint: "João da Silva",
                    initialValue: creditCard.holder,
                    textInputType: TextInputType.text,
                    bold: true,
                    validator: (n) {
                      if(n==null){
                        return 'Campo Obrigatório';
                      }
                      if (n.isEmpty) {
                        return 'Inválido';
                      }
                      return null;
                    },
                    onSubmitted: (_) {
                      finished();
                    },
                    onSaved: creditCard.setHolder,
                    focusNode: nameFocus,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.credit_card,
              color: Colors.white,
              size: 36,
            )
          ],
        ),
      ),
    );
  }
}
