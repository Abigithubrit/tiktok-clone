import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video/authentication/login_screen.dart';
import 'package:video/authentication/registeration_screen.dart';
import 'package:video/global.dart';
import 'package:video/widgets/input_text_widgets.dart';

import 'authentication_controller.dart';
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
 
  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
          
              Text('Create Account',
             style: TextStyle(
              fontFamily: 'Lobster',
          fontSize: 25
             ),
              
            ),
            Text('To get Started Now!',
             style: TextStyle(
              fontFamily: 'Lobster',
              fontSize: 25
             ),
              
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                //allow user to choose image
                showDialog(context: context,
                 builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(onPressed: () {
                        authenticationController.captureImageWithCamera();    
                      }, child: Text('Capture With Camera')),
                      ElevatedButton(onPressed: () {
                        authenticationController.chooseImageFromGallery();    
                      }, child: Text('Choose From Gallery')),
                      
                    ],
                  ),
                 ),);            
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('images/profile_avatar.jpg'),
              ),
              
            ),
            SizedBox(height: 10,),
            //Useranme
            Container(
               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      width: MediaQuery.of(context).size.width,
              child: InputTextWidget(
                textEditingController: userNameTextEditingController, 
                lableString: 'Username', 
                isObsecure: false,
                iconData: Icons.person_outline,),
            ),
            //email
            Container(
               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      width: MediaQuery.of(context).size.width,
              child: InputTextWidget(
                textEditingController: emailTextEditingController, 
                lableString: 'Email', 
                isObsecure: false,
                iconData: Icons.email_outlined,),
            ),
            //password
            Container(
               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      width: MediaQuery.of(context).size.width,
              child: InputTextWidget(
                textEditingController: passwordTextEditingController, 
                lableString: 'Password', 
                isObsecure: true,
                iconData: Icons.lock,),
            ),
            //loginbutton

            //not have a account button
            showProgressBar == false?
            Column(
              children: [
                //signin button
                Container(
                  width: MediaQuery.of(context).size.width-38,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18)
                    ),
                    
                  ),
                  child: InkWell(
                    onTap: () {
                    if(
                      authenticationController.profileImage!=null 
                      && userNameTextEditingController.text.isNotEmpty
                      && emailTextEditingController.text.isNotEmpty
                      && passwordTextEditingController.text.isNotEmpty 
                    )
                    {

                      setState(() {
                        showProgressBar = true;
                      });
                      //create a new user
                        authenticationController.createAccountForNewUser(
                    authenticationController.profileImage!, 
                    userNameTextEditingController.text, 
                    emailTextEditingController.text, 
                    passwordTextEditingController.text);
                    }
                      //signup user now
                 
                    },
                    child: Center(
                      child: Text('Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20
                      ),),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Text("Already have an account? ",
                    style: TextStyle(
                      fontFamily: '',
                      fontSize: 16,
                      color: Colors.grey
                    ),),
                     InkWell(
                       onTap: () {
                       
                       //send user to signup screen
                       Get.to(LoginScreen());
                       },
                       child: Center(
                         child: Text('Login Now',
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.w700,
                           fontSize: 16
                         ),),
                       ),
                     ),
                   ],
                 ),
              ],
            ):Container(
              padding: EdgeInsets.all(30),
              child: SimpleCircularProgressBar(
                progressColors: [
                  Colors.green,
                  Colors.blue,
                  Colors.deepPurple,
                  Colors.yellow,
                  Colors.grey,
                 
                ],
                animationDuration: 3,
                
              ),
            )
            ],
          ),
        ),
      )
    );
  }
}