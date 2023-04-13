import 'package:flutter/material.dart';

class Likes extends StatefulWidget {
  const Likes({Key? key}) : super(key: key);

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes likes'),
        backgroundColor: const Color(0xFF1A2025),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1A2025),
        ),
      ),
    );
  }
}