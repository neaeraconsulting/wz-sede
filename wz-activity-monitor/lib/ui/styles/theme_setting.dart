import 'package:flutter/material.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/text_styles.dart';

final _base = ThemeData.light();
final _baseDark = ThemeData.dark();

final ThemeData lightTheme = _base.copyWith(
  //colors
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightBackgroundColor,
  primaryColor: primaryColor,
  canvasColor: primaryColor,
  disabledColor: disabledColor,
  focusColor: primaryColor,
  hintColor: textPrimaryColor,
  hoverColor: selectedColor,
  primaryColorDark: darkPrimaryColor,
  colorScheme: _base.colorScheme.copyWith(
    primary: primaryColor,
    onSurface: textPrimaryColor,
    onPrimary: textPrimaryColor,
    onPrimaryContainer: textPrimaryColor,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: lightGrey,
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: selectedColor,
  ),

  //widgets
  elevatedButtonTheme: buttonStyle(),
  inputDecorationTheme: inputTextTheme(),
  dropdownMenuTheme: lightDropdownMenuTheme(),
  textButtonTheme: lightTextTheme(),
  listTileTheme: ListTileThemeData(
    textColor: textPrimaryColor,
    titleTextStyle: styleBody.copyWith(color: textPrimaryColor),
    subtitleTextStyle: styleBody.copyWith(color: darkGrey),
  ),
  cardTheme: CardThemeData(
    color: lightGrey,
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(  
      color: textPrimaryColor,
      width: 2, 
    )
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: lightGrey, 
    headerForegroundColor: textPrimaryColor,
    rangePickerBackgroundColor: lightGrey,
    rangePickerHeaderForegroundColor: textPrimaryColor,
    rangePickerShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // <-- Set your desired radius
    ),
    rangeSelectionBackgroundColor: mediumGrey,    
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: lightGrey, 
    dayPeriodColor: primaryColor,
    hourMinuteColor: extraLightGrey,
    dialBackgroundColor: extraLightGrey,
    dayPeriodTextColor: textPrimaryColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(foregroundColor: WidgetStateProperty.all<Color>(textPrimaryColor))
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkGrey,
    foregroundColor: lightGrey,
  ),
);

final ThemeData darkTheme = _baseDark.copyWith(
  //colors
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBackgroundColor,
  primaryColor: darkPrimaryColor,
  canvasColor: darkPrimaryColor,
  disabledColor: darkDisabledColor,
  focusColor: darkPrimaryColor,
  hintColor: darkTextPrimaryColor,
  hoverColor: darkSelectedColor,
  colorScheme: _base.colorScheme.copyWith(
    primary: darkPrimaryColor,
    onSurface: darkTextPrimaryColor,
    onPrimary: darkTextPrimaryColor,
    onPrimaryContainer: darkTextPrimaryColor,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: darkGrey,
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: darkSelectedColor,
  ),

  //widgets
  elevatedButtonTheme: darkButtonStyle(),
  inputDecorationTheme: darkInputTextTheme(),
  dropdownMenuTheme: darkDropdownMenuTheme(),
  textButtonTheme: darkTextTheme(),
  listTileTheme: ListTileThemeData(
    textColor: darkTextPrimaryColor,
    titleTextStyle: styleBody.copyWith(color: darkTextPrimaryColor),
    subtitleTextStyle: styleBody.copyWith(color: lightGrey),
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(
      color: darkTextPrimaryColor,
      width: 2,
    )
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: darkGrey, 
    headerForegroundColor: darkTextPrimaryColor,
    rangePickerBackgroundColor: darkGrey,
    rangePickerHeaderForegroundColor: darkTextPrimaryColor,
    rangePickerShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // <-- Set your desired radius
    ),
    rangeSelectionBackgroundColor: extraDarkGrey,    
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: darkGrey, 
    dayPeriodColor: darkPrimaryColor,
    hourMinuteColor: extraDarkGrey,
    dialBackgroundColor: extraDarkGrey,
    dayPeriodTextColor: darkTextPrimaryColor,
  ),
  
  appBarTheme: AppBarTheme(
    backgroundColor: darkPrimaryColor,
  ),
  iconButtonTheme:
      IconButtonThemeData(style: ButtonStyle(foregroundColor: WidgetStateProperty.all<Color>(darkTextPrimaryColor))),
  cardTheme: CardThemeData(  
    color: darkGrey,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightGrey,
    foregroundColor: darkGrey,
  ),
);

//Button Themes
ElevatedButtonThemeData buttonStyle() {
  return ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return mediumGrey;
        }
        return primaryColor;
      },
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return darkBackgroundColor;
        }
        return Colors.black;
      },
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
  ));
}

ElevatedButtonThemeData darkButtonStyle() {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return extraDarkGrey;
          }
          return darkPrimaryColor;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return mediumGrey;
          }
          return lightGrey;
        },
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      )),
    ),
  );
}

//Input Text Theme
InputDecorationTheme inputTextTheme() {
  return InputDecorationTheme(
    labelStyle: styleBody.copyWith(color: darkGrey),
    hintStyle: styleBody.copyWith(color: mediumGrey),
    counterStyle: styleBody.copyWith(color: darkGrey),
    floatingLabelStyle: styleBody.copyWith(color: textPrimaryColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: darkGrey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: mediumGrey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}

InputDecorationTheme darkInputTextTheme() {
  return InputDecorationTheme(
    labelStyle: styleBody.copyWith(color: lightGrey),
    hintStyle: styleBody.copyWith(color: lightGrey),
    counterStyle: styleBody.copyWith(color: lightGrey),
    floatingLabelStyle: styleBody.copyWith(color: darkTextPrimaryColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: lightGrey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: mediumGrey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}

DropdownMenuThemeData lightDropdownMenuTheme() {
  return DropdownMenuThemeData(
    textStyle: styleBody.copyWith(color: textPrimaryColor),
    inputDecorationTheme: inputTextTheme().copyWith(
      filled: true,
      fillColor: lightGrey,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all<Color>(extraLightGrey),
      surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
  );
}

DropdownMenuThemeData darkDropdownMenuTheme() {
  return DropdownMenuThemeData(
    textStyle: styleBody.copyWith(color: darkTextPrimaryColor),
    inputDecorationTheme: darkInputTextTheme().copyWith(
      filled: true,
      fillColor: darkGrey,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all<Color>(extraDarkGrey),
      surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
  );
}

lightTextTheme() {
  return TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(textPrimaryColor),
    ),
  );
}

darkTextTheme() {
  return TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(darkTextPrimaryColor),
    ),
  );
}

