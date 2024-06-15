import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.done_rounded))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            DottedBorder(
                child: Column(
              children: [Icon(Icons.image), Text("test")],
            ))
          ],
        ),
      ),
    );
  }
}
