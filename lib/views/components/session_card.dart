import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricai/utilities/format_date.dart';
import 'package:cricai/constants/colors.dart';
import 'package:flutter/material.dart';

typedef SessionCallback<T> = void Function(T);

class SessionCard<T> extends StatefulWidget {
  final String name;
  final Timestamp time;
  final T item;
  final SessionCallback onTap;

  const SessionCard({
    super.key,
    required this.name,
    required this.time,
    required this.item,
    required this.onTap,
  });

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = formatDate(widget.time.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.item);
      },
      child: Card(
        elevation: 3,
        color: AppColors.lightBackgroundColor,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.only(
          top: 15.0,
          bottom: 5.0,
          left: 3.0,
          right: 3.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
              child: Image.asset(
                'assets/images/session.png',
                height: 200,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            ListTile(
              title: Text(
                widget.name,
                style: const TextStyle(
                  color: AppColors.darkTextColor,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                formattedDate,
                style: const TextStyle(
                  color: AppColors.darkTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
