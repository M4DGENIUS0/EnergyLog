import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GenericCircularAnnotatedGraph extends StatelessWidget {
  final int batteryLevel;
  final bool isCharging;

  const GenericCircularAnnotatedGraph({
    super.key,
    required this.batteryLevel,
    this.isCharging = false,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor;

    if (batteryLevel < 20) {
      progressColor = Colors.red;
    } else if (batteryLevel < 50) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return SizedBox(
      height: 220,
      width: 220,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 130,
            endAngle: 50,
            axisLineStyle: const AxisLineStyle(
              thickness: 15,
              color: Color(0xFFE0E0E0),
              cornerStyle: CornerStyle.bothCurve,
            ),

            pointers: [
              RangePointer(
                value: batteryLevel.toDouble(),
                width: 15,
                cornerStyle: CornerStyle.bothCurve,
                color: progressColor,
              ),
            ],

            annotations: [
              GaugeAnnotation(
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$batteryLevel%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Battery status',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    if (isCharging)
                      const Icon(Icons.bolt, size: 28)
                  ],
                ),
                positionFactor: 0.1,
              )
            ],
          ),
        ],
      ),
    );
  }
}
