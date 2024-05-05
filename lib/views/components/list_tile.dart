import 'package:cricai/constants/colors.dart';
import 'package:cricai/views/components/menu_button.dart';
import 'package:flutter/material.dart';

typedef SessionCallback<T> = void Function(T);

class CustomListTile<T> extends StatefulWidget {
  final String title;
  final IconData leadingIcon;
  final Color leadingIconColor;
  final T item;
  final SessionCallback onTap;
  final SessionCallback onDeleteSession;

  const CustomListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.leadingIconColor,
    required this.item,
    required this.onTap,
    required this.onDeleteSession,
  });

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.greyColor,
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(12.0), // Border radius
        ),
        child: InkWell(
          onTap: () {
            widget.onTap(widget.item);
          },
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            dense: false,
            leading: Icon(
              widget.leadingIcon,
              // Icons.format_list_bulleted_rounded,
              color: widget.leadingIconColor,
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.darkTextColor,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: MenuButton(
              onDeleteSession: widget.onDeleteSession,
              item: widget.item,
            ),
          ),
        ),
      ),
    );
  }
}
