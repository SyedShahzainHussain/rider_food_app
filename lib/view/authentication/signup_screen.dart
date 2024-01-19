import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rider_panda_app/viewModel/auth_view_model/sign_up_view_model.dart';
import 'package:rider_panda_app/widget/alert_dialog.dart';
import 'package:rider_panda_app/widget/custom_text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  XFile? imageXFile;
  final ImagePicker picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();

  final ValueNotifier<bool> password = ValueNotifier<bool>(true);
  final ValueNotifier<bool> confirmPassword = ValueNotifier<bool>(true);

  Position? position;
  List<Placemark>? placemark;
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              getImage();
            },
            child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
                    ? const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.grey,
                      )
                    : null),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              CustomTextField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(emailFocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a Name";
                  }
                  return null;
                },
                icon: Icons.person,
                controller: nameController,
                hintText: "Name",
                isObsecure: false,
              ),
              CustomTextField(
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(passwordFocus);
                },
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a Email";
                  } else if (!value.contains("@")) {
                    return "Enter a Special Character @";
                  }
                  return null;
                },
                icon: Icons.email,
                controller: emailController,
                hintText: "Email",
                isObsecure: false,
              ),
              ValueListenableBuilder(
                valueListenable: password,
                builder: (context, value, _) => CustomTextField(
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(confirmPasswordFocus);
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: passwordFocus,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        password.value = !password.value;
                      },
                      child: value
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.cyan,
                            )
                          : const Icon(Icons.visibility, color: Colors.cyan)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a Password";
                    }
                    return null;
                  },
                  icon: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecure: value,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: confirmPassword,
                builder: (context, value, _) => CustomTextField(
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(phoneFocus);
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: confirmPasswordFocus,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        confirmPassword.value = !confirmPassword.value;
                      },
                      child: value
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.cyan,
                            )
                          : const Icon(Icons.visibility, color: Colors.cyan)),
                  validator: (value) {
                    if (value!.isEmpty ||
                        passwordController.text != confirmController.text) {
                      return "Enter a Correct Password";
                    }
                    return null;
                  },
                  icon: Icons.lock,
                  controller: confirmController,
                  hintText: "Confirm Password",
                  isObsecure: value,
                ),
              ),
              CustomTextField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: phoneFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a Phone Number";
                  }
                  return null;
                },
                icon: Icons.phone,
                controller: phoneController,
                hintText: "Phone",
                isObsecure: false,
              ),
              CustomTextField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Click to get current location";
                  }
                  return null;
                },
                icon: Icons.my_location,
                controller: locationController,
                hintText: "Cafe/Resturant Address",
                isObsecure: false,
                enabled: false,
              ),
              Container(
                width: 400,
                height: 40,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Get my Current Lcoation",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    backgroundColor: Colors.cyan,
                  ),
                  onPressed: () {
                    saveData();
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ]),
          )
        ],
      ),
    );
  }

  // ! save Data
  void saveData() {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    if (imageXFile == null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const ErrorDialog(
                message: "Pick An Image",
              ));
    }
    if (validate) {
      _formKey.currentState!.save();
      context.read<SignUpViewModel>().signUpSellers(
            context,
            imageXFile,
            emailController.text,
            passwordController.text,
            nameController.text,
            locationController.text,
            phoneController.text,
            position,
          );
    }
  }

  // ! pick image
  Future<void> getImage() async {
    imageXFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  // ! get current Location
  getCurrentLocation() async {
    bool servicesEnabled;
    LocationPermission locationPermission;
    servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please keep your Location on",
            );
          });
    }
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "Location Permission denied",
              );
            });
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Permission denied Forever",
            );
          });
    }

    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    placemark =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark placemarks = placemark![0];
    String completeAddres =
        "${placemarks.subThoroughfare} ${placemarks.thoroughfare}, ${placemarks.subLocality} ${placemarks.locality}, ${placemarks.subAdministrativeArea} ${placemarks.administrativeArea}, ${placemarks.postalCode}, ${placemarks.country}";

    locationController.text = completeAddres;
  }
}
