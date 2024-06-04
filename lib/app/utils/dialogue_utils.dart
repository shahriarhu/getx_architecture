import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';

class DialogUtils {
  static void showLoading({String title = "Loading..."}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),

                const CircularProgressIndicator.adaptive(),
                // SpinKitWaveSpinner(
                //   color: AppColors.saveBtnColor,
                // ),
                // SpinKitThreeBounce(
                //   size: Dimensions.height15 * 2.5,
                //   itemBuilder: (BuildContext context, int index) {
                //     return DecoratedBox(
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: index.isEven
                //             ? AppColors.greenColor
                //             : AppColors.redColor,
                //       ),
                //     );
                //   },
                // ),
                // Center(
                //   child: CircularProgressIndicator.adaptive(
                //     backgroundColor: AppColors.greyColor.withOpacity(.2),
                //     valueColor: AlwaysStoppedAnimation(AppColors.saveBtnColor),
                //     strokeCap: StrokeCap.square,
                //   ),
                // ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static bool isPresentedDialog = false;
  static void showConnectionLostAlertDialogue(
      {String title = "Oops Error",
      String description = "Something went wrong",
      VoidCallback? onTap}) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text(
          "Connection Error",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Looks like your internet connection is lost",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: onTap,
              child: const Text("Try Again"),
            )
          ],
        ),
      ),
    );
  }

  static void showSnackBar(String messageTitle, String messageBody) {
    Get.snackbar(
      messageTitle,
      messageBody,
      icon: const Icon(Icons.person, color: Colors.white),
      borderWidth: 1.5,
      borderColor: Colors.black54,
      colorText: Colors.white,
      backgroundColor: primaryColor,
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.TOP,
    );
  }
}
