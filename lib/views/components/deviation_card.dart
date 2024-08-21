import 'package:cricai/constants/colors.dart';
import 'package:cricai/utilities/to_snake_case.dart';
import 'package:flutter/material.dart';

class DeviationCard extends StatefulWidget {
  final String angleName;
  final int deviation;
  const DeviationCard({
    super.key,
    required this.angleName,
    required this.deviation,
  });

  @override
  State<DeviationCard> createState() => _DeviationCardState();
}

class _DeviationCardState extends State<DeviationCard> {
  double borderWidth = 1;
  Color color = AppColors.lightBackgroundColor;
  Color borderColor = AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    if (widget.deviation >= 0 && widget.deviation <= 20) {
      borderWidth = 1;
      color = AppColors.lightBackgroundColor;
      borderColor = AppColors.primaryColor;
    } else if (widget.deviation > 20 && widget.deviation <= 70) {
      borderWidth = 2;
      color = AppColors.redLightBackgroundColor;
      borderColor = AppColors.redColor;
    } else if (widget.deviation > 70 && widget.deviation <= 100) {
      borderWidth = 3;
      color = AppColors.redMediumBackgroundColor;
      borderColor = AppColors.redColor;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 75,
                    child: Text(
                      widget.angleName,
                      style: const TextStyle(
                        color: AppColors.darkTextColor,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Deviation',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '${widget.deviation}%',
                        style: const TextStyle(
                          color: AppColors.redColor,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.asset(
                  'assets/images/${convertToSnakeCase(widget.angleName)}.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
