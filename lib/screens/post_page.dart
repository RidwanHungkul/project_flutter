import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_services.dart';
import 'detail_screen.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ApiService api = ApiService();

  late Future<List<Post>> futurePosts;

  bool _mengirim = false;

  final TextEditingController titleController = TextEditingController();

  final TextEditingController bodyController = TextEditingController();

  // GET: mengambil data dari API
  @override
  void initState() {
    super.initState();
    futurePosts = api.fetchPosts();
  }

  // Membersihkan controller
  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  // POST: mengirim laporan ke API
  Future<void> kirimLaporan() async {
    if (titleController.text.isEmpty || bodyController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua form harus diisi')));
      return;
    }

    setState(() {
      _mengirim = true;
    });

    try {
      final hasil = await api.createPost(
        titleController.text,
        bodyController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Berhasil! ID baru: ${hasil.id}')));

      titleController.clear();
      bodyController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengirim: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _mengirim = false;
        });
      }
    }
  }

  // Tampilan halaman
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FORM POST
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Laporan',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: bodyController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Isi Laporan',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _mengirim ? null : kirimLaporan,
                  icon: _mengirim
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(_mengirim ? 'Mengirim...' : 'Kirim Laporan'),
                ),
              ),
            ],
          ),
        ),

        // GET: menampilkan daftar data
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Data kosong'));
              }

              final posts = snapshot.data!;

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),

                      title: Text(post.title),

                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios),

                      // Membuka halaman detail
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(post: post),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
