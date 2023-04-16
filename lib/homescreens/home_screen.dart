import 'package:flutter/material.dart';
import 'package:video/homescreens/following/followings_video.dart';
import 'package:video/homescreens/foryou/foryou_video_screen.dart';
import 'package:video/homescreens/profile/profile_screen.dart';
import 'package:video/homescreens/search/search_screen.dart';
import 'package:video/homescreens/uploadvideo/upload_custom_icon.dart';
import 'package:video/homescreens/uploadvideo/upload_video_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int screenIndex = 0;
  List screensList = 
  [
    ForYouVideoScreen(),
    SearchScreen(),
    UploadVideoScreen(),
    FollowingsVideoScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
           screenIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: screenIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 30,),label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,size: 30,),label: 'Search'),
            BottomNavigationBarItem(
            icon:UploadCustomIcon(),
            label: 'Upload'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_sharp,size: 30,),label: 'Following'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 30,),label: 'Me'),
          
        ],
      ),
      body: screensList[screenIndex],
    
    );
  }
}