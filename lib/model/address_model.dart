class Address {
  String? name;
  String? phone;
  String? fulladdress;
  String? city;
  String? state;
  String? flatNumber;
  double? lat;
  double? lng;

  Address(
      {this.name,
      this.phone,
      this.fulladdress,
      this.city,
      this.state,
      this.flatNumber,
      this.lat,
      this.lng});

  Address.fromJson(Map<String, dynamic> json) {
    name = json["name"].trim();
    phone = json["phone"].trim();
    fulladdress = json["fulladdress"].trim();
    city = json["city"].trim();
    state = json["state"].trim();
    flatNumber = json["flatNumber"].trim();
    lat = json["lat"];
    lng = json["lng"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json["name"] = name;
    json["phone"] = phone;
    json["fulladdress"] = fulladdress;
    json["city"] = city;
    json["flatNumber"] = flatNumber;
    json["state"] = state;
    json["lat"] = lat;
    json["lng"] = lng;
    return json;
  }
}
