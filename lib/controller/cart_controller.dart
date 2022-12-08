import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:need_to/models/cart_model.dart';

import '../models/user_model.dart';

class CartController extends GetxController {
  var numberOfItemsInCart = 0.obs;
  var totalAmount = 1.obs;
  var totalQty = 1.obs;
  var qt = 1.obs;
  var quantity = 0.obs;
  var currentP = 0;

  var _inCartItems = 0.obs;
  get inCartItems => _inCartItems.value + quantity.value;

  var CartItemList = <BestsellerProduct>[].obs;
  void removeItem() {
    if (qt.value > 1) {
      totalQty.value--;
      qt.value--;
    }
  }

  void addItem() {
    totalQty.value++;
    qt.value++;
  }

  void addToCartList(BestsellerProduct product) {
    if (!CartItemList.contains(product)) {
      CartItemList.add(product);

      numberOfItemsInCart++;

      update();
    } else {
      print(currentP.toString());
      Get.snackbar("Cart!", "product already in cart",
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 10,
          colorText: Colors.white,
          borderColor: Colors.black,
          borderWidth: 2,
          barBlur: 0);
    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      quantity.value = CheckboxQuantity(quantity.value + 1);
      print(quantity);
    } else {
      quantity = quantity - 1;
      quantity.value = CheckboxQuantity(quantity.value - 1);
      print(quantity);
    }
  }

//need to check for error
  int CheckboxQuantity(int quantity) {
    if ((_inCartItems + quantity) < 0) {
      Get.snackbar("Item count", "Can't reduce more!",
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 10,
          colorText: Colors.white,
          borderColor: Colors.black,
          borderWidth: 2,
          barBlur: 0);
      return 0;
    } else if (_inCartItems + quantity > 20) {
      Get.snackbar("Item count", "Can't add more!",
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 10,
          colorText: Colors.white,
          borderColor: Colors.black,
          borderWidth: 2,
          barBlur: 0);

      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct() {
    quantity.value = 0;
    _inCartItems.value = 0;
    //get fromstroage
  }

// adding items to cart
  Map<int, CartModel> _items = {};
  Map<int, CartModel> get items => _items;

  void addItems(BestsellerProduct product, int quantity) {
    if (_items.containsKey(product.id!)) {
      _items.update(product.id!, (value) {
        return CartModel(
          id: value.id,
          name: value.name,
          price: value.price,
          img: value.img,
          quantity: value.quantity! + quantity,
          isExist: true,
          time: DateTime.now().toString(),
          product: product,
        );
      });
    } else {
      _items.putIfAbsent(
        product.id!,
        () {
          print(product.name);
          return CartModel(
              id: product.id,
              name: product.name,
              price: product.price,
              img: product.image,
              quantity: quantity,
              isExist: true,
              time: DateTime.now().toString(),
              product: product);
        },
      );
    }
    update();
    print(_items.toString());
  }

  void additemToCart(
    BestsellerProduct product,
  ) {
    if (quantity > -1) {
      addItems(product, quantity.value);
      quantity.value = 0;

      items.forEach((key, value) {
        print("The id is " + value.name.toString());
      });
    } else {
      Get.snackbar("Item count", "Add at least one item",
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 10,
          colorText: Colors.white,
          borderColor: Colors.black,
          borderWidth: 2,
          barBlur: 0);
    }
  }

  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  List<CartModel> get getItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  List<CartModel> get getItemsForCart {
    return getItems;
  }
}
