import 'package:cricai/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef VideoCallback<T> = void Function(T);

class VideoCard<T> extends StatefulWidget {
  final String name;
  final T item;
  final VideoCallback onTap;

  const VideoCard({
    super.key,
    required this.name,
    required this.item,
    required this.onTap,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = cardWidth;

    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.onTap(widget.item);
          },
          child: Card(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/session.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(
                  color: AppColors.darkTextColor,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
