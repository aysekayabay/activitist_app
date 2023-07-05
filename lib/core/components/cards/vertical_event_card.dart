import 'package:akademi_bootcamp/core/base/extensions/date_time_converter.dart';
import 'package:akademi_bootcamp/core/components/image/custom_image.dart';
import 'package:akademi_bootcamp/core/constants/image/image_constants.dart';
import 'package:akademi_bootcamp/core/model/event_model.dart';
import 'package:flutter/material.dart';

import '../../constants/theme/theme_constants.dart';

// ignore: must_be_immutable
class VerticalEventCard extends StatelessWidget {
  VerticalEventCard({super.key, required this.deviceWidth, required this.eventModel, this.onTap});

  final double deviceWidth;
  void Function()? onTap;
  final EventModel eventModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.lowSize),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: AppSizes.lowSize),
              width: deviceWidth / 3,
              child: Align(
                alignment: Alignment.topCenter,
                child: CustomImage(
                  imageUrl: eventModel.posterUrl!,
                  backupImagePath: ImageConstants.AUTH_IMAGE,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventModel.name!, overflow: TextOverflow.ellipsis, style: TextStyle().copyWith(color: AppColors.vanillaShake)),
                  Text(eventModel.start!.formattedDay + ', ' + eventModel.start!.formattedTime, style: TextStyle().copyWith(color: AppColors.vanillaShake)),
                  Text(eventModel.venue!.name!, overflow: TextOverflow.ellipsis, style: TextStyle().copyWith(color: AppColors.vanillaShake))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}