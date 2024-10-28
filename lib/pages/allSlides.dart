import 'package:ecomm_dash/pages/addSlide.dart';
import 'package:ecomm_dash/pages/editSlide.dart'; // Import the EditSlidePage
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllSlidesPage extends StatelessWidget {
  const AllSlidesPage({super.key});

  Future<void> _deleteSlide(String slideId) async {
    await FirebaseFirestore.instance.collection('slides').doc(slideId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Slides'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('slides').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final slides = snapshot.data!.docs;

          return ListView.builder(
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              final imageUrl = slide.data().containsKey('imageUrl') ? slide['imageUrl'] : null;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: imageUrl != null
                      ? Image.network(imageUrl, width: 50, fit: BoxFit.cover)
                      : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                    child: const Icon(Icons.image, color: Colors.white),
                  ),
                  title: Text(slide['title']),
                  subtitle: Text(slide['subtitle']),
                  onTap: () {
                    // Navigate to the edit slide page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSlidePage(slideId: slide.id, initialTitle: slide['title'], initialSubtitle: slide['subtitle'], initialImageUrl: imageUrl),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Confirm before deletion
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text('Are you sure you want to delete this slide?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(), // Cancel
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteSlide(slide.id);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSlidePage(),
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.red.shade500,
        tooltip: 'Add Slide',
      ),
    );
  }
}
