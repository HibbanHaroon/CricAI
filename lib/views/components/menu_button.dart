import 'package:cricai/constants/colors.dart';
import 'package:cricai/enums/menu_action.dart';
import 'package:flutter/material.dart';

typedef SessionCallback<T> = void Function(T);

class MenuButton<T> extends StatefulWidget {
  final SessionCallback onDeleteSession;
  final T item;

  const MenuButton({
    super.key,
    required this.onDeleteSession,
    required this.item,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      child: const Icon(
        Icons.more_vert,
        color: AppColors.placeholderColor,
      ),
      onSelected: (value) {
        switch (value) {
          case MenuAction.edit:
            // add desired output
            break;
          case MenuAction.delete:
            widget.onDeleteSession(widget.item);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
        const PopupMenuItem<MenuAction>(
          value: MenuAction.edit,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.create_rounded),
              ),
              Text(
                'Edit',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuAction.delete,
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.delete)),
              Text(
                'Delete',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
