import 'package:flutter/material.dart';
import 'package:xlo/models/user.dart';

class UserTypeWidget extends StatelessWidget {
  final FormFieldSetter onSaved;
  final UserType initialValue;

  const UserTypeWidget({Key key, this.onSaved, this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormField(
          initialValue: initialValue,
          onSaved: onSaved,
          builder: (state) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Particular",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Radio<UserType>(
                        value: UserType.PARTICULAR,
                        groupValue: state.value,
                        onChanged: state.didChange,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Professional",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Radio<UserType>(
                        value: UserType.PROFESSIONAL,
                        groupValue: state.value,
                        onChanged: state.didChange,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
