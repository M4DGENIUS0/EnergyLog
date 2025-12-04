import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GenericCircularAnnotatedGraph extends StatefulWidget {
  final int batteryLevel;
   bool? isCharging;
   bool? showLabels;
   bool? showTicks;
   double? size;

   GenericCircularAnnotatedGraph({
    super.key,
    required this.batteryLevel,
    this.showLabels = false,
    this.size = 220,
     this.showTicks= false,
    this.isCharging = false,
  });

  @override
  State<GenericCircularAnnotatedGraph> createState() => _GenericCircularAnnotatedGraphState();
}

class _GenericCircularAnnotatedGraphState extends State<GenericCircularAnnotatedGraph> {
  @override
  Widget build(BuildContext context) {
    Color progressColor;

    if (widget.batteryLevel < 20) {
      progressColor = Colors.red;
    } else if (widget.batteryLevel < 50) {
      progressColor = Colors.orange;
    } else {
      progressColor = AppThemePreferences().appTheme.primaryColor!;
    }

    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: widget.showLabels!,
            showTicks: widget.showTicks!,
            startAngle: 130,
            endAngle: 50,
            showAxisLine: true,

            axisLineStyle: AxisLineStyle(
              thickness: 15,
              // color: APP_DARK_COLOR,
              color: AppThemePreferences().appTheme.circularGuageBackgroundColor,
              // thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothCurve,
            ),

            pointers: [
              RangePointer(
                value: widget.batteryLevel.toDouble(),
                width: 15,
                cornerStyle: CornerStyle.bothCurve,
                color: progressColor,
              ),
            ],

            annotations: [
              GaugeAnnotation(
                widget: Center(
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      GenericTextWidget(
                        '${widget.batteryLevel}%',
                        style: AppThemePreferences().appTheme.batteryStatusTextStyle,
                      ),
                      const SizedBox(height: 10),
                      GenericTextWidget(
                        'Battery status',
                        style: AppThemePreferences().appTheme.batteryStatusSubTextStyle,
                      ),
                      const SizedBox(height: 10),
                      if (widget.isCharging == true)
                        const Icon(Icons.bolt, size: 28),
                    ],
                  ),
                ),
                positionFactor: 0,
                angle: 0,
              ),

            ],
          ),
        ],
      ),
    );
  }
}
