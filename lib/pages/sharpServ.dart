import 'package:ecomm_dash/widgets/customText.dart';
import 'package:ecomm_dash/widgets/customTextField.dart';
import 'package:flutter/material.dart';

class SharpServ extends StatefulWidget {
  const SharpServ({super.key});

  @override
  State<SharpServ> createState() => _SharpServState();
}

class _SharpServState extends State<SharpServ> {
  static const headerStyle = TextStyle(
      color: Color(0xffffffff), fontSize: 14, fontWeight: FontWeight.bold);
  static const contentStyle = TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController queryController = TextEditingController();

  String? selectedPair;
  bool showLocationField = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 10,
        title: MyText(
          'Sharpening Service',
          Colors.black,
          size.width * 0.045, // Responsive title size
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.03,
              ), // Responsive padding
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: isLandscape ? size.height * 0.35 : size.height * 0.25, // Responsive image height
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/images1.jpg'),
                        ),
                      ),
                      child: Center(
                        child: MyText(
                          'Sharpening Service',
                          Colors.white,
                          size.width * 0.08, // Responsive font size for the title
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Your Name',
                      obscureText: false,
                      suffix: const Icon(Icons.person),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Your Email',
                      obscureText: false,
                      suffix: const Icon(Icons.email),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Dropdown for selecting pair count
                    DropdownButtonFormField<String>(
                      value: selectedPair,
                      hint: const Text('How many pairs do you have?'),
                      items: const [
                        DropdownMenuItem(value: '1', child: Text('1 pair')),
                        DropdownMenuItem(value: '2', child: Text('2 pairs')),
                        DropdownMenuItem(value: '3', child: Text('3 pairs')),
                        DropdownMenuItem(value: '4', child: Text('4 pairs')),
                        DropdownMenuItem(value: '5', child: Text('5+ pairs')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPair = value;
                          showLocationField = value == '5';
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.shopping_bag),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a pair count';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    // Conditionally show the location input
                    if (showLocationField)
                      CustomTextField(
                        controller: locationController,
                        labelText: 'Add your Location',
                        obscureText: false,
                        suffix: const Icon(Icons.location_on),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Location is required';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 10),
                    // Query TextField
                    TextFormField(
                      controller: queryController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintText: 'Type your query here...',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Query is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Checkout Button
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _showConfirmationDialog(context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(size.height * 0.02), // Responsive padding
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: MyText(
                            'Submit',
                            Colors.white,
                            size.width * 0.045, // Responsive button text size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thanks for booking us!'),
          content: const Text('Your sharpening service has been booked.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue to Shopping'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the home page
              },
            ),
          ],
        );
      },
    );
  }
}
