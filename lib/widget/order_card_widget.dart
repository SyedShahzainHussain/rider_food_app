import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_panda_app/model/item_model.dart';
import 'package:rider_panda_app/view/order_detail_screen/order_detail_screen.dart';

class OrderWidget extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderId;
  final List<String>? separateQuantitiesList;

  const OrderWidget({
    super.key,
    this.itemCount,
    this.data,
    this.orderId,
    this.separateQuantitiesList,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailScreen(orderId: orderId)));
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.cyan, Colors.amber],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: itemCount! * 125,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ItemModel itemModel =
                ItemModel.fromJson(data![index].data() as Map<String, dynamic>);
            return placedOrderWidgetDesign(
              itemModel,
              context,
              separateQuantitiesList![index],
            );
          },
          itemCount: itemCount,
        ),
      ),
    );
  }
}

Widget placedOrderWidgetDesign(
    ItemModel itemModel, BuildContext context, separateQuantityList) {
  return Container(
    width: double.infinity,
    height: 120,
    color: Colors.grey[200],
    child: Row(children: [
      CachedNetworkImage(imageUrl: itemModel.thumbnailUrl!),
      const SizedBox(
        width: 10.0,
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  itemModel.itemTitle!,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Rs",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Colors.blue),
              ),
              Text(
                itemModel.price.toString(),
                style: const TextStyle(color: Colors.blue, fontSize: 18.0),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "x ",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.black54,
                    ),
              ),
              Expanded(
                child: Text(
                  separateQuantityList,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 30,
                        fontFamily: "Acme",
                      ),
                ),
              ),
            ],
          ),
        ],
      ))
    ]),
  );
}
