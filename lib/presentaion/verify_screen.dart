import 'dart:io';

import 'package:attendance_module/presentaion/failed_screen.dart';
import 'package:attendance_module/utils/app_colors.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VerifyScreen extends HookWidget {
  const VerifyScreen({
    required this.imagePath,
    super.key,
  });

  final String imagePath;

  @override
  Widget build(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isVerified = useState<bool>(false);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: double.infinity,
        height: size.height * 0.06,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isVerified.value ? AppColors.buttonColor : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              goToNextScreen(context: context, pageName: FailedScreen(imagePath: imagePath,));
            },
            child: Text(
              'Submit  ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Face Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: size.width * 0.6,
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/image1.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: isVerified.value? Text(
                 'Face Verified Successfully',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ):Text(
                'We couldnt recognize your face',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Visibility(
                visible: !isVerified.value,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 2,color: AppColors.buttonColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      isVerified.value = true;
                    },
                    child: Wrap(
                      children: [
                        Icon(
                          Icons.refresh,
                          color: AppColors.buttonColor,
                        ),
                        Text(
                          'Re-Take ',
                          style: TextStyle(
                            color: AppColors.buttonColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
