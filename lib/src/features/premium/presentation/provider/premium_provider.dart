import 'package:flutter/foundation.dart';
import '../../data/purchase_api.dart';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future<void> init() async {
    _isPremium = await PurchaseApi.isPremium();
    notifyListeners();
  }
}
