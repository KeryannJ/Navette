import 'package:flutter/material.dart';

class MyDropDownMenu extends StatefulWidget {
  final List<String> items;
  const MyDropDownMenu({super.key, required this.items});

  @override
  State<MyDropDownMenu> createState() => MyDropdownMenuState();
}

class MyDropdownMenuState extends State<MyDropDownMenu> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: dropdownValue,
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          widget.items.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
