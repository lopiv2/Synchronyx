import 'package:flutter/material.dart';

class NoticeHoursSlider extends StatefulWidget {
  final double databaseValue;
  final String text;
  final ValueChanged<int> onChanged;
  const NoticeHoursSlider({super.key, required this.databaseValue, required this.text, required this.onChanged});

  @override
  State<NoticeHoursSlider> createState() => _NoticeHoursSliderState();
}

class _NoticeHoursSliderState extends State<NoticeHoursSlider> {
  double _sliderValue = 0.0;
  final List<double> divisions = [12, 24, 36, 48, 60, 72];

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.databaseValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Slider(
          value: _sliderValue,
          divisions: divisions.length - 1,
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
              _sliderValue = _getNearestDivision(value);
              widget.onChanged(value.round());
            });
          },
          min: 12,
          max: 72,
        ),
        Text('${widget.text}: ${_sliderValue.round()}'),
      ],
    );
  }

  double _getNearestDivision(double value) {
    // Find the nearest value in the list of divisions.
    double minDiff = double.maxFinite;
    double closestDivision = divisions[0];
    for (var division in divisions) {
      double diff = (value - division).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestDivision = division;
      }
    }
    return closestDivision;
  }
}
