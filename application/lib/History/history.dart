import 'package:application/History/historyElement.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [HistoryElement(), HistoryElement(), HistoryElement()],
    );
  }
}
