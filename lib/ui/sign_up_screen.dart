import 'package:crypto_app/network/response_model.dart';
import 'package:crypto_app/providers/user_data_provider.dart';
import 'package:crypto_app/ui/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Lottie.asset(
            'images/waveloop.json',
            width: double.infinity,
            height: height * 0.2,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Sign Up',
              style: GoogleFonts.ubuntu(
                fontSize: height * 0.035,
                color: Theme.of(context).unselectedWidgetColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Create an account',
              style: GoogleFonts.ubuntu(
                fontSize: height * 0.03,
                color: Theme.of(context).unselectedWidgetColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      } else if (value.length < 4) {
                        return 'Username must be at least 4 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'Username',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your gmail';
                      } else if (!value.endsWith('@gmail.com')) {
                        return 'please enter valid gmail';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.email_rounded),
                      hintText: 'gmail',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 7) {
                        return 'Password must be at least 7 characters';
                      } else if (value.length > 13) {
                        return 'Password must be at most 13 characters';
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: _isObscure
                            ? const Icon(Icons.visibility_off)
                            : const Icon(
                                Icons.visibility,
                              ),
                      ),
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                    style: GoogleFonts.ubuntu(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Consumer<UserDataProvider>(
                    builder: (context, userDataProvider, child) {
                      switch (userDataProvider.registerStatus?.status) {
                        case Status.loading:
                          return const CircularProgressIndicator();
                        case Status.completed:
                          // savedLogin(userDataProvider.registerStatus?.data);
                          WidgetsBinding.instance.addPostFrameCallback(
                            (timeStamp) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainWrapper(),
                              ),
                            ),
                          );
                          return signupBtn();
                        case Status.error:
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              signupBtn(),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    userDataProvider.registerStatus!.message,
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.redAccent, fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          );
                        default:
                          return signupBtn();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signupBtn() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.bodySmall?.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          // if all text form field validator cll backs returns null that means its validated
          if (_formKey.currentState!.validate()) {
            Provider.of<UserDataProvider>(context, listen: false)
                .callRegisterApi(nameController.text, emailController.text,
                    passwordController.text);
          }
        },
        child: Text(
          'Sign Up',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
