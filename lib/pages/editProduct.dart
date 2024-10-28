import 'package:ecomm_dash/widgets/customButton.dart';
import 'package:ecomm_dash/widgets/customText.dart';
import 'package:ecomm_dash/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProduct extends StatefulWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String productDescription;
  final String productDiscount;
  final String productImageUrl;

  const EditProduct({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productDiscount,
    required this.productImageUrl,
  }) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product data
    _nameController.text = widget.productName;
    _priceController.text = widget.productPrice.toString();
    _descriptionController.text = widget.productDescription;
    _discountController.text = widget.productDiscount;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Prepare product data
      Map<String, dynamic> updatedData = {
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text,
        'discount': _discountController.text,
        // Update imageUrl if a new image is picked, else keep the old one
        'imageUrl': _image != null ? await uploadImage(_image!) : widget.productImageUrl,
      };

      // Update product data in Firestore
      await FirebaseFirestore.instance.collection('products').doc(widget.productId).update(updatedData);

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );

      // Optionally, navigate back after the update
      Navigator.pop(context);
    }
  }

  Future<String> uploadImage(File image) async {
    // Implement image upload logic and return the image URL
    // This is a placeholder; you would replace it with actual upload code
    return 'new_image_url'; // Replace with actual URL after upload
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Set different padding based on screen size
    double horizontalPadding = screenWidth > 600 ? 40.0 : 16.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText('Edit Product', Colors.black, 25),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: "Product Name",
                controller: _nameController,
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: "Price",
                controller: _priceController,
                validator: (value) => value!.isEmpty ? 'Enter a price' : null,
                suffix: const Icon(Icons.attach_money, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: "Description",
                controller: _descriptionController,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: "Discount",
                controller: _discountController,
                validator: (value) => value!.isEmpty ? 'Enter a Discount' : null,
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
                customText: "Update Product",
                onTap: _updateProduct,
                loading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
