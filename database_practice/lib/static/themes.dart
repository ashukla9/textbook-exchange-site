// Defining themes for styling! 

import 'package:flutter/material.dart';

// importing the file where we specified all our 'custom' colors
import 'colors.dart';

class CustomTheme { //I named it "CustomTheme" but we can definitely name it something else. 

  static ThemeData get lightTheme { //1
    return ThemeData( //2
      primaryColor: CustomColors.lsMaroon,

      // Background color
      scaffoldBackgroundColor: CustomColors.offWhite,

      // specify font family. This is just example code...i don't think it's being used right now.
      fontFamily: 'Montserrat', //3
      
      // technically this is unused since we have no regular buttons atm
      buttonTheme: ButtonThemeData( // 4
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: CustomColors.lsMaroon,
      ),

      // Styling elevated buttons (the type we're using on all our pages right now)
      elevatedButtonTheme: ElevatedButtonThemeData( // https://www.woolha.com/tutorials/flutter-using-elevatedbutton-widget-examples
        style: ElevatedButton.styleFrom(
              primary: CustomColors.lsMaroon,
            ),
      ),

    );
  }


}
