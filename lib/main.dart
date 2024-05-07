import 'package:attendance_module/presentaion/inital_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
        title: 'attendance_module',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.encodeSansExpandedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: InitialScreen(),
      );
}
