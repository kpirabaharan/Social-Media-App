import 'package:flutter/material.dart';

import './screens/auth_prompt_screen.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor darkColor = MaterialColor(
      0xFF174378,
      <int, Color>{
        50: Color(0xFF7F98B5),
        100: Color(0xFF748EAE),
        200: Color(0xFF5D7BA1),
        300: Color(0xFF456993),
        400: Color(0xFF2E5685),
        500: Color(0xFF174378),
        600: Color(0xFF153C6C),
        700: Color(0xFF123660),
        800: Color(0xFF102F54),
        900: Color(0xFF0E2848),
      },
    );
    final lightTheme = ThemeData(
      colorScheme:
          ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(secondary: Colors.orange),
      fontFamily: 'Rubik',
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
      ),
    );
    final darkTheme = ThemeData(
      colorScheme:
          ColorScheme.fromSwatch(primarySwatch: darkColor).copyWith(secondary: Colors.blue),
      fontFamily: 'Rubik',
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Rubik'),
        titleLarge: TextStyle(
          color: Colors.white,
        ),
      ),
      cardColor: Color.fromRGBO(158, 158, 158, 0.5),
      canvasColor: Color.fromARGB(255, 48, 48, 48),
    );

    return MaterialApp(
        title: 'Sociopedia',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: AuthPromptScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen()
        });
  }
}