// import 'package:flutter/material.dart';

// import '../../../theme/pallete.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final Function(String)? onTap;
//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onSubmitted: onTap,
//       controller: controller,
//       decoration: InputDecoration(
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Pallete.fontColor,
//               width: 2,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: const Color.fromARGB(255, 135, 128, 223),
//             ),
//           )),
//     );
//   }
// }
