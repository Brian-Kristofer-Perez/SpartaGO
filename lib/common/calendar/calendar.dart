import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CustomCalendar({super.key, required this.onDateSelected});

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDateSelected(selectedDay); // notify the parent of value change
          },
          enabledDayPredicate: (day) {
            final disabledDates = [
              DateTime.utc(2025, 10, 25),
              DateTime.utc(2025, 11, 1),
              DateTime.utc(2025, 11, 11)
            ];
            return !disabledDates.any((disabledDay) => isSameDay(disabledDay, day));
          },
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            leftChevronIcon: _chevronIcon(Icons.arrow_left),
            rightChevronIcon: _chevronIcon(Icons.arrow_right),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            weekdayStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              shape: BoxShape.circle,
            ),
            defaultTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
            weekendTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
            disabledTextStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      ),
    );
  }

  Widget _chevronIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Icon(icon, size: 24),
    );
  }
}


