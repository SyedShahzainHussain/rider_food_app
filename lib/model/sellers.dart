class Sellers {
  String? sellerUid;
  String? sellerName;
  String? sellerAvatarUrl;
  String? email;

  Sellers(
    this.sellerUid,
    this.sellerName,
    this.sellerAvatarUrl,
    this.email,
  );

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUid = json["sellerId"];
    sellerName = json["sellerName"];
    sellerAvatarUrl = json["sellerAvatarUrl"];
    email = json["sellerEmail"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json["sellerId"] = sellerUid;
    json["sellerName"] = sellerName;
    json["sellerAvatarUrl"] = sellerAvatarUrl;
    json["sellerEmail"] = sellerAvatarUrl;
    return json;
  }
}
