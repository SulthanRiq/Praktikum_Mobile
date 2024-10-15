import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(GetMaterialApp(
    title: 'Wattpad Home',
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: HomePage(),
  ));
}

class HomePage extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wattpad'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Aksi untuk search
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian untuk story populer
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Popular Stories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StoryCarousel(),

            // Bagian kategori
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            CategoryList(),

            // Bagian cerita rekomendasi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recommended for You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            RecommendedStories(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Aksi ketika tab ditekan
        },
      ),
    );
  }
}

class StoryCarousel extends StatefulWidget {
  @override
  _StoryCarouselState createState() => _StoryCarouselState();
}

class _StoryCarouselState extends State<StoryCarousel> {
  final List<String> stories = [
    'Story 1',
    'Story 2',
    'Story 3',
    'Story 4',
  ];

  // List untuk menyimpan gambar yang dipilih dari galeri
  List<File?> _selectedImages = [null, null, null, null];

  // Fungsi untuk memanggil Image Picker
  Future<void> _pickImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImages[index] = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              width: 150,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _pickImage(index); // Memilih gambar saat story ditekan
                      },
                      child: _selectedImages[index] != null
                          ? Image.file(
                        _selectedImages[index]!,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(stories[index]),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(index),
                    child: Text("Pick Image"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<String> categories = [
    'Romance',
    'Fantasy',
    'Thriller',
    'Science Fiction',
    'Mystery',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text(categories[index]),
            ),
          );
        },
      ),
    );
  }
}

class RecommendedStories extends GetView {
  final List<String> recommended = [
    'Stuck With Mr. Billionaire',
    'Hell University',
    'A Brilliant Plan',
  ];

  final List<String> urls = [
    'https://www.wattpad.com/story/243832194-stuck-with-mr-billionaire',
    'https://www.wattpad.com/story/157780928-hell-university',
    'https://www.wattpad.com/story/65808245-a-brilliant-plan',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recommended.map((story) {
        int index = recommended.indexOf(story);
        return ListTile(
          leading: Image.network(
            'https://via.placeholder.com/50',
            fit: BoxFit.cover,
          ),
          title: Text(story),
          subtitle: Text('Author Name'),
          onTap: () {
            Get.to(WebViewScreen(url: urls[index]));
          },
        );
      }).toList(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
