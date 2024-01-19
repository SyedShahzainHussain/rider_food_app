import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_panda_app/global/global.dart';
import 'package:rider_panda_app/maps/map_utils.dart';
import 'package:rider_panda_app/view/parcel_delivering_screen/parcel_delivering_screen.dart';

class ParcelPicking extends StatefulWidget {
  final String? purchasedId, purchasedAddress, sellerId, orderId;
  final double? purchasedLat, purchasedLng;
  const ParcelPicking({
    super.key,
    this.purchasedId,
    this.purchasedAddress,
    this.purchasedLat,
    this.purchasedLng,
    this.sellerId,
    this.orderId,
  });

  @override
  State<ParcelPicking> createState() => _ParcelPickingState();
}

class _ParcelPickingState extends State<ParcelPicking> {
  double? sellerLat, sellerLng;

  getSellerLocation() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((value) {
      sellerLat = value.data()!["lat"];
      sellerLng = value.data()!["lng"];
    });
  }

  @override
  void initState() {
    super.initState();
    getSellerLocation();
  }

  confirmParcelHasBeenPicked({
    String? orderId,
    String? sellerId,
    String? purchasedId,
    String? puchasedAddress,
    double? purchasedLat,
    double? purchasedLng,
  }) {
    FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "delivering",
      "address": address,
      "lat": position!.latitude,
      "lng": position!.longitude,
    }).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ParcelDeliveringScreen(
                
                    purchaserId: purchasedId,
                    purchaserAddress: puchasedAddress,
                    purchaserLat: purchasedLat,
                    purchaserLng: purchasedLng,
                    sellerId: sellerId,
                    getOrderId: orderId,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/confirm1.png",
          width: 350,
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            MapUtils.launchMapFromSourceToDestiantion(
              position!.latitude,
              position!.longitude,
              sellerLat,
              sellerLng,
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
                    "Show Cafe/Resturant Location",
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
                confirmParcelHasBeenPicked(
                  orderId: widget.orderId,
                  puchasedAddress: widget.purchasedAddress,
                  purchasedId: widget.purchasedId,
                  purchasedLat: widget.purchasedLat,
                  purchasedLng: widget.purchasedLng,
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
                    "Order has been Picked Confirmed",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
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
