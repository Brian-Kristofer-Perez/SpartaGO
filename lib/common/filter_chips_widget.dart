import 'package:flutter/material.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;

  const FilterChipsWidget({
    Key? key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.selectedColor = const Color(0xFF8B1E1E),
    this.backgroundColor = Colors.white,
    this.selectedBorderColor,
    this.unselectedBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8.0,
        alignment: WrapAlignment.center,
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (selected) {
              onFilterSelected(filter);
            },
            backgroundColor: backgroundColor,
            selectedColor: selectedColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected
                  ? (selectedBorderColor ?? selectedColor!)
                  : (unselectedBorderColor ?? Colors.grey[300]!),
            ),
          );
        }).toList(),
      ),
    );
  }
}