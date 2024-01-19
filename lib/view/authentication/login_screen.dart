import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_panda_app/viewModel/auth_view_model/login_view_model.dart';
import 'package:rider_panda_app/widget/custom_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> password = ValueNotifier<bool>(true);
  FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "assets/images/signup.png",
                height: 250,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a email address";
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a password";
                      }
                      return null;
                    },
                    icon: Icons.lock,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        password.value = !password.value;
                      },
                      child: value
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.cyan,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: Colors.cyan,
                            ),
                    ),
                    controller: passwordController,
                    hintText: "Password",
                    isObsecure: value,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                backgroundColor: Colors.cyan,
              ),
              onPressed: () {
                saveData();
              },
              child: const Text(
                "Log In",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  // ! save data
  void saveData() {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    if (validate) {
      context.read<LoginViewModel>().loginData(
          context, emailController.text.trim(), passwordController.text.trim());
    }
  }
}
