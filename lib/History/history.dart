import 'package:application/Common/dropDownMenu.dart';
import 'package:application/History/historyElement.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool isReturn = false;
  void onChange() {
    setState(() {
      isReturn = !isReturn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: MyDropDownMenu(
        items: const ['Aller', 'Retour'],
        change: onChange,
      )),
      body: ListView(
        children: const [HistoryElement(), HistoryElement(), HistoryElement()],
      ),
    );
  }
}
