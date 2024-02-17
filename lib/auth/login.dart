
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviflix/home_page/home_screen.dart';
import 'package:moviflix/utils/commons.dart';

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
      await auth
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
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
              () async{
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
        title: const Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  icon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
                  icon: Icon(Icons.password_outlined),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: "Username",
                  icon: Icon(Icons.person_pin),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton.icon(
                onPressed: signIn,
                label: const Text(
                  "Sign In",
                ),
                icon: const Icon(Icons.login_outlined),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton.icon(
                onPressed: signUp,
                icon: const Icon(Icons.add_circle_outline_outlined),
                label: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
