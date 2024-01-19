import 'package:flutter/foundation.dart';

class  OrderViewModel with ChangeNotifier{
  
// ! separated order items quantity
  separateOrderQuantity(separateOrderItemList) {
    List<String> defaultQuantityList = [];
    List<String> separateQuantityList = [];

    defaultQuantityList = List<String>.from(separateOrderItemList);
    int i = 1;
    for (i; i < defaultQuantityList.length; i++) {
      String quantity = defaultQuantityList[i].toString();
      List<String> listQuantity = quantity.split(":").toList();
      int quantityNumber = int.parse(listQuantity.last.toString());
      separateQuantityList.add(quantityNumber.toString());
    }
    return separateQuantityList;
  }

  // ! separated Order Item List
  separateOrderItemsIds(separateOrderItemList) {
    List<String> separateItemList = [], defaultItemList = [];
    int i = 0;
    defaultItemList = List<String>.from(separateOrderItemList);

    for (i; i < defaultItemList.length; i++) {
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");
      String getItemId = (pos != -1) ? item.substring(0, pos) : item;
      separateItemList.add(getItemId.trim());
    }

    return separateItemList;
  }
}