import 'package:cricai/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  final double width;
  final String initialSelection;
  final String label;
  final void Function(String?) onSelected;
  final List<String> types;

  const CustomDropdownMenu({
    super.key,
    required this.width,
    required this.initialSelection,
    required this.label,
    required this.onSelected,
    required this.types,
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        DropdownMenu<String>(
          width: widget.width,
          initialSelection: widget.initialSelection,
          label: Text(
            widget.label,
          ),
          onSelected: (String? value) {
            widget.onSelected(value);
          },
          dropdownMenuEntries:
              widget.types.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(
              value: value,
              label: value,
              style: MenuItemButton.styleFrom(
                textStyle: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                  height: 1.0,
                  color: AppColors.darkTextColor,
                ),
                foregroundColor: AppColors.primaryColor,
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
