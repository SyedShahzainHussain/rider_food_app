import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_panda_app/global/global.dart';
import 'package:rider_panda_app/view/history_screen/history_screen.dart';
import 'package:rider_panda_app/view/my_splash_screen/my_splash_screen.dart';
import 'package:rider_panda_app/view/not_yet_deleivered/not_yet_delivered_screen.dart';
import 'package:rider_panda_app/view/order_screen/order_screen.dart';
import 'package:rider_panda_app/view/parcel_in_progress/parcel_in_progress.dart';
import 'package:rider_panda_app/view/total_earning/total_earning.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  // ! per deleivery charges
  Future<void> getPerParcelDeliveryAmount() async {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("Aiza12345")
        .get()
        .then((value) {
      perPlaceDeliveryAmount = value.data()!["amount"].toString();
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

  Widget makeDashboardItem(String title, IconData icondata, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.amber,
                      Colors.cyan,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.redAccent,
                      Colors.amber,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              // ! New Available Order
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const OrderScreen()));
            }
            if (index == 1) {
              // ! Parcel in Progress
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ParcelInProgress()));
            }
            if (index == 2) {
              // ! Not Yet Delivered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotYetDeliveredScreen()));
            }
            if (index == 3) {
              // ! History
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            }
            if (index == 4) {
              // ! Total Earning
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TotalEarnings()));
            }
            if (index == 5) {
              // ! Logout
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              });
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Icon(
                  icondata,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              Center(
                child: Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderData();
    checkUserIsBlock();
  }

  checkUserIsBlock() async {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        Fluttertoast.showToast(msg: "you have been blocked");
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.amber],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text(
            "Welcome ${sharedPreferences?.getString("name") ?? ""}",
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontFamily: "Signatra"),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(2),
            children: [
              makeDashboardItem("New Available Orders", Icons.assignment, 0),
              makeDashboardItem("Parcel in Progress", Icons.airport_shuttle, 1),
              makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
              makeDashboardItem("History", Icons.done_all, 3),
              makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
              makeDashboardItem("Logout", Icons.logout, 5),
            ],
          ),
        ));
  }
}
