import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen(this.urlPhoto, {Key? key}) : super(key: key);

  final String urlPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 48,
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary
              ],
            ),
          ),
        ),
      ),
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
