import 'package:ecomm_dash/widgets/customButton.dart';
import 'package:ecomm_dash/widgets/customText.dart';
import 'package:ecomm_dash/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditSlidePage extends StatefulWidget {
  final String slideId;
  final String initialTitle;
  final String initialSubtitle;
  final String? initialImageUrl;

  const EditSlidePage({
    Key? key,
    required this.slideId,
    required this.initialTitle,
    required this.initialSubtitle,
    this.initialImageUrl,
  }) : super(key: key);

  @override
  _EditSlidePageState createState() => _EditSlidePageState();
}

class _EditSlidePageState extends State<EditSlidePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _subtitleController = TextEditingController(text: widget.initialSubtitle);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _updateSlide() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Here you would add code to upload the image to Firebase Storage
      // and get the URL if a new image is picked.

      await FirebaseFirestore.instance.collection('slides').doc(widget.slideId).update({
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'imageUrl': _image != null ? 'image_url_placeholder' : widget.initialImageUrl, // Replace with actual image URL after upload
        'updatedAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slide updated successfully!')),
      );

      Navigator.of(context).pop(); // Return to the previous page
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
      appBar: AppBar(
        title: const Text('Edit Slide'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText('Edit Slide', Colors.black, 25),
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
                    child: _image == null && widget.initialImageUrl != null
                        ? Image.network(widget.initialImageUrl!, height: screenWidth > 600 ? 150 : 100, fit: BoxFit.cover)
                        : _image != null
                        ? Image.file(_image!, height: screenWidth > 600 ? 150 : 100, fit: BoxFit.cover)
                        : Container(
                      height: screenWidth > 600 ? 150 : 100,
                      color: Colors.grey, // Placeholder color
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                customText: "Update Slide",
                onTap: _updateSlide,
                loading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
