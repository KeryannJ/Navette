import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

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
            child: Marquee(
              
              text: value,
              style: const TextStyle(fontSize: 16),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 50.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
        );
      }).toList(),
    );
  }
}
