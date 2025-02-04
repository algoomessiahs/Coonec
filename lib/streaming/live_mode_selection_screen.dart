// import 'dart:io';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';


// import 'package:visionlive/Screen/screens.dart';
// import 'package:visionlive/constants/colors.dart';
// import 'package:visionlive/constants/strings.dart';
// import 'package:visionlive/controllers/controllers.dart';
// import 'package:visionlive/functions/agora_permission.dart';
// import 'package:visionlive/functions/functions.dart';
// import 'package:visionlive/functions/showSnackBar.dart';
// import 'package:visionlive/model/models.dart';
// import 'package:visionlive/widgets/widgets.dart';


// List<CameraDescription> cameras;
// class LiveModeSelectionScreen extends StatefulWidget {
//   @override
//   _LiveModeSelectionScreenState createState() =>
//       _LiveModeSelectionScreenState();
// }

// class _LiveModeSelectionScreenState extends State<LiveModeSelectionScreen> {
//   CameraController controller;
//   getCamera() async {
//     await handleCameraAndMic('Video');
//     cameras = await availableCameras();
//     controller = CameraController(cameras[1], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCamera();
//   }

//   List<Widget> gridIcons = [
//     Icon(Icons.grid_view),
//     Icon(Icons.grid_on),
//     Icon(Icons.grid_on),
//   ];
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   final List<String> modes = [
//     'Video',
//     'Audio',
//     'MultiGuest-Video',
//     'MultiGuest-Audio'
//   ];
//   List<String> pickedTags = [];
//   PickedFile coverPhoto;
//   final authController = Get.find<AuthController>();
//   final streamController = Get.find<UserStreamController>();
//   final titleController = TextEditingController();
//   int maxAllowed = 4;
//   _pickCoverImage() async {
//     try {
//       //ignore:deprecated_member_use
//       coverPhoto = await ImagePicker().getImage(source: ImageSource.gallery);
//       setState(() {});
//     } catch (e) {}
//   }

//   String selectedMode = 'Video';
 

//   @override
//   Widget build(BuildContext context) {
//     if (controller == null || !controller.value.isInitialized) {
//       return Container();
//     }
//     return Material(
//       child: Scaffold(
//         body: Container(
//           height: double.infinity,
//           width: Get.width,
//           child:selectedMode.contains('Video') ?CameraPreview(
//             controller,
//             child:  buildStackItems(),
//           ):Container(
//             decoration: BoxDecoration(
//               gradient: gradient
//             ),
//             child: Stack(
//               children: [
                
//                  buildStackItems()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildStackItems(){
//     return Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   GestureDetector(
//                     onTap: _pickCoverImage,
//                     child: Column(
//                       children: [
//                         Container(
//                             height: 110,
//                             width: 110,
//                             margin: const EdgeInsets.only(left: 5),
//                             decoration: BoxDecoration(
//                                 border: Border.fromBorderSide(BorderSide(
//                                     width: 2, color: Colors.white))),
//                             child: Stack(
//                               alignment: Alignment.bottomCenter,
//                               children: [
//                                 coverPhoto == null
//                                     ? Image.asset('assets/images/gigo.png',
//                                         fit: BoxFit.cover)
//                                     : Image.file(
//                                         File(coverPhoto.path),
//                                         fit: BoxFit.cover,
//                                         height: 110,
//                                         width: 110,
//                                       ),
//                                 Container(
//                                   height: 20,
//                                   color: Colors.grey.withOpacity(0.8),
//                                   child: Center(
//                                     child: Text(
//                                       'Change cover',
//                                       style: TextStyle(color: Colors.white,
//                                       fontSize: 13
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                         SizedBox(height: 5),
//                         Padding(
//                           padding: const EdgeInsets.only(left:4.0),
//                           child: TagsPicker(onPicked: (v) {
//                             pickedTags = v;
//                           }),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.symmetric(vertical: 50),
//                           child: TextField(
//                             maxLines: 5,
//                             controller: titleController,
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 18),
//                             decoration: InputDecoration(
//                                 hintText: 'Add a title to chat',
//                                 hintStyle: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     color: Colors.white),
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     if (selectedMode.contains('-'))
//                       Container(
//                         height: 50,
//                         margin: const EdgeInsets.all(5),
//                         width: double.infinity,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: seats
//                               .map((e) => GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         maxAllowed = e;
//                                       });
//                                     },
//                                     child: Container(
//                                       child: Column(
//                                         children: [
//                                           gridIcons[seats.indexOf(e)],
//                                           Text(
//                                             '$e seats',
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: maxAllowed == e
//                                                     ? Colors.white
//                                                     : Colors.grey),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ))
//                               .toList(),
//                         ),
//                       ),
                    
//                     MainButton(
//                       width: 200,
//                       onPressed: () async {
//                         bool multiple =
//                             selectedMode.contains('-') ? true : false;
//                         var thumbnail;
//                         var type = selectedMode.contains('-')
//                             ? selectedMode.split('-')[1]
//                             : selectedMode;
//                         showSnackBar(
//                             title: 'Connecting..',
//                             body: 'Connection to live wait...');
//                         if (coverPhoto != null) {
//                           thumbnail = await uploadAndGetUrl(coverPhoto.path,
//                               FirebaseStorage.instance.ref('streaming'));
//                         }
//                           var filterContents=[
//                             type,
//                             authController.currentUser.country,
//                             multiple?'Multi Room':'Single',
//                           ];
//                         var stream = UserStream(
//                           filterContents,
//                           authController.currentUser.uid,
//                           type,
//                           streamer: authController.currentUser,
//                           members: [],
//                           tags: pickedTags,
//                           allowMutiple: multiple,
//                           maxAllow: multiple ? maxAllowed : 0,
//                           chatTitle: titleController.text,
//                           listeners: [],
//                           isStreaming: true,
//                         );
//                         stream.streamingPhoto = thumbnail;
//                         var id = await streamController.insert(stream);
//                         stream.docId = id;
//                         Get.off(() => LiveStreaming(stream,
//                             streamingId: id,
//                             role: ClientRole.Broadcaster,
//                             channelName: authController.currentUser.uid,
//                             callType: type,
//                             joinedUser: authController.currentUser)).then((value) => {
//                               Get.back()
//                             });
//                       },
//                       text: 'Go Live',
//                     ),

//                     Container(
//                       width: double.infinity,
//                       height: 56,
//                       margin: const EdgeInsets.only(bottom:10,top:5),
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: modes.length,
//                         itemBuilder: (context, index) {
//                           return TextButton(
//                             onPressed: () async {
//                               setState(() {
//                                 selectedMode = modes[index];
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 30,
//                                   child: Center(
//                                       child: Text(modes[index],
//                                           style: TextStyle(color:selectedMode == modes[index]?
//                                            Colors.white:Colors.grey,
//                                           fontSize: 17
//                                           ))),
//                                 ),
//                                 if(selectedMode == modes[index])Container(
//                                   height: 10,
//                                   width: 10,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//   }
// }
