/*
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';

class pastaModel extends StatelessWidget {
  final Map<String, double> dataMap;

  pastaModel({required this.dataMap});
  final List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 5,
        centerSpaceRadius: 70,
        sections: dataMap.entries.map((entry) {
          final colorIndex = dataMap.keys.toList().indexOf(entry.key);
          return PieChartSectionData(
            titlePositionPercentageOffset: 1.5,
            color: colorList[colorIndex % colorList.length],
            value: entry.value,
            title: entry.key + " : " + Ctanim.donusturMusteri(entry.value.toString()),
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          );
        }).toList(),
      ),
    );
  }

  // Rastgele renk üretmek için bu fonksiyonu kullanabilirsiniz.
  Color getRandomColor() {
    return Color.fromARGB(
      255,
      new DateTime.now().millisecond % 255,
      new DateTime.now().microsecond % 255,
      new DateTime.now().second % 255,
    );
  }
}
*/