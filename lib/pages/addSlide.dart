import 'package:ecomm_dash/widgets/customButton.dart';
import 'package:ecomm_dash/widgets/customText.dart';
import 'package:ecomm_dash/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddSlidePage extends StatefulWidget {
  const AddSlidePage({super.key});

  @override
  State<AddSlidePage> createState() => _AddSlidePageState();
}

class _AddSlidePageState extends State<AddSlidePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadSlide() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Prepare data for Firestore
      Map<String, dynamic> slideData = {
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // If an image is picked, upload it and get the URL
      if (_image != null) {
        // Upload the image to Firebase Storage
        // Replace this with your image upload code to get the image URL
        String imageUrl = 'image_url_placeholder'; // Replace with actual image URL after upload
        slideData['imageUrl'] = imageUrl;
      }

      // Store slide data in Firestore
      await FirebaseFirestore.instance.collection('slides').add(slideData);

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slide added successfully!')),
      );

      _titleController.clear();
      _subtitleController.clear();
      _image = null; // Reset the image
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth > 600 ? 40.0 : 16.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Slide')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText('Add New Slide', Colors.black, 25),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: "Slide Title",
                controller: _titleController,
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: "Slide Subtitle",
                controller: _subtitleController,
                validator: (value) => value!.isEmpty ? 'Enter a subtitle' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _image == null
                        ? CustomButton(
                      customText: "Pick Image",
                      onTap: _pickImage,
                    )
                        : Image.file(
                      _image!,
                      height: screenWidth > 600 ? 150 : 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                customText: "Add Slide",
                onTap: _uploadSlide,
                loading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
