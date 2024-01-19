import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  String? menuID, menuInfo, menuTitle, status, thumbnailUrl, sellerId;
  Timestamp? publishedDate;
  MenuModel(
    this.menuID,
    this.menuInfo,
    this.menuTitle,
    this.status,
    this.thumbnailUrl,
    this.publishedDate,
    this.sellerId,

  );

  MenuModel.fromJSon(Map<String, dynamic> json) {
    menuID = json["menuID"];
    menuInfo = json["menuInfo"];
    menuTitle = json["menuTitle"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
    publishedDate = json["publishedDate"];
    sellerId = json["sellerID"];
  }
}
