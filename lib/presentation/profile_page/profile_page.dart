import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/consts.dart';
import 'package:moviflix/utils/my_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhiteLight,
      appBar: AppBar(
        title: Text(
          "Your Profile",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding / 2),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.dark_mode_outlined),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: MyColors.offWhiteLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          const CircleAvatar(radius: 50),
                          Positioned(
                            left: 60,
                            top: 60,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add_a_photo_sharp,
                                size: 25,
                                color: MyColors.greyLight,
                              ),
                              splashRadius: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    sBoxOfHeight10,
                    Text(
                      'Md Jawad Un Islam Abir',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const Text('mjiabir12007@gmail.com'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Personal Information'),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Icon(Icons.mode_edit_outlined),
                              SizedBox(width: 5),
                              Text('Edit'),
                            ],
                          ),
                        )
                      ],
                    ),
                    Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColors.offWhiteLight,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Column(
                          children: [
                            ProfileInfoContainer(
                              leftIconData: Icons.email_outlined,
                              title: 'Email',
                              data: 'mjiabir12007@gmail.com',
                            ),
                            ProfileInfoContainer(
                              leftIconData: Icons.movie_filter_outlined,
                              title: 'Movie Watched',
                              data: '10',
                            ),
                            ProfileInfoContainer(
                              leftIconData: Icons.person_2_outlined,
                              title: 'Username',
                              data: 'jawadAbir',
                            ),
                          ],
                        ),
                      ),
                    ),
                    sBoxOfHeight20,
                    TextButton(
                      onPressed: signOut,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            color: MyColors.redAlertLight,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Sign Out',
                            style: TextStyle(color: MyColors.redAlertLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoContainer extends StatelessWidget {
  const ProfileInfoContainer({
    super.key,
    required this.leftIconData,
    required this.title,
    this.data,
    this.rightIconData,
  });
  final String title;
  final IconData leftIconData;
  final String? data;
  final IconData? rightIconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.offWhiteLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  leftIconData,
                  color: MyColors.greyLight,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            data != null
                ? Text(
                    data!,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Icon(rightIconData),
          ],
        ),
      ),
    );
  }
}
