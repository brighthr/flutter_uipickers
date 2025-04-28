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
      this.mode = AdaptiveDatenTimePickerMode.date,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      required this.onChanged,
      this.child,
      this.primaryColor,
      this.headerBackgroundColor,
      this.headerForegroundColor,
      this.textColor,
      this.backgroundColor,
      this.borderColor,
      this.borderWidth,
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
  final AdaptiveDatenTimePickerMode mode;

  /// The color that is used as the primary color of the picker.
  final Color? primaryColor;

  /// The color to use when painting the header of the picker.
  final Color? headerBackgroundColor;

  /// The color to use when painting the text in the header.
  final Color? headerForegroundColor;

  /// The color to use when painting the text.
  final Color? textColor;

  /// The color to fill in the background of the picker.
  final Color? backgroundColor;

  /// The color to use when painting the bordr of the picker.
  final Color? borderColor;

  /// The border width.
  final double? borderWidth;

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

    final formattedText = widget.mode == AdaptiveDatenTimePickerMode.date
        ? dateFormat.format(date)
        : timeFormat.format(date);

    return InkWell(
        onTap: () async {
          if (widget.mode == AdaptiveDatenTimePickerMode.time) {
            var t = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
              builder: (context, child) {
                var primaryLightColor = widget.primaryColor?.withOpacity(0.05);
                return Theme(
                  data: Theme.of(context).copyWith(
                    timePickerTheme: TimePickerThemeData(
                      confirmButtonStyle: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll<Color>(
                            widget.primaryColor ?? Colors.blue),
                      ),
                      cancelButtonStyle: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll<Color>(
                            widget.primaryColor ?? Colors.blue),
                      ),
                      backgroundColor: widget.backgroundColor ?? Colors.white,
                      dialHandColor: widget.primaryColor ?? Colors.blue,
                      dayPeriodColor: primaryLightColor,
                      entryModeIconColor: primaryLightColor,
                      dialBackgroundColor: primaryLightColor,
                      hourMinuteColor: primaryLightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.cornerRadius ?? 8.0),
                        ),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
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
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: widget.primaryColor ?? Colors.blue,
                    ),
                    datePickerTheme: DatePickerThemeData(
                      headerBackgroundColor: widget.headerBackgroundColor,
                      headerForegroundColor: widget.headerForegroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.cornerRadius ?? 8.0),
                        ),
                      ),
                      backgroundColor: widget.backgroundColor ?? Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (d != null && widget.onChanged != null) {
              setState(() => date = d);
              widget.onChanged!(d);
            }
          }
        },
        child: widget.child ??
            Ink(
              color: widget.backgroundColor ?? Color(0xFFEAEAEB),
              child: Center(child: Text(formattedText, style: textStyle)),
            ));
  }
}
