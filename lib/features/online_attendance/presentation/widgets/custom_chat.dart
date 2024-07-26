// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kman/featuers/auth/controller/auth_controller.dart';
// import 'package:kman/featuers/live_streaming/controller/live_streaming_controller.dart';
// import 'package:lottie/lottie.dart';

// import '../../../core/common/error_text.dart';
// import '../../../core/constants/imgaeasset.dart';
// import 'custom_text_field.dart';

// class Chat extends ConsumerStatefulWidget {
//   final String channelId;
//   const Chat({super.key, required this.channelId});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ChatState();
// }

// class _ChatState extends ConsumerState<Chat> {
//   final TextEditingController _chatController = TextEditingController();

//   @override
//   void dispose() {
//     _chatController.dispose();
//     super.dispose();
//   }

//   setComment() {
//     ref
//         .watch(liveStreamingControllerProvider.notifier)
//         .setLiveStreamComment(_chatController.text, widget.channelId, context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = ref.watch(usersProvider);
//     final size = MediaQuery.of(context).size;

//     return SizedBox(
//       width: size.width > 600 ? size.width * 0.25 : double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Expanded(
//               child: ref
//                   .watch(getLiveStreamCommentsProvider(widget.channelId))
//                   .when(
//                       data: (comments) {
//                         return ListView.builder(
//                             itemCount: comments.length,
//                             itemBuilder: (context, index) {
//                               final comment = comments[index];
//                               return ListTile(
//                                 title: Text(
//                                   comment.username,
//                                   style: TextStyle(
//                                     color: comment.uid == userProvider!.uid
//                                         ? Colors.blue
//                                         : Colors.black,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   comment.message,
//                                 ),
//                               );
//                             });
//                       },
//                       error: (error, StackTrace) {
//                         print(error);

//                         return ErrorText(error: error.toString());
//                       },
//                       loading: () => LottieBuilder.asset(
//                             fit: BoxFit.contain,
//                             AppImageAsset.loading,
//                             repeat: true,
//                           ))),
//           CustomTextField(
//             controller: _chatController,
//             onTap: (val) {
//               setComment();
//               setState(() {
//                 _chatController.text = "";
//               });
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
