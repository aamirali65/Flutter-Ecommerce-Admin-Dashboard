import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm_dash/pages/Contact.dart';
import 'package:ecomm_dash/pages/allProducts.dart';
import 'package:ecomm_dash/pages/allSlides.dart';
import 'package:ecomm_dash/pages/allUser.dart';
import 'package:ecomm_dash/widgets/customText.dart';
import 'package:ecomm_dash/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int productCount = 0;
  int userCount = 0;
  int slideCount = 0;
  int messageCount = 0;

  @override
  void initState() {
    super.initState();
    _listenToCounts();
  }

  void _listenToCounts() {
    // Listen to changes in the 'products' collection
    _firestore.collection('products').snapshots().listen((productSnapshot) {
      setState(() {
        productCount = productSnapshot.size;
      });
    });

    // Listen to changes in the 'users' collection
    _firestore.collection('users').snapshots().listen((userSnapshot) {
      setState(() {
        userCount = userSnapshot.size;
      });
    });

    // Listen to change in slide collection
    _firestore.collection('slides').snapshots().listen((slideSnapshot) {
      setState(() {
        slideCount = slideSnapshot.size;
      });
    });
    // Listen to change in message collection
    _firestore.collection('userMessages').snapshots().listen((messageSnapshot) {
      setState(() {
        messageCount = messageSnapshot.size;
      });
    });
  }

  void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1), // Snack bar shows for 1 second
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClass(),
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 10,
        title: MyText('Scissors Doctor', Colors.black, 20),
      ),
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome, Admin!',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
                        },
                        child: Container(
                          height: 180,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText('Total Products', Colors.white, 18),
                                  const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                                ],
                              ),
                              MyText('$productCount', Colors.white, 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUserManagement()));
                        },
                        child: Container(
                          height: 180,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText('Total Users', Colors.white, 18),
                                  const Icon(Icons.person, color: Colors.white, size: 30),
                                ],
                              ),
                              MyText('$userCount', Colors.white, 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AllSlidesPage()));
                        },
                        child: Container(
                          height: 180,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText('Total Slides', Colors.white, 18),
                                  const Icon(Icons.slideshow, color: Colors.white, size: 30),
                                ],
                              ),
                              MyText('$slideCount', Colors.white, 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminMessagesPage()));
                        },
                        child: Container(
                          height: 180,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText('Contact', Colors.white, 18),
                                  const Icon(Icons.mail, color: Colors.white, size: 30),
                                ],
                              ),
                              MyText('$messageCount', Colors.white, 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
