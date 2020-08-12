import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  final TextInputType type;

  const InputField(
      {Key key,
      this.icon,
      this.hint,
      this.obscure,
      this.stream,
      this.onChanged,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent),
          ),
          contentPadding:
              EdgeInsets.only(left: 5, right: 24, bottom: 24, top: 24),
          errorText: snapshot.hasError ? snapshot.error : null,
          errorMaxLines: 2,
        ),
        style: TextStyle(
          color: Colors.white,
        ),
        obscureText: obscure,
        keyboardType: type,
      ),
    );
  }
}
