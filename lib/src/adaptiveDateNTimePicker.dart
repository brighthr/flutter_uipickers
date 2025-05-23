import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uipickers/uipickers.dart';

enum AdaptiveDatePickerType { adaptive, material, cupertino }

/// An adaptive widget for selecting from a date or time.
///
/// A popup lets the user select from a date or time. The widget
/// shows the currently selected value.
///
/// When used on iOS and when its type is set to adaptive or cupertino, it will show
/// a native iOS 14 style UIDatePicker in its popup.
///
/// When used on any other operating system or when the type is set to material, it
/// will use the default material dialog for selecting date or time.
///
/// The [onChanged] callback should update a state variable that defines the
/// picker's value. It should also call [State.setState] to rebuild the
/// picker with the new value.
///
class AdaptiveDateNTimePicker extends StatelessWidget {
  AdaptiveDateNTimePicker(
      {Key? key,
      this.mode = AdaptiveDateNTimePickerMode.date,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      required this.onChanged,
      this.type,
      this.textColor,
      this.backgroundColor,
      this.cornerRadius,
      this.child,
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

  /// Determines whether to use Date or Time selector popups.
  final AdaptiveDateNTimePickerMode mode;

  /// Called when the user selects a date/time.
  final void Function(DateTime)? onChanged;

  /// The color to use when painting the text.
  final Color? textColor;

  /// The color to fill in the background of the picker.
  final Color? backgroundColor;

  /// The corner radius.
  final double? cornerRadius;

  /// The font size of the selected item text.
  final double? fontSize;

  /// The date picker type to use. It is adaptive by default.
  /// When set to cupertino or adaptive it will instantinate a native platform picker when used with iOS.
  final AdaptiveDatePickerType? type;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var t = type ?? AdaptiveDatePickerType.adaptive;
    if (t != AdaptiveDatePickerType.material &&
        theme.platform == TargetPlatform.iOS) {
      return _buildCupertinoDateNTimePicker(context);
    }
    return _buildMaterialDateNTimePicker(context);
  }

  InkWell _buildCupertinoDateNTimePicker(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');
    return InkWell(
      onTap: () async {
        var pickedDate = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoDateNTimePicker(
              datePickerOnly: mode == AdaptiveDateNTimePickerMode.date,
              timePickerOnly: mode == AdaptiveDateNTimePickerMode.time,
              firstDate: firstDate,
              lastDate: lastDate,
              initialDate: initialDate,
              selectedColor: Theme.of(context).primaryColor,
              iconColor: Theme.of(context).primaryColor,
            );
          },
        );
        if (pickedDate != null) {
          _onChanged(pickedDate);
        }
      },
      child: child ??
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(cornerRadius ?? 8.0),
            ),
            child: Center(
              child: Text(
                mode == AdaptiveDateNTimePickerMode.time
                    ? '${timeFormat.format(initialDate)}'
                    : '${dateFormat.format(initialDate)}',
                style: TextStyle(
                  color: textColor ?? Colors.blue,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildMaterialDateNTimePicker(BuildContext context) {
    return MaterialDateNTimePicker(
      child: child,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onChanged: _onChanged,
      mode: mode,
      textColor: textColor,
      backgroundColor: backgroundColor,
      cornerRadius: cornerRadius,
      fontSize: fontSize,
    );
  }

  void _onChanged(DateTime date) {
    if (date != initialDate && onChanged != null) {
      onChanged!(date);
    }
  }
}
