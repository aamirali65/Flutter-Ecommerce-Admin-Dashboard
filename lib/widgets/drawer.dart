import 'package:ecomm_dash/pages/Contact.dart';
import 'package:ecomm_dash/pages/addProduct.dart';
import 'package:ecomm_dash/pages/allProducts.dart';
import 'package:ecomm_dash/pages/allSlides.dart';
import 'package:ecomm_dash/pages/home.dart';
import 'package:ecomm_dash/pages/login.dart';
import 'package:ecomm_dash/pages/sharpServ.dart';
import 'package:ecomm_dash/widgets/customText.dart';
import 'package:ecomm_dash/widgets/drawer_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DrawerClass extends StatefulWidget {
  const DrawerClass({super.key});
  @override
  State<DrawerClass> createState() => _DrawerClassState();
}

class _DrawerClassState extends State<DrawerClass> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userEmail;
  String? userName;
  String? profileImageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.white),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(
                        profileImageUrl!)
                        : const AssetImage(
                        'assets/images/profile.jpg'),
                  ),
                  currentAccountPictureSize: const Size(60, 60),
                  accountName: MyText(userName ?? 'Admin', Colors.black, 22),
                  accountEmail: MyText(userEmail ?? 'admin@gmail.com', Colors.black, 15),
                ),
                const SizedBox(height: 20),
                drawerList('Products', Icons.shopping_cart, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboard(),
                      ));
                }),
                drawerList('Users', Icons.stacked_line_chart, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllSlidesPage(),
                      ));
                }),
                drawerList('Sliders', Icons.slideshow, () {

                }),
                drawerList('Contact', Icons.mail, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminMessagesPage(),
                      ));
                }),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: drawerList('Log out', Icons.logout_outlined, () {
    logout();
    }),
          ),
        ],
      ),
    );
  }
}
