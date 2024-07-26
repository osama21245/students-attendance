import 'package:flutter/material.dart';
import 'package:university_attendance/core/const/image_links.dart';
import 'package:university_attendance/core/utils/navigation.dart';
import 'package:university_attendance/features/online_attendance/presentation/screens/test.dart';
import 'package:uuid/uuid.dart';

import 'live_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String userId = Uuid().v1();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Live Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
            top: 10,
          ),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03),
              InkWell(
                onTap: () async => navigationTo(
                    context,
                    OnlineSessionScreen(
                      channelId: "os12",
                      userId: "o123",
                      isBoadCaster: true,
                    )),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: size.height * 0.1,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(ImageLinks.appLogo),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr : Hafez and el wahab",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Network and computer science",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('1 watching'),
                            Text("Start befor 5 mun"
                                // 'Started ${timeago.format(stream.startedAt)}',
                                ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
