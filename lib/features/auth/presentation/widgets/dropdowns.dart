import 'package:flutter/material.dart';

class StudyYearDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?)? onChanged;
  const StudyYearDropdown({super.key, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Study Year'),
      value: value,
      onChanged: onChanged,
      items: [1, 2, 3, 4]
          .map((year) => DropdownMenuItem(value: year, child: Text(year.toString())))
          .toList(),
      validator: (val) => val == null ? 'Select study year' : null,
    );
  }
}

class DepartmentDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?)? onChanged;
  const DepartmentDropdown({super.key, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Department'),
      value: value,
      onChanged: onChanged,
      items: [1, 2]
          .map((dept) => DropdownMenuItem(value: dept, child: Text(dept.toString())))
          .toList(),
      validator: (val) => val == null ? 'Select department' : null,
    );
  }
}
