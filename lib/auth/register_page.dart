import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/home_page/home_screen.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/utils/routes.dart';
import 'package:moviflix/widgets/custom_material_button.dart';
import 'package:moviflix/widgets/custom_text_field.dart';
import 'package:moviflix/widgets/login_banner.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passwordObscure = false;
  bool isLoading = false;

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

  bool isValidEmail(String email) {
    // Use a proper email validation logic, this is a simple example
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  void validateAndSignUp() {
    if (_usernameController.text.isEmpty) {
      showToast(message: 'Username is required');
      return;
    } else if (_emailController.text.isEmpty) {
      showToast(message: 'Email is required');
      return;
    } else if (_passwordController.text.isEmpty) {
      showToast(message: 'Password is required');
      return;
    } else if (_passwordController.text.length < 6) {
      showToast(message: 'Password must be at least 6 characters');
      return;
    } else if (_passwordConfirmController.text != _passwordController.text) {
      showToast(message: 'Passwords do not match');
      return;
    } else if (!isValidEmail(_emailController.text)) {
      showToast(message: "Invalid email address");
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        auth
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
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
      } on FirebaseAuthException catch (e) {
        showErrorToast(message: '$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.pasteColorLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 4,
      ),
      body: Column(
        children: [
          const Expanded(
            child: LoginBanner(
              firstLine: 'Register',
              secondLine: 'Create your account',
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
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
                        controller: _usernameController,
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person_2_sharp),
                      ),
                      sBoxOfHeight20,
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        textInputType: TextInputType.emailAddress,
                      ),
                      sBoxOfHeight20,
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
                      sBoxOfHeight20,
                      CustomTextField(
                        obscureText: passwordObscure,
                        controller: _passwordConfirmController,
                        labelText: 'Confirm Password',
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
                      sBoxOfHeight30,
                      Row(
                        children: [
                          Expanded(
                            child: CustomMaterialButton(
                                text: 'Register', onPressed: validateAndSignUp),
                          ),
                        ],
                      ),
                      sBoxOfHeight30,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'I have an account  ',
                            style: GoogleFonts.aBeeZee(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.popAndPushNamed(
                                  context, AppRoutes.loginPage);
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                  color: Colors.deepPurple[800],
                                ),
                              ),
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
