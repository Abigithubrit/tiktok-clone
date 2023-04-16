import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video/authentication/registeration_screen.dart';
import 'package:video/widgets/input_text_widgets.dart';

import 'authentication_controller.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;
  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
              Image.asset('images/tiktok.png',
              width: 200,),
              Text('Welcome',
             style: TextStyle(
              fontFamily: 'Lobster'
             ),
              
            ),
            Text('Glad to see you!',
             style: TextStyle(
              fontFamily: 'Lobster'
             ),
              
            ),
            SizedBox(height: 10,),
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
                //login button
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
                   
                      //login user now
                      if(emailTextEditingController.text.isNotEmpty
                      &&passwordTextEditingController.text.isNotEmpty)
                      {
                           setState(() {
                        showProgressBar = true;
                      });
                        authenticationController.loginUserNow(
                          emailTextEditingController.text,
                          passwordTextEditingController.text,
                        );
                      }
                    },
                    child: Center(
                      child: Text('Login',
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
                    Text("Don't have an account? ",
                    style: TextStyle(
                      fontFamily: '',
                      fontSize: 16,
                      color: Colors.grey
                    ),),
                     InkWell(
                       onTap: () {
                       
                       //send user to signup screen
                       Get.to(RegistrationScreen());
                       },
                       child: Center(
                         child: Text('Sign Up Now',
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