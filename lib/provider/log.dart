part of 'provider.dart';

class Log extends ChangeNotifier {
  final List<String> _logs = [];

  List<String> get logs => _logs;

  void addLog(String log) {
    _logs.add(log);
    notifyListeners();
  }
}
