import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  final String title;
  final String hint;
  final bool bold;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final TextAlign textAlign;
  final int maxLength;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const CardTextField({
    this.title,
    this.bold,
    this.hint,
    this.textInputType,
    this.inputFormatters,
    this.validator,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.onSubmitted,
    this.onSaved,
    this.initialValue,
  }) : textInputAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      initialValue: initialValue,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null)
                Row(
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (state.hasError)
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          state.errorText,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          ),
                        ),
                      )
                  ],
                ),
              TextFormField(
                textAlign: textAlign,
                cursorColor: Colors.white,
                initialValue: initialValue,
                maxLength: maxLength,
                style: TextStyle(
                  color: title == null && state.hasError
                      ? Colors.red
                      : Colors.white,
                  fontWeight: bold != null && bold == true
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  hintText: hint,
                  counterText: '',
                  hintStyle: TextStyle(
                    color: title == null && state.hasError
                        ? Colors.red.withAlpha(200)
                        : Colors.white.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                focusNode: focusNode,
                onChanged: (v) {
                  state.didChange(v);
                },
                onSaved: onSaved,
                onFieldSubmitted: onSubmitted,
              )
            ],
          ),
        );
      },
    );
  }
}
