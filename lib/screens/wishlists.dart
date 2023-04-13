import 'package:flutter/material.dart';

class Wishlists extends StatefulWidget {
  const Wishlists({Key? key}) : super(key: key);

  @override
  State<Wishlists> createState() => _WishlistsState();
}

class _WishlistsState extends State<Wishlists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma liste de souhaits'),
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

