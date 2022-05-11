import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool visibile = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String response = await Auth().signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)),
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
        child: Container(
          padding: MediaQuery.of(context).size.width > webWidth
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 60,
                ),
                const SizedBox(height: 50),
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
                const SizedBox(height: 20),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is empty';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  hintText: 'Enter Your Password',
                  keyboardType: TextInputType.emailAddress,
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
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: signUp,
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Text('Log in'),
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
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account '),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        'Sign up',
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
    );
  }
}
