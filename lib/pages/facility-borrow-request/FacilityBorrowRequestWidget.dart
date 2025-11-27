import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Added for date formatting
import 'package:http/http.dart' as http;  // Added for HTTP requests
import 'dart:convert';  // Added for JSON encoding
import 'package:sparta_go/pages/facility-borrow-request/ReservationSummaryCard.dart';
import 'package:sparta_go/pages/facility-borrow-request/TimeSlotSelector.dart';
import '../../common/calendar/calendar.dart';
import 'package:sparta_go/constant/constant.dart';

class FacilityBorrowRequestWidget extends StatefulWidget {
  final Map<String, dynamic> facility;
  Map<String, dynamic> user;
  FacilityBorrowRequestWidget({super.key, required this.facility, required this.user});

  @override
  State<FacilityBorrowRequestWidget> createState() => _FacilityBorrowRequestWidgetState();
}

class _FacilityBorrowRequestWidgetState extends State<FacilityBorrowRequestWidget> {
  DateTime? startDate;
  String? selectedTime;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Reservation Request',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Date pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dateSelector(
                  label: 'Date',
                  selectedDate: startDate,
                  onPicked: (picked) => setState(() => startDate = picked),
                ),
                const SizedBox(width: 6),
                TimeSlotSelector(
                  availableSlots: List<String>.from(widget.facility['availableTimeSlots']),
                  onSelected: (time) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 24),

            // Submit button
            ReservationSummaryCard(
              facility: widget.facility,
              date: startDate,
              time: selectedTime,
              onConfirm: () async {
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

                if (startDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid date')),
                  );
                  return;
                }

                if (selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select a valid time slot!')),
                  );
                  return;
                }

                // Replace service call with HTTP POST request
                try {
                  final response = await http.post(
                    Uri.parse('$API_URL/facilities/reservations/'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      "userId": widget.user['id'].toString(),
                      "facilityId": widget.facility['id'].toString(),
                      "date": DateFormat('yyyy-MM-dd').format(startDate!),
                      "timeSlot": selectedTime!,
                    }),
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reservation made successfully')),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to make reservation: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            )
          ],
        ),
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

              setState(() {
                startDate = picked;
              });
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