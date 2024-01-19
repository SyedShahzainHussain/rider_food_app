import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const SpinKitChasingDots(color: Colors.amber),
  );
}