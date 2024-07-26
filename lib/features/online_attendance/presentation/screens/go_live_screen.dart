// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kman/HandlingDataView.dart';
// import 'package:kman/featuers/live_streaming/controller/live_streaming_controller.dart';

// import '../../../core/class/statusrequest.dart';
// import '../../../core/utils.dart';
// import '../../../theme/pallete.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_text_field.dart';

// class GoLiveScreen extends ConsumerStatefulWidget {
//   const GoLiveScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _GoLiveScreenState();
// }

// class _GoLiveScreenState extends ConsumerState<GoLiveScreen> {
//   TextEditingController? title;
//   File? logo;

//   @override
//   void initState() {
//     title = TextEditingController(text: "");
//     super.initState();
//   }

//   @override
//   void dispose() {
//     title!.dispose();
//     super.dispose();
//   }

//   setliveStreaming() {
//     if (title == "" || logo == null) {
//       ref
//           .watch(liveStreamingControllerProvider.notifier)
//           .setLiveStream(title!.text, context, logo!);
//     } else {
//       showSnackBar("You should enter the all data", context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     pickimagefromGallery() async {
//       final res = await picImage();

//       if (res != null) {
//         logo = File(res.files.first.path!);
//       }
//       setState(() {});
//     }

//     //  Size size = MediaQuery.of(context).size;
//     StatusRequest statusRequest = ref.watch(liveStreamingControllerProvider);
//     return HandlingDataView(
//         statusRequest: statusRequest,
//         widget: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => pickimagefromGallery(),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 22.0,
//                             vertical: 20.0,
//                           ),
//                           child: logo != null
//                               ? SizedBox(
//                                   height: 300,
//                                   child: Image.file(logo!),
//                                 )
//                               : DottedBorder(
//                                   borderType: BorderType.RRect,
//                                   radius: const Radius.circular(10),
//                                   dashPattern: const [10, 4],
//                                   strokeCap: StrokeCap.round,
//                                   color: Pallete.fontColor,
//                                   child: Container(
//                                     width: double.infinity,
//                                     height: 150,
//                                     decoration: BoxDecoration(
//                                       color: Pallete.fontColor.withOpacity(.05),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         const Icon(
//                                           Icons.folder_open,
//                                           color: Pallete.fontColor,
//                                           size: 40,
//                                         ),
//                                         const SizedBox(height: 15),
//                                         Text(
//                                           'Select your thumbnail',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             color: Colors.grey.shade400,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Title',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: CustomTextField(
//                               controller: title!,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       bottom: 10,
//                     ),
//                     child: CustomButton(
//                       text: 'Go Live!',
//                       onTap: () => setliveStreaming(),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
