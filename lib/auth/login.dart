import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/home_page/home_screen.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_material_button.dart';
import 'package:moviflix/widgets/custom_text_field.dart';

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
  final TextEditingController _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passwordObscure = false;

  @override
  void initState() {
    super.initState();
    passwordObscure = true;
  }

  Future saveUserToFirebase() async {
    String email = _emailController.text;
    String username = _usernameController.text;

    DocumentReference documentReference =
        await firestore.collection('users').add({
      'email': email,
      'username': username,
    });
    String userId = documentReference.id;
    await firestore
        .collection('users')
        .doc(userId)
        .update({'id': userId}).catchError(
      (error) => showToast(message: 'Failed: $error'),
    );
  }

  void signIn() async {
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
          showToast(message: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showToast(message: 'Wrong Password');
        }
      }
    }
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      auth
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .whenComplete(
            () => ScaffoldMessenger.of(context)
                .showSnackBar(
                  const SnackBar(
                    content: Text("Successfully Signed Up"),
                  ),
                )
                .closed
                .whenComplete(
              () async {
                await saveUserToFirebase();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
          );
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
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: MyColors.appTheme,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in to your',
                      style: GoogleFonts.robotoCondensed(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Account',
                      style: GoogleFonts.robotoCondensed(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                            textStyle: TextStyle(color: Colors.deepPurple[800]),
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
                                text: 'Login', onPressed: signIn),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Divider(),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '  Or login with  ',
                              style: smallSubtitleText,
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Divider(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.facebook),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Google'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.facebook),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Facebook'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Don\'t have an account?  ',
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                color: Colors.deepPurple[800],
                              ),
                            ),
                          ],
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        textAlign: TextAlign.end,
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
