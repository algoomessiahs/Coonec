// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:visionlive/controllers/controllers.dart';

// class ToggleMicroPhone extends StatelessWidget {
//   final Function onToggle;
//   ToggleMicroPhone({@required this.onToggle});
  

//   @override
//   Widget build(BuildContext context) {
//     final streamController=Get.find<UserStreamController>();
//      return GestureDetector(
//       onTap: onToggle,
//           child: Container(
//           height: 40,
//           width: 40,
//           decoration:
//               BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle),
//           child: Obx(()=> Icon(
//             !streamController.micState.value?Icons.mic:Icons.mic_off,
//           color:Colors.white)),
//         ),
//     );
//   }
// }