import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rider_panda_app/model/address_model.dart';
import 'package:rider_panda_app/view/home_screen/home_screen.dart';
import 'package:rider_panda_app/widget/progress_dialog.dart';
import 'package:rider_panda_app/widget/shipping_details_widget.dart';
import 'package:rider_panda_app/widget/status_banner_widget.dart';

class OrderDetailScreen extends StatefulWidget {
  final String? orderId;
  const OrderDetailScreen({super.key, this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String orderStatus = "";
  String userId = "";
  String sellerId = "";
  
  getOrderInfo() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .get()
        .then((value) => {
              orderStatus = value.data()!["status"].toString(),
              userId = value.data()!["orderBy"].toString(),
              sellerId = value.data()!["sellerUID"].toString(),
            });
  }

  @override
  void initState() {
    super.initState();
    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
          return true;
        },
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.orderId)
                  .get(),
              builder: (context, snapshot) {
                Map? dataMap;
                if (snapshot.hasData) {
                  dataMap = snapshot.data!.data()!;
                  orderStatus = dataMap["status"];
                }
                return snapshot.hasData
                    ? Column(
                        children: [
                          StatusBanner(
                            orderStatus: orderStatus,
                            status: dataMap!["isSuccess"],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Rs ${dataMap["totalAmount"]}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Text(
                            "Order Id = ${widget.orderId}",
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Order at: ${DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.parse(dataMap["orderTime"]))}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Divider(
                            thickness: 4,
                          ),
                          orderStatus == "ended"
                              ? Image.asset("assets/images/success.jpg")
                              : Image.asset("assets/images/confirm_pick.png"),
                          const Divider(
                            thickness: 4,
                          ),
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(userId)
                                  .collection("userAddress")
                                  .doc(dataMap["addressID"])
                                  .get(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ShippingDetailsWidget(
                                        address: Address.fromJson(
                                            snapshot.data!.data()!),
                                            orderStatus: orderStatus,
                                            orderId: widget.orderId,

                                            userId:userId,
                                            sellerId:sellerId,
                                      )
                                    : Center(
                                        child: circularProgress(),
                                      );
                              })
                        ],
                      )
                    : const SizedBox.shrink();
              }),
        ),
      ),
    );
  }
}
