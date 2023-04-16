import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video/global.dart';
import 'package:video/homescreens/home_screen.dart';
import 'package:video/homescreens/uploadvideo/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController
{
  compressVideoFile(String videoFilePath)
  async{
  final compressedVideoFilePath =  await VideoCompress.compressVideo(videoFilePath,quality: VideoQuality.HighestQuality);
  return compressedVideoFilePath!.file;
  }

uploadCompressedVideoFileToFirebasStorage(String videoID,String videoFilePath)async
{
  UploadTask videoUploadTask = FirebaseStorage.instance.ref()
  .child('All Videos')
  .child(videoID)
  .putFile(await compressVideoFile(videoFilePath));

  TaskSnapshot snapshot = await videoUploadTask;
 final downloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();
 return downloadUrlOfUploadedVideo;
}

  getThumbnailImage(String videoFilePath)
 async {
 final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);
 return thumbnailImage;
 }
 uploadThumbnailImageToFirebasStorage(String videoID,String videoFilePath)async
{
  UploadTask thumbnailUploadTask = FirebaseStorage.instance.ref()
  .child('All Thumbnails')
  .child(videoID)
  .putFile(await getThumbnailImage(videoFilePath));

  TaskSnapshot snapshot = await thumbnailUploadTask;
 final downloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();
 return downloadUrlOfUploadedVideo;
}
saveVideoInformationToFireStoreDatabase
(
  String artistSongName,String descriptionTags,String videoFilePath,BuildContext context)
async{
  try{
    DocumentSnapshot userdocumentSnapshot =await FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid).get();
    String videoID = DateTime.now().millisecondsSinceEpoch.toString();
    //1. upload video to storage
   String videoDownloadUrl = await uploadCompressedVideoFileToFirebasStorage(videoID, videoFilePath);

 //2. upload thumbnail to storage
   String thumbnailDownloadUrl = await uploadThumbnailImageToFirebasStorage(videoID, videoFilePath);

   //3. save overall video info to firebase database
   Video videoObject = Video(
    userID: FirebaseAuth.instance.currentUser!.uid,
    userName: (userdocumentSnapshot.data() as Map<String,dynamic>)['name'],
    userProfileImage: (userdocumentSnapshot.data() as Map<String,dynamic>)['image'],

    videoID: videoID,
    totalComments: 0,
    totalShares: 0,
    likesList: [],
    artistSongName: artistSongName,
    descriptionTags: descriptionTags,
    videoUrl: videoDownloadUrl,
    thumbnailUrl: thumbnailDownloadUrl,
    publishedDateTime: DateTime.now().millisecondsSinceEpoch.toString(),
   );
   await FirebaseFirestore.instance.collection('videos').doc(videoID).set(videoObject.toJson());
   Get.to(HomeScreen());
    Get.snackbar('New Video uploaded successfull', 'You have successfully uploaded your video');
showProgressBar = false;
  }catch(errorMsg){
    Get.snackbar('Upload Unsuccessfull', 'Your video is not uploaded due to error');
  }

}
}