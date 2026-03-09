import 'package:flutter/material.dart';

class CountdownWidget extends StatelessWidget {
  final int seconds;
  const CountdownWidget({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: seconds <= 10 ? Colors.red : Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "الوقت المتبقي: $seconds",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}