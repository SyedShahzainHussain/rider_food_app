import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_panda_app/global/global.dart';
import 'package:rider_panda_app/model/address_model.dart';
import 'package:rider_panda_app/view/home_screen/home_screen.dart';
import 'package:rider_panda_app/view/parcel_picking_screen/parcel_picking_screen.dart';

class ShippingDetailsWidget extends StatefulWidget {
  final Address? address;
  final String? orderStatus, orderId, userId, sellerId;

  const ShippingDetailsWidget(
      {super.key,
      this.address,
      this.orderStatus,
      this.orderId,
      this.userId,
      this.sellerId});

  @override
  State<ShippingDetailsWidget> createState() => _ShippingDetailsWidgetState();
}

class _ShippingDetailsWidgetState extends State<ShippingDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Shipping details:",
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
          width: MediaQuery.sizeOf(context).width,
          child: Table(
            children: [
              TableRow(children: [
                const Text(
                  "Name",
                  style: TextStyle(color: Colors.black),
                ),
                Text(widget.address!.name!)
              ]),
              TableRow(children: [
                const Text(
                  "Phone Number",
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(widget.address!.phone!)
              ]),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "${widget.address!.fulladdress}",
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        widget.orderStatus == "ended"
            ? const SizedBox.shrink()
            : Center(
                child: InkWell(
                  onTap: () {
                    getCurrentLocation().then((value) {
                      confirmParcelShiping(
                        context,
                        widget.sellerId!,
                        widget.orderId!,
                        widget.userId!,
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
                    width: MediaQuery.sizeOf(context).width - 40,
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Confirm - To Deliver this Parcel",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 5),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
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
              width: MediaQuery.sizeOf(context).width - 40,
              height: 50,
              child: const Center(
                child: Text(
                  "Go Back",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  confirmParcelShiping(BuildContext context, String sellerId, String orderId,
      String purchasedId) {
    FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "riderUID": sharedPreferences!.getString("uid"),
      "riderName": sharedPreferences!.getString("name"),
      "status": "picking",
      "lat": position!.latitude,
      "lng": position!.longitude,
      "address": address,
    }).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ParcelPicking(
                    purchasedId: purchasedId,
                    purchasedAddress: widget.address!.fulladdress!,
                    purchasedLat: widget.address!.lat,
                    purchasedLng: widget.address!.lng,
                    sellerId: sellerId,
                    orderId: orderId,
                  )));
    });
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position positioned = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = positioned;
    placemarks = await placemarkFromCoordinates(
        positioned.latitude, positioned.longitude);
    Placemark placemark = placemarks![0];

    String fullAddress =
        "${placemark.subThoroughfare} ${placemark.thoroughfare} ${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.locality} ${placemark.subLocality}";
    address = fullAddress;
    setState(() {});
  }
}
