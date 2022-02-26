import 'package:rxdart/rxdart.dart';

class BlocController {
  BehaviorSubject<bool> _controller = BehaviorSubject.seeded(false);

  Stream<bool> get opened => _controller.stream;

  Sink<bool> get changeOpened => _controller.sink;

  dispose() {
    _controller.close();
  }

  void toggle() {
    _controller.add(!(_controller.value));
    Future.delayed(const Duration(seconds: 5)).then((_) => close());
  }

  void close() {
    _controller.add(false);
  }
}
