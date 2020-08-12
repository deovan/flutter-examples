bool emailValid(String email) {
  final RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  return regExp.hasMatch(email);
}

String emptyValidator(String text) => text.isEmpty ? 'Campo obrigatório' : null;
