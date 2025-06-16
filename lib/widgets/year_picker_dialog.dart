import 'package:flutter/material.dart';

class YearPickerDialog extends StatelessWidget {
  final int selectedYear;
  final int startYear;
  final int endYear;
  final ValueChanged<int> onYearSelected;

  const YearPickerDialog({super.key, 
    required this.selectedYear,
    required this.startYear,
    required this.endYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Year'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300.0,
        child: ListView.builder(
          itemCount: endYear - startYear + 1,
          itemBuilder: (context, index) {
            final year = startYear + index;
            return ListTile(
              title: Text(year.toString()),
              selected: year == selectedYear,
              onTap: () {
                onYearSelected(year);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
