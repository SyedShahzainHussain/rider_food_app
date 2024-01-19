import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_panda_app/global/global.dart';
import 'package:rider_panda_app/maps/map_utils.dart';
import 'package:rider_panda_app/view/my_splash_screen/my_splash_screen.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId, purchaserAddress, sellerId, getOrderId;
  final double? purchaserLat, purchaserLng;

  ParcelDeliveringScreen(
      {super.key,
      this.purchaserId,
      this.purchaserAddress,
      this.sellerId,
      this.getOrderId,
      this.purchaserLat,
      this.purchaserLng});

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = "";

  confirmParcelDelivered({
    String? orderId,
    String? sellerId,
    String? purchasedId,
    String? puchasedAddress,
    double? purchasedLat,
    double? purchasedLng,
  }) {
    String riderNewTotalAmount = ((double.parse(previousRiderEarning!)) +
            (double.parse(perPlaceDeliveryAmount!)))
        .toString();
    FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "ended",
      "address": address,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earnings": perPlaceDeliveryAmount, // ! pay per delivery
    }).then((value) {
      FirebaseFirestore.instance
          .collection("riders")
          .doc(sharedPreferences!.getString("uid"))
          .update({
        "earnings": riderNewTotalAmount, // ! total amount of rider
      });
    }).then((value) {
      FirebaseFirestore.instance.collection("sellers").doc(sellerId).update({
        "earnings":
            (double.parse(orderTotalAmount) + (double.parse(previousEarning!)))
                .toString(), // ! total earnings of seller
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(purchasedId)
          .collection("orders")
          .doc(orderId)
          .update({
        "status": "ended",
        "riderUID": sharedPreferences!.getString("uid")
      });
    }).then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false));
  }

  // ! get order total amount

  getOrderTotalAmount() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderId)
        .get()
        .then((value) {
      orderTotalAmount = value.data()!["totalAmount"].toString();
      widget.sellerId = value.data()!["sellerUID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  // ! getSellerData
  getSellerData() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((value) {
      previousEarning = value.data()!["earnings"].toString();
    });
  }

  // ! getRiderData
  getRiderData() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((value) {
      previousRiderEarning = value.data()!["earnings"].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderTotalAmount();
    getRiderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/confirm2.png",
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            MapUtils.launchMapFromSourceToDestiantion(
              position!.latitude,
              position!.longitude,
              widget.purchaserLat,
              widget.purchaserLng,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/restaurant.png",
                width: 50,
              ),
              const SizedBox(
                width: 7,
              ),
              const Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Show Delivery Drop -off Location",
                    style: TextStyle(
                      fontFamily: "Signatra",
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: InkWell(
            onTap: () {
              getCurrentLocation().then((value) {
                return confirmParcelDelivered(
                  orderId: widget.getOrderId,
                  puchasedAddress: widget.purchaserAddress,
                  purchasedId: widget.purchaserId,
                  purchasedLat: widget.purchaserLat,
                  purchasedLng: widget.purchaserLng,
                  sellerId: widget.sellerId,
                );
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.amber],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              width: MediaQuery.sizeOf(context).width - 90,
              height: 50,
              child: const Center(
                child: FittedBox(
                  child: Text(
                    "Order has been Deleivered - Confirmed",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
