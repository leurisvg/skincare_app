import 'package:flutter/material.dart';
import 'package:skincare_products/products.dart';

class StateProvider extends ChangeNotifier {
  bool _initAnimation = false;
  List<SkinProduct> _cart = [];
  double _total = 0;
  double _delivery = 5;
  bool _homeOpacity = false;

  StateProvider() {
    this._total = this._delivery;
  }

  bool get initAnimation => this._initAnimation;
  set initAnimation(bool value) {
    this._initAnimation = value;
    notifyListeners();
  }

  List<SkinProduct> get cart => this._cart;
  void addItem(SkinProduct item) {
    this._cart.add(item);
    notifyListeners();

    total = item.price;
  }

  double get total => this._total;
  set total(double value) {
    this._total += value;
    notifyListeners();
  }

  bool get homeOpacity => this._homeOpacity;
  set homeOpacity(bool value) {
    this._homeOpacity = value;
    notifyListeners();
  }

  double get delivery => this._delivery;
}
