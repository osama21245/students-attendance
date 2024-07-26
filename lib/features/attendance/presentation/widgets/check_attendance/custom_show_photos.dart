import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_pallete.dart';

class CustomShowPhotos extends StatelessWidget {
  final Size size;
  final List<File> images;

  const CustomShowPhotos({
    super.key,
    required this.size,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Your photos",
              style: TextStyle(fontSize: 17),
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(images[index])),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            (index + 1).toString(),
                          ),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppPallete.tranperanceGrey),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
