import 'package:cricai/constants/colors.dart';
import 'package:cricai/enums/menu_action.dart';
import 'package:flutter/material.dart';

typedef SessionCallback<T> = void Function(T);

class MenuButton<T> extends StatefulWidget {
  final SessionCallback? onDelete;
  final SessionCallback? onEdit;
  final List<MenuAction> actions;
  final T item;

  const MenuButton({
    super.key,
    required this.onDelete,
    required this.onEdit,
    required this.actions,
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
            widget.onEdit?.call(widget.item);
            break;
          case MenuAction.delete:
            widget.onDelete?.call(widget.item);
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<MenuAction>> items = [];

        for (var action in widget.actions) {
          switch (action) {
            case MenuAction.edit:
              if (widget.onEdit != null) {
                items.add(_buildMenuItem(action, Icons.create_rounded, 'Edit'));
              }
              break;
            case MenuAction.delete:
              if (widget.onDelete != null) {
                items.add(_buildMenuItem(action, Icons.delete, 'Delete'));
              }
              break;
            // Handle other menu actions here if needed
          }
        }

        return items;
      },
    );
  }

  PopupMenuItem<MenuAction> _buildMenuItem(
      MenuAction action, IconData icon, String text) {
    return PopupMenuItem<MenuAction>(
      value: action,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
