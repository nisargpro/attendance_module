import 'dart:convert';

import 'package:attendance_module/presentaion/scanning_page.dart';
import 'package:attendance_module/utils/app_images.dart';
import 'package:camera/camera.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CameraScreen extends HookWidget {
  const CameraScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final isCameraInitialized = useState<bool>(false);
    final controller = useCameraController(isCameraInitialized);

    if (controller == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Face Verification'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  Appimages.backgroundImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Align(
                  child: Image.asset(
                    Appimages.squareImage,
                    width: 400,
                    fit: BoxFit.cover,
                  ),
                ),
                // Camera preview
                Align(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 10 / 8,
                        child: OverflowBox(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: CameraPreview(controller),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(
                    value: 0.0, // Change the value to show progress
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                takePictureAndMoveToNextScreen(context, controller),
            child: Text('Take Picture'),
          ),
        ],
      ),
    );
  }

  Future<CameraController?> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return null;
    }
    final controller = CameraController(cameras[1], ResolutionPreset.medium);
    await controller.initialize();
    return controller;
  }

  CameraController? useCameraController(
      final ValueNotifier<bool> isInitialized) {
    final controller = useState<CameraController?>(null);

    useEffect(() {
      initializeCamera().then((final value) {
        controller.value = value;
        isInitialized.value = true;
      });

      return () {
        controller.value?.dispose();
      };
    }, []);

    return controller.value;
  }

  Future<void> takePictureAndMoveToNextScreen(
      final BuildContext context, final CameraController controller) async {
    try {
      final picture = await controller.takePicture();

      final List<int> imageBytes = await picture.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      customPrint(base64Image);
      await uploadImage(base64Image); /// image upload function

      await showDialog(
        context: context,
        builder: (final _) => AlertDialog(
          content: Text('Picture Uploaded!'),
          actions: [
            TextButton(
              onPressed: () {
                popScreen(context: context);
                // Navigate to the next screen
                goToNextScreen(
                    context: context,
                    pageName: ScannerScreen(
                      imagePath: picture.path,
                    ));
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> uploadImage(final String imageData) async {
    try {
      ///making the api call where i will be uploading the binary data to backhand
    } catch (e) {
      /// handing the errors
    }
  }
}
