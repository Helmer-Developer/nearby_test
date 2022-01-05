part of 'provider.dart';

class Me extends ChangeNotifier {
  String _ownId = '';
  String _ownName = '';

  String get ownId => _ownId;
  String get ownName => _ownName;
  set ownId(String ownId) {
    _ownId = ownId;
    notifyListeners();
  }

  set ownName(String ownName) {
    _ownName = ownName;
    notifyListeners();
  }
}
