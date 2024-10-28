import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMessagesPage extends StatefulWidget {
  const AdminMessagesPage({Key? key}) : super(key: key);

  @override
  State<AdminMessagesPage> createState() => _AdminMessagesPageState();
}

class _AdminMessagesPageState extends State<AdminMessagesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final querySnapshot = await _firestore.collection('userMessages').get();
      setState(() {
        _messages = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Ensure 'id' is set to document ID
          return data;
        }).toList();
      });
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Messages'),
      ),
      body: _messages.isEmpty
          ? const Center(
        child: Text(
          'No messages available.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(message['username'] ?? 'Unknown User'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Rating: '),
                      for (var i = 0; i < (message['stars'] ?? 0); i++)
                        const Icon(Icons.star, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Message: ${message['message'] ?? 'No message'}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
