import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_pallete.dart';

class CustomSecoundCheckPhotos extends StatelessWidget {
  final Size size;
  final List<File> images;
  final int counter;
  final List<int> failImagesIndexs;
  const CustomSecoundCheckPhotos(
      {super.key,
      required this.size,
      required this.images,
      required this.counter,
      required this.failImagesIndexs});

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
              "Secound Check",
              style: TextStyle(fontSize: 17),
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (images.length / 2).toInt(),
              itemBuilder: (context, index) {
                print(images.length);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(images[index + 2])),
                      failImagesIndexs.isEmpty && counter == 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  (index + 3).toString(),
                                ),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppPallete.tranperanceGrey),
                              ),
                            )
                          : failImagesIndexs.contains(index + 2)
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 7, left: 8.0),
                                  child: Icon(
                                    Icons.dangerous_rounded,
                                    color: Colors.red,
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(top: 7, left: 8.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ),
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
