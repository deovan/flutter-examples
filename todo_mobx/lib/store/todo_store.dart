import 'package:mobx/mobx.dart';

part 'todo_store.g.dart';

class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  final String title;

  @observable
  bool done = false;

  _TodoStore(this.title);

  @action
  void toggleDone() => done = !done;
}
