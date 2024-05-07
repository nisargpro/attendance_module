import 'package:attendance_module/presentaion/verify_screen.dart';
import 'package:attendance_module/utils/app_colors.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ScannerScreen extends HookWidget {
  const ScannerScreen({super.key,required this.imagePath,});
  final String imagePath;

  @override
  Widget build(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Verification'),
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/image2.png',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Align(child: Image.asset('assets/Frame.png')),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    goToNextScreen(context: context, pageName: VerifyScreen(imagePath: imagePath,));
                  },
                  child: Wrap(
                    spacing: 8,
                    children: const [
                      Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      Text(
                        'Re-Take ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
