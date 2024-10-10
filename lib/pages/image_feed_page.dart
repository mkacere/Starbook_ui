import 'package:flutter/material.dart';
import '../widgets/post_widget.dart';

class ImageFeedPage extends StatelessWidget {
  const ImageFeedPage({super.key});

  final List<String> imageUrls = const [
    'https://picsum.photos/500/300',
    'https://picsum.photos/501/300',
    'https://picsum.photos/502/300',
    'https://picsum.photos/503/300',
    'https://picsum.photos/504/300',
    'https://picsum.photos/505/300',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return PostWidget(imageUrl: imageUrls[index]);
        },
      ),
    );
  }
}
