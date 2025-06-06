import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uipickers/src/adaptiveDateNTimePickerMode.dart';
import 'package:uipickers/uipickers.dart';

/// A material widget for selecting a date or time.
///
/// A popup lets the user select a date or time. The widget
/// shows the currently selected value.
///
/// The [onChanged] callback should update a state variable that defines the
/// picker's value. It should also call [State.setState] to rebuild the
/// picker with the new value.
///
class MaterialDateNTimePicker extends StatefulWidget {
  MaterialDateNTimePicker(
      {Key? key,
      this.mode = AdaptiveDateNTimePickerMode.date,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      required this.onChanged,
      this.child,
      this.textColor,
      this.backgroundColor,
      this.cornerRadius,
      this.fontSize})
      : super(key: key);

  /// A child widget that displays the selected date or time.
  /// This widget is used to encapsulate the display logic for the picker.
  final Widget? child;

  /// The initially selected date. It must either fall between these dates, or be equal to one of them.
  final DateTime initialDate;

  /// The earliest allowable date.
  final DateTime firstDate;

  /// The latest allowable date.
  final DateTime lastDate;

  /// Called when the user selects a date/time.
  final void Function(DateTime)? onChanged;

  /// Determines whether to use Date or Time selector popups.
  final AdaptiveDateNTimePickerMode mode;

  /// The color to use when painting the text.
  final Color? textColor;

  /// The color to fill in the background of the picker.
  final Color? backgroundColor;

  /// The corner radius.
  final double? cornerRadius;

  /// The font size of the selected item text.
  final double? fontSize;

  @override
  State<MaterialDateNTimePicker> createState() =>
      _MaterialDateNTimePickerState();
}

class _MaterialDateNTimePickerState extends State<MaterialDateNTimePicker> {
  static final dateFormat = DateFormat('MMM dd, yyyy');
  static final timeFormat = DateFormat('hh:mm a');
  var date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    date = widget.initialDate;
    final textStyle = TextStyle(
        color: widget.textColor ?? Colors.black,
        fontSize: widget.fontSize ?? 17,
        fontWeight: FontWeight.w400);

    final formattedText = widget.mode == AdaptiveDateNTimePickerMode.date
        ? dateFormat.format(date)
        : timeFormat.format(date);

    return InkWell(
      onTap: () async {
        if (widget.mode == AdaptiveDateNTimePickerMode.time) {
          var t = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
          );
          if (t != null && widget.onChanged != null) {
            setState(() {
              date =
                  DateTime(date.year, date.month, date.day, t.hour, t.minute);
              widget.onChanged!(date);
            });
          }
        } else {
          var d = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          );
          if (d != null && widget.onChanged != null) {
            setState(() => date = d);
            widget.onChanged!(d);
          }
        }
      },
      child: widget.child ??
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(widget.cornerRadius ?? 8.0),
            ),
            child: Center(
              child: Text(
                formattedText,
                style: textStyle.copyWith(
                  color: widget.textColor ?? Colors.blue,
                  fontSize: widget.fontSize ?? 17,
                ),
              ),
            ),
          ),
    );
  }
}
