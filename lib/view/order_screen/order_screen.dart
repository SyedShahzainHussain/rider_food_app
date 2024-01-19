import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_panda_app/viewModel/order_viewModel/order_view_model.dart';
import 'package:rider_panda_app/widget/order_card_widget.dart';
import 'package:rider_panda_app/widget/progress_dialog.dart';

class OrderScreen extends StatelessWidget {
  const   OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
        title: const Text(
          "Order",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("status", isEqualTo: "normal")
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("items")
                              .where("itemID",
                                  whereIn: context
                                      .read<OrderViewModel>()
                                      .separateOrderItemsIds(snapshot
                                          .data!.docs[index]
                                          .data()["productsIDs"]))
                              .orderBy("publishedDate", descending: true)
                              .get(),
                          builder: (context, snapshot2) {
                            return snapshot2.hasData
                                ? OrderWidget(
                                    itemCount: snapshot2.data!.docs.length,
                                    orderId: snapshot.data!.docs[index]
                                        ["orderId"],
                                    data: snapshot2.data!.docs,
                                    separateQuantitiesList: context
                                        .read<OrderViewModel>()
                                        .separateOrderQuantity(snapshot
                                            .data!.docs[index]
                                            .data()["productsIDs"]),
                                  )
                                : const SizedBox.shrink();
                          });
                    },
                    itemCount: snapshot.data!.docs.length,
                  )
                : Center(
                    child: circularProgress(),
                  );
          }),
    );
  }
}
