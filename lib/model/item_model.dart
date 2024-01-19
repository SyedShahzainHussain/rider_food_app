import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String? itemDescription,
      itemID,
      itemInfo,
      itemTitle,
      menuID,
      sellerID,
      sellerName,
      status,
      thumbnailUrl;

  Timestamp? publishedDate;
  int? price;

  ItemModel(
    this.itemDescription,
    this.itemID,
    this.itemInfo,
    this.itemTitle,
    this.menuID,
    this.price,
    this.sellerID,
    this.sellerName,
    this.status,
    this.thumbnailUrl,
    this.publishedDate,
  );

  ItemModel.fromJson(Map<String, dynamic> json) {
    itemDescription = json["itemDescription"];
    itemID = json["itemID"];
    itemInfo = json["itemInfo"];
    itemTitle = json["itemTitle"];
    menuID = json["menuID"];
    price = json["price"];
    publishedDate = json["publishedDate"];
    sellerID = json["sellerID"];
    sellerName = json["sellerName"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}
