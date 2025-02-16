import 'package:flexx_bet/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../bets_screens/bets_screen.dart';
import '../../components/custom_button.dart';


class EventJoinMassagesPopup{


 static  showOpponentPopup(BuildContext context, EventModel event) {
    showDialog(
      barrierColor: ColorConstant.black900.withOpacity(0.8),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            height: 398,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
               Padding(
                 padding: const EdgeInsets.only(left: 20),
                 child: Image.asset(ImageConstant.image2_icon,height: 170.94,width: 132.73,),
               ),
                const Text("   All players are currently busy.\nWe are looking for an opponent for you",style: TextStyle(
                  fontFamily: "Popins",
                  fontSize: 15
                ),),
                const Spacer(),
                ElevatedButton(
              style:  ButtonStyle(
                fixedSize:  MaterialStateProperty.all(
                 const Size(307,48),
                ),
                backgroundColor:  MaterialStateProperty.all(
                 const Color(0xffBEFF07)
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                )
              ),
                    onPressed: (){
                Navigator.pop(context);
                    },
                    child: const Text("Join other events",style: TextStyle(
                      fontFamily: "Popins",
                      fontSize: 18,
                      color: Colors.black
                    ),)),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    style:  ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          const Size(307,48),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                           ColorConstant.primaryColor
                        ),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        )
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Continue waiting",style: TextStyle(
                        fontFamily: "Popins",
                        fontSize: 18,
                        color: Colors.white
                    ),)),
              ],
            ),
          ),
        );
      },
    );
  }

 static  showPositionPopup(BuildContext context, EventModel event) {
   showDialog(
     barrierColor: ColorConstant.black900.withOpacity(0.8),
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         backgroundColor: Colors.transparent,
         elevation: 0,
         content: Container(
           height: 398,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
             gradient: LinearGradient(
               colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
             ),
             borderRadius: BorderRadius.circular(20.0),
           ),
           padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Image.asset(ImageConstant.image1_icon,height: 170.94,width: 132.73,),
               Text("   Your position in the queue has moved up.You are  now number ${event.peopleWaiting.length}",style: const TextStyle(
                   fontFamily: "Popins",
                   fontSize: 14,
                 fontWeight: FontWeight.w400
               ),),
               const SizedBox(
                 height: 24,
               ),
               const Text("Check other events while you wait.",style: TextStyle(
                   fontFamily: "Popins",
                   fontSize: 14,
                   fontWeight: FontWeight.w400
               ),),
               const Spacer(),


               ElevatedButton(
                   style:  ButtonStyle(
                       fixedSize:  MaterialStateProperty.all(
                        const Size(307,48),
                       ),
                       backgroundColor: MaterialStateProperty.all(
                           ColorConstant.primaryColor
                       ),
                       shape: MaterialStateProperty.all(
                           RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10)
                           )
                       )
                   ),
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   child: const Text("Continue waiting",style: TextStyle(
                       fontFamily: "Popins",
                       fontSize: 18,
                       color: Colors.white
                   ),)),
               const SizedBox(
                 height: 12,
               ),
               ElevatedButton(
                   style:  ButtonStyle(
                       fixedSize:  MaterialStateProperty.all(
                         const Size(307,48),
                       ),
                       backgroundColor:  MaterialStateProperty.all(
                           const Color(0xffBEFF07)
                       ),
                       shape: MaterialStateProperty.all(
                           RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10)
                           )
                       )
                   ),
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   child: const Text("Join other events",style: TextStyle(
                       fontFamily: "Popins",
                       fontSize: 18,
                       color: Colors.black
                   ),)),
             ],
           ),
         ),
       );
     },
   );
 }

 static  showEventEndPopup(BuildContext context) {
   showDialog(
     barrierColor: ColorConstant.black900.withOpacity(0.8),
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         backgroundColor: Colors.transparent,
         elevation: 0,
         content: Container(
           height: 341,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
             gradient: LinearGradient(
               colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
             ),
             borderRadius: BorderRadius.circular(20.0),
           ),
           padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Image.asset(ImageConstant.oops_icon,height: 170.94,width: 132.73,),
               const Text("         This event has ended.\nif you weren't matched, please consider joining another event.\nCheck other events while you wait.",style: TextStyle(
                   fontFamily: "Popins",
                   fontSize: 14,
                   fontWeight: FontWeight.w400
               ),),
               const Spacer(),
               ElevatedButton(
                   style:  ButtonStyle(
                       fixedSize: MaterialStateProperty.all(
                         const Size(307,48),
                       ),
                       backgroundColor: MaterialStateProperty.all(
                           ColorConstant.primaryColor
                       ),
                       shape: MaterialStateProperty.all(
                           RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10)
                           )
                       )
                   ),
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   child: const Text("Continue waiting",style: TextStyle(
                       fontFamily: "Popins",
                       fontSize: 18,
                       color: Colors.white
                   ),)),
             ],
           ),
         ),
       );
     },
   );
 }



}