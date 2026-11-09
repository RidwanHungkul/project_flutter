import 'package:flutter/material.dart';

import '../models/post.dart';

class DetailScreen extends StatelessWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Post')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Post: ${post.id}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 16),

            Text(
              post.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              'Isi Postingan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(post.body, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
