import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video/authentication/login_screen.dart';
import 'package:video/authentication/registeration_screen.dart';
import 'package:video/global.dart';
import 'package:video/homescreens/home_screen.dart';
import 'user.dart' as userModel;
class AuthenticationController extends GetxController
{
  static AuthenticationController instanceAuth = Get.put(AuthenticationController());
  late Rx<User?> _currentUser;
  late Rx<File?> _pickedFile;
  File? get profileImage => _pickedFile.value;

  void chooseImageFromGallery()async{
   final pickedImageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
   if(pickedImageFile!=null)
   {
    Get.snackbar(
      'Profile Image', 'You have successfully selected your profile image');
   }
  _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }
  void captureImageWithCamera()async{
   final pickedImageFile = await ImagePicker().pickImage(source: ImageSource.camera);
   if(pickedImageFile!=null)
   {
    Get.snackbar(
      'Profile Image', 'You have successfully selected your profile image');
   }
  _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }
  void createAccountForNewUser(
    File imageFile, String userName,String userEmail,String userPassword)
    async{

     try{
       //1.Create user in the authentication
      UserCredential credential =await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail, 
        password: userPassword);

      //2.save the user profile image to firebase storage
      String imagedownloadUrl =await uploadImageToStorage(imageFile
      );

      //3. save to the firebase firestore database
      userModel.User user = userModel.User(
        name: userName,
        email: userEmail,
        image: imagedownloadUrl,
        uid: credential.user!.uid,
        
      );
      await FirebaseFirestore.instance.collection('users')
      .doc(credential.user!.uid)
      .set(user.toJson());
      Get.snackbar('Account Created', 'Congratulation your account ahve been created.');
      showProgressBar =false;
     }catch(error)
     {
      Get.snackbar('Account Creation Error', 'Error Occurred while creating account');
      showProgressBar =false;
      Get.to(LoginScreen());
     }


    }
   Future<String> uploadImageToStorage(File imageFile)
    async{
      Reference reference = FirebaseStorage.instance.ref()
      .child('Profile-Images')
      .child(FirebaseAuth.instance.currentUser!.uid);

      UploadTask uploadTask =reference.putFile(imageFile);
      TaskSnapshot taskSnapshot =await uploadTask;
     String downloadUrlOfUploadedImage = await taskSnapshot.ref.getDownloadURL();
     return downloadUrlOfUploadedImage;
    }
    void loginUserNow(String userEmail,String userPassword)async{
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail, 
          password: userPassword);
          Get.snackbar('Login successful', 'Congratulations You are logged in successful');
      showProgressBar =false;
      
      }catch(error)
     {
      Get.snackbar('Login Unsuccessful Error Occureed', 'Error Occurred while login account');
      showProgressBar =false;
      Get.to(RegistrationScreen());
     }

    }
    goToScreen(User? currentUser)
    {
      //user is not already logged in
      if(currentUser == null)
      {
        Get.offAll(LoginScreen());
      }
      //when user is already loggedin
      else{
        Get.offAll(HomeScreen());
      }
    }
    @override
    void onReady(){
      super.onReady();
     _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
     _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
     ever(_currentUser, goToScreen);

    }
}