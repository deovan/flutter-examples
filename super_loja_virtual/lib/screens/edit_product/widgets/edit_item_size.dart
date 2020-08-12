import 'package:flutter/material.dart';
import 'package:super_loja_virtual/common/custom_icon_button.dart';
import 'package:super_loja_virtual/models/product/item_size.dart';

class EditItemSize extends StatelessWidget {
  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  const EditItemSize(
      {Key key, this.size, this.onRemove, this.onMoveUp, this.onMoveDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size?.name,
            validator: (name) {
              if (name.isEmpty) {
                return "Inválido";
              }
              return null;
            },
            onChanged: (name) => size.name = name,
            decoration: const InputDecoration(
              labelText: "Título",
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            keyboardType: TextInputType.number,
            validator: (estoque) {
              if (int.tryParse(estoque) == null) {
                return "Inválido";
              }
              return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
            decoration: const InputDecoration(
              labelText: "Estoque",
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (preco) {
              if (num.tryParse(preco) == null) {
                return "Inválido";
              }
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
            decoration: const InputDecoration(
                labelText: "Preço", isDense: true, prefixText: "R\$"),
          ),
        ),
        CustomIconButton(
          onTap: onRemove,
          iconData: Icons.remove,
          color: Colors.red,
        ),
        CustomIconButton(
          onTap: onMoveUp,
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
        ),
        CustomIconButton(
          onTap: onMoveDown,
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
        ),
      ],
    );
  }
}
