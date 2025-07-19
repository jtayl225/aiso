import 'package:aiso/constants/font_sizes.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpDetails extends StatelessWidget {
  
  final DeviceScreenType deviceType;

  const SignUpDetails({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    // final bool isDesktop =
    //     deviceType == DeviceScreenType.desktop ? true : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
          // isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Join GEOMAX.',
          style: AppTextStyles.h1(deviceType),
          textAlign: TextAlign.center,
          // textAlign: isDesktop ? TextAlign.center : TextAlign.start,
        ),
        SizedBox(height: 16),
        Text(
          'Be Found. Gain Trust. Get Leads.',
          // style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
          style: AppTextStyles.h3(deviceType).copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          // textAlign: isDesktop ? TextAlign.center : TextAlign.start,
        ),

        SizedBox(height: 32),

        // TextButton(
        //   // onPressed: appRouter.go(signUpRoute),
        //   style: TextButton.styleFrom(
        //     padding:
        //         EdgeInsets.zero, // Removes default 16px horizontal padding
        //     alignment: Alignment.centerLeft, // Aligns content to the left
        //     tapTargetSize:
        //         MaterialTapTargetSize
        //             .shrinkWrap, // Optional: makes hitbox smaller
        //   ),
        //   onPressed: () => appRouter.go(signInRoute),
        //   child: RichText(
        //     textAlign: TextAlign.center,
        //     // textAlign: isDesktop ? TextAlign.center : TextAlign.start,
        //     text: TextSpan(
        //       style: DefaultTextStyle.of(
        //         context,
        //       ).style.copyWith(fontSize: fontSizeDesktopMedium),
        //       children: [
        //         TextSpan(
        //           text: 'If you already have an account? ',
        //           style: AppTextStyles.h3(deviceType),
        //           ),
        //         TextSpan(
        //           text: 'click here.',
        //           // style: const TextStyle(fontWeight: FontWeight.bold),
        //           style: AppTextStyles.h3(deviceType).copyWith(fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

      ],
    );
  }
}
