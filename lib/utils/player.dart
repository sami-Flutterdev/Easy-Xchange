// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:prestige_vender/utils/widget.dart';

// class CustomAudioPlayer extends StatefulWidget {
//   final String url;
//   const CustomAudioPlayer({
//     required this.url,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _CustomAudioPlayerState createState() => _CustomAudioPlayerState();
// }

// class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  
//   static AudioPlayer? currentActivePlayer;
//   late AudioPlayer audioPlayer;
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));

//     return '$minutes:$seconds';
//   }

//   @override
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//     audioPlayer.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying = state == PlayerState.playing;
//       });
//     });
//     audioPlayer.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration = newDuration;
//       });
//     });
//     audioPlayer.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position = newPosition;
//       });
//     });
//   }

//   // late AudioPlayer? currentActivePlayer;
//   void activatePlayer() async {
//     if (currentActivePlayer != null && currentActivePlayer != audioPlayer) {
//       currentActivePlayer!.pause();
//     }
//     if (isPlaying) {
//       await audioPlayer.pause();
//     } else {
//       await audioPlayer.play(UrlSource(widget.url));
//     }
//     currentActivePlayer = audioPlayer;
//     // update currently playing
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.sizeOf(context);
//     return Container(
//         padding: const EdgeInsets.all(8.0),
//         height: 60,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color:AppColors. const Color(0xFFE8E8EE),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CircleAvatar(
//               radius: size.width * .046,
//               backgroundColor:AppColors. Colors.purple,
//               child: IconButton(
//                 padding: const EdgeInsets.all(0),
//                 alignment: Alignment.center,
//                 color:AppColors. Colors.white,
//                 onPressed: () async {
//                   if (kDebugMode) {
//                     print("url: ${widget.url}");
//                   }
//                   activatePlayer();
//                 },
//                 icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                 iconSize: size.width * .045,
//               ),
//             ),
//             Text(
//               formatTime(position),
//             ),
//             SizedBox(
//               width: size.width * .4,
//               child: SliderTheme(
//                 data: SliderThemeData(
//                   inactiveTrackcolor:AppColors. const Color(0xff9B22C5).withOpacity(.3),
//                 ),
//                 child: Slider(
//                   min: 0,
//                   max: duration.inSeconds.toDouble(),
//                   value: position.inSeconds.toDouble(),
//                   onChanged: (value) {
//                     setState(() {
//                       position = Duration(seconds: value.toInt());
//                     });
//                   },
//                   onChangeEnd: (value) {
//                     audioPlayer.seek(Duration(seconds: value.toInt()));
//                   },
//                 ),
//               ),
//             ),
//             text(
//               formatTime(
//                 duration - position,
//               ),
//               fontSize: 14.0,
//             ),
//           ],
//         ));
//   }
// }

// class AudioPlay extends StatefulWidget {
//   final String url;

//   const AudioPlay({required this.url, Key? key}) : super(key: key);

//   @override
//   _AudioPlayState createState() => _AudioPlayState();
// }

// class _AudioPlayState extends State<AudioPlay> {
//   late AudioPlayer audioPlayer;
//   bool isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//     audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       if (mounted) {
//         setState(() {
//           isPlaying = state == PlayerState.playing;
//         });
//       }
//     });
//   }

//   void togglePlayer() async {
//     if (isPlaying) {
//       await audioPlayer.pause();
//     } else {
//       await audioPlayer.play(
//         UrlSource(widget.url),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     audioPlayer.release();
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: CircleAvatar(
//         radius: 18,
//         backgroundColor:AppColors. Colors.purple,
//         child: IconButton(
//           color:AppColors. Colors.white,
//           onPressed: togglePlayer,
//           icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//           iconSize: 20,
//         ),
//       ),
//     );
//   }
// }
