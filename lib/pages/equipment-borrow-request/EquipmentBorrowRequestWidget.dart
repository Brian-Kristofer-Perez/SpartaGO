import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:http/http.dart' as http;  
import 'dart:convert'; 
import '../../common/calendar/calendar.dart';
import 'package:sparta_go/constant/constant.dart';

class EquipmentBorrowRequestWidget extends StatefulWidget {
  Map<String, dynamic> equipment;
  Map<String, dynamic> user;

  EquipmentBorrowRequestWidget({super.key, required this.equipment, required this.user});

  @override
  State<EquipmentBorrowRequestWidget> createState() => _EquipmentBorrowRequestWidgetState();
}

class _EquipmentBorrowRequestWidgetState extends State<EquipmentBorrowRequestWidget> {
  int count = 0;
  DateTime? startDate;
  DateTime? endDate;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Borrow Request',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roundButton(
                  icon: Icons.remove,
                  onPressed: () {
                    if (count > 0) setState(() => count--);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$count',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                _roundButton(
                  icon: Icons.add,
                  onPressed: () {
                    if (count < widget.equipment['available']) {
                      setState(() { count++; });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _dateSelector(
                  label: 'Start Date',
                  selectedDate: startDate,
                  onPicked: (picked) => setState(() => startDate = picked),
                ),
                const SizedBox(width: 6),
                _dateSelector(
                  label: 'End Date',
                  selectedDate: endDate,
                  onPicked: (picked) => setState(() => endDate = picked),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B2C21),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (startDate == null || endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select both start and end dates.')),
                    );
                    return;
                  }

                  if (endDate!.isBefore(startDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('End date must be after start date.')),
                    );
                    return;
                  }

                  if (startDate!.isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day
                    )
                  )) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Start date must be at least today')),
                    );
                    return;
                  }

                  if (count == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter a valid amount to borrow.')),
                    );
                    return;
                  }

                  try {
                    final response = await http.post(
                      Uri.parse('$API_URL/equipment/reservations/'),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        "equipment": widget.equipment,
                        "user": widget.user,
                        "startDate": DateFormat('yyyy-MM-dd').format(startDate!),
                        "endDate": DateFormat('yyyy-MM-dd').format(endDate!),  
                        "count": count.toString(),  
                      }),
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reservation successful')),
                      );
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create reservation: ${response.statusCode}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text(
                  'Submit Borrow Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _dateSelector({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime?) onPicked,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SizedBox(
          width: 130,
          child: OutlinedButton.icon(
            onPressed: () async {
              final picked = await showCustomCalendarDialog(context);
              if (picked != null) onPicked(picked);
            },
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              selectedDate != null
                  ? "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"
                  : 'Select Date',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<DateTime?> showCustomCalendarDialog(BuildContext context) async {
  DateTime? selectedDate;

  await showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomCalendar(
                  onDateSelected: (date) {
                    selectedDate = date;
                    Navigator.pop(context, date);
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Color(0xFF991B1B))
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  return selectedDate;
}