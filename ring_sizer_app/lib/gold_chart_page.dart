import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // L'outil qu'on vient d'installer

class GoldChartPage extends StatelessWidget {
  const GoldChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Historique Or (30 jours)"),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Évolution du 24k (MAD/g)",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // --- LE GRAPHIQUE ---
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.white10, strokeWidth: 1);
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (val, meta) {
                      return Text(val.toInt().toString(), style: const TextStyle(color: Colors.white70, fontSize: 10));
                    })),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // On cache les dates pour simplifier
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.white24)),
                  minX: 0,
                  maxX: 6,
                  minY: 800, // Ajuste selon tes prix (ex: entre 800 et 900 dh)
                  maxY: 900,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        // Fausses données pour la démo (Jour, Prix)
                        FlSpot(0, 820),
                        FlSpot(1, 835),
                        FlSpot(2, 825),
                        FlSpot(3, 850), // Pic
                        FlSpot(4, 840),
                        FlSpot(5, 860),
                        FlSpot(6, 850.5), // Aujourd'hui
                      ],
                      isCurved: true,
                      color: Colors.amber,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: true, color: Colors.amber.withOpacity(0.3)),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
              child: const Text(
                "Tendance : HAUSSIÈRE 🚀\nLe prix a augmenté de 3.5% cette semaine.",
                style: TextStyle(color: Colors.greenAccent),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}