import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/home_page/home_screen.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/routes.dart';
import 'package:moviflix/widgets/custom_material_button.dart';
import 'package:moviflix/widgets/custom_outlined_button.dart';
import 'package:moviflix/widgets/custom_text_field.dart';
import 'package:moviflix/widgets/login_banner.dart';
import 'package:moviflix/widgets/text_in_between_divider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passwordObscure = false;

  @override
  void initState() {
    super.initState();
    passwordObscure = true;
  }

   bool isValidEmail(String email) {
    // Use a proper email validation logic, this is a simple example
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  void validateAndSignIn() async {
    if (_emailController.text.isEmpty) {
      showErrorToast(message: 'Email is required');
      return;
    } else if (_passwordController.text.isEmpty) {
      showErrorToast(message: 'Password is required');
      return;
    } else if (_passwordController.text.length < 6) {
      showErrorToast(message: 'Password must be at least 6 characters', );
      return;
    }else if (!isValidEmail(_emailController.text)) {
      showErrorToast(message: "Invalid email address");
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        await auth
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .whenComplete(
              () => ScaffoldMessenger.of(context)
                  .showSnackBar(
                    const SnackBar(
                      content: Text("Logged In Successfully"),
                    ),
                  )
                  .closed
                  .whenComplete(
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                  ),
            );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showErrorToast(message: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showErrorToast(message: 'Wrong Password');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 4,
      ),
      body: Column(
        children: [
          const Expanded(
            child: LoginBanner(
              firstLine: 'Sign in to your ',
              secondLine: 'Account',
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        obscureText: passwordObscure,
                        controller: _passwordController,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordObscure = !passwordObscure;
                            });
                          },
                          icon: Icon(passwordObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        textInputType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.arbutus(
                            textStyle: TextStyle(
                              color: Colors.deepPurple[800],
                            ),
                          ),
                          textAlign: TextAlign.end,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomMaterialButton(
                                text: 'Login', onPressed: validateAndSignIn),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const TextInBetweenDivider(),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomOutlinedButton(
                              onPressed: () {},
                              iconData: Icons.facebook,
                              text: 'Google',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomOutlinedButton(
                              onPressed: () {},
                              iconData: Icons.facebook,
                              text: 'Facebook',
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Don\'t have an account?  '),
                          InkWell(
                            onTap: () {
                              Navigator.popAndPushNamed(
                                  context, AppRoutes.registerPage);
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.deepPurple[800]),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
