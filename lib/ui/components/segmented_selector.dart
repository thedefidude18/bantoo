import 'package:flutter/cupertino.dart';

// SegmentSelector class with a generic type parameter T
class SegmentedSelector<T extends Object> extends StatelessWidget {
  const SegmentedSelector({
    super.key,
    required this.menuOptions,
    required this.selectedOption,
    required this.onValueChanged,
  });

  final Map<T, MapEntry<Icon, String>>
      menuOptions; // Change to Map<T, MapEntry<Icon, String>>
  final T selectedOption; // Change to T
  final ValueChanged<T?> onValueChanged; // Change to ValueChanged<T?>

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<T>(
      groupValue: selectedOption,
      children: {
        for (var option in menuOptions.entries)
          option.key: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              option.value.key, // Icon
              const SizedBox(width: 6),
              Text(option.value.value), // Text
            ],
          ),
      },
      onValueChanged: (value) {
        onValueChanged(value); // Call the provided callback
      },
    );
  }
}
