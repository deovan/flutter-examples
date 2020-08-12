import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/common/custom_icon_button.dart';
import 'package:super_loja_virtual/models/product/item_size.dart';
import 'package:super_loja_virtual/models/product/product.dart';
import 'package:super_loja_virtual/screens/edit_product/widgets/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;

  const SizesForm({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) {
          return "Insira um tamanho";
        }
        return null;
      },
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Tamanhos",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value
                  .map<Widget>(
                    (size) => EditItemSize(
                      key: ObjectKey(size),
                      size: size,
                      onRemove: () {
                        state.value.remove(size);
                        state.didChange(state.value);
                      },
                      onMoveUp: size != state.value.first
                          ? () {
                              final index = state.value.indexOf(size);
                              state.value.remove(size);
                              state.value.insert(index - 1, size);
                              state.didChange(state.value);
                            }
                          : null,
                      onMoveDown: size != state.value.last
                          ? () {
                              final index = state.value.indexOf(size);
                              state.value.remove(size);
                              state.value.insert(index + 1, size);
                              state.didChange(state.value);
                            }
                          : null,
                    ),
                  )
                  .toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
