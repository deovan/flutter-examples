import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_loja_virtual/models/checkout/credit_card.dart';
import 'package:super_loja_virtual/screens/checkout/widgets/card_text_field.dart';

class CardBack extends StatelessWidget {
  final FocusNode cvvFocus;

  final CreditCard creditCard;

  const CardBack({Key key, this.cvvFocus, this.creditCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        color: Theme.of(context).primaryColor.withAlpha(100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.black,
              height: 40,
              margin: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(
                      left: 12,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    color: Colors.grey[500],
                    child: CardTextField(
                      hint: '123',
                      maxLength: 3,
                      initialValue: creditCard.securityCode,
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      validator: (cvv) {
                        if(cvv==null){
                          return 'Campo Obrigatório';
                        }
                        if (cvv.length != 3) {
                          return "Inválido";
                        }
                        return null;
                      },
                      focusNode: cvvFocus,
                      onSaved: creditCard.setCVV,
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
