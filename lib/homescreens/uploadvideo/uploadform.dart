import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video/global.dart';
import 'package:video/widgets/input_text_widgets.dart';
import 'package:video_player/video_player.dart';

import 'uploadcontroller.dart';
class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const UploadForm({super.key,
  required this.videoFile,
  required this.videoPath});

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  UploadController uploadVideoController =Get.put(UploadController());
  VideoPlayerController? playerController;
  TextEditingController artistSongTextEditingController = TextEditingController();
  TextEditingController descriptionTagsTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();

  @override
  void initState(){
    super.initState();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
      playerController!.initialize();
      playerController!.play();
      playerController!.setVolume(2);
      playerController!.setLooping(true);
    }
   
    );
  }
   @override
    void dispose(){
      super.initState();
      playerController!.dispose();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //display video player
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.3,
              child: VideoPlayer(playerController!),
            ),
            SizedBox(height: 30,),
            //Upload Now

            //circular progress bars


            //input fields
            showProgressBar == true ?
             Container(
              child:  SimpleCircularProgressBar(
                progressColors: [
                  Colors.green,
                  Colors.blue,
                  Colors.deepPurple,
                  Colors.yellow,
                  Colors.grey,
                 
                ],
                animationDuration: 10,
                
              ),
             ):
             Column(
              children: [
                //artist song
                 Container(
               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      width: MediaQuery.of(context).size.width,
              child: InputTextWidget(
                textEditingController: artistSongTextEditingController, 
                lableString: 'Artist Name', 
                isObsecure: false,
                iconData: Icons.music_video_sharp,),
            ),

                //description tags
                Container(
               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      width: MediaQuery.of(context).size.width,
              child: InputTextWidget(
                textEditingController: descriptionTagsTextEditingController, 
                lableString: 'Description - Tags', 
                isObsecure: false,
                iconData: Icons.slideshow_outlined,),
            ),
SizedBox(height: 20,),
                //Upload Now Button
                 Container(
                  width: MediaQuery.of(context).size.width-38,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18)
                    ),
                    
                  ),
                  child: InkWell(
                    onTap: () {
                      if(artistSongTextEditingController.text.isNotEmpty
                      && descriptionTagsTextEditingController.text.isNotEmpty
                      )
                      {
                        uploadVideoController.saveVideoInformationToFireStoreDatabase(
                          artistSongTextEditingController.text, 
                          descriptionTagsTextEditingController.text, 
                          widget.videoPath,
                          context);
                          
                      setState(() {
                        showProgressBar = true;
                      });
                      }
                    
                  
                 
                    },
                    child: Center(
                      child: Text('Upload Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20
                      ),),
                    ),
                  ),
                ),
                SizedBox(height: 20,)

              ],
             )


          ],
        ),
      ),
    );
  }
}