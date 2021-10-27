import 'package:flutter/material.dart';

import '../widgets/base_app_bar.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen(this.urlPhoto, {Key? key}) : super(key: key);

  final String urlPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image(
            image: NetworkImage(urlPhoto),
          ),
        ),
      ),
    );
  }
}
