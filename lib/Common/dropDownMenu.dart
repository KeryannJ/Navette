import 'package:flutter/material.dart';

class MyDropDownMenu extends StatefulWidget {
  final List<String> items;
  const MyDropDownMenu({super.key, required this.items, this.change});
  final Function? change;
  @override
  State<MyDropDownMenu> createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      dropdownValue = widget.items.first;
    } else {
      dropdownValue = 'Aucune zone disponible';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(fontSize: 18, color: Colors.black),
      underline: Container(
        height: 1,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          if (widget.change != null) {
            widget.change!(newValue);
          }
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            height: 40,
            width: 100,
            child: Text(value),
          ),
        );
      }).toList(),
    );
  }
}
