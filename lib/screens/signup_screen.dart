import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field.dart';

import '../responsive/base_screen_layout.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isLoading = false;
  Uint8List? _image;
  bool visibile = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void imageSelected() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUp() async {
    if (formKey.currentState!.validate() && _image != null) {
      setState(() {
        isLoading = true;
      });
      String response = await Auth().signUp(
        userName: _usernameController.text,
        email: _emailController.text,
        bio: _bioController.text,
        password: _passwordController.text,
        img: _image!,
      );

      if (response != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BaseScreenLayout(
              mobileScreenLayOut: MobileScreenLayout(),
              webScreenLayOut: WebScreenLayout(),
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: MediaQuery.of(context).size.width > webWidth
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 60,
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _image != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(_image!),
                              radius: 60,
                            )
                          : const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://i.pinimg.com/736x/89/90/48/899048ab0cc455154006fdb9676964b3.jpg',
                              ),
                              radius: 60,
                            ),
                      IconButton(
                        onPressed: () {
                          imageSelected();
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is empty';
                      }
                      return null;
                    },
                    controller: _emailController,
                    hintText: 'Enter Your Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username is empty';
                      }
                      return null;
                    },
                    controller: _usernameController,
                    hintText: 'Enter Your UserName',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    obscure: visibile,
                    suffix: IconButton(
                      icon: Icon(
                          visibile ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          visibile = !visibile;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is empty';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    hintText: 'Enter Your Password',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is empty';
                      }
                      return null;
                    },
                    controller: _bioController,
                    hintText: 'Enter Your Bio',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: signUp,
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Sign up'),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('already have an account '),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
