import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  List<String> availableTimeSlots = [];
  bool isLoadingSlots = false;

  final List<String> allTimeSlots = [
    "5:00 - 6:00pm",
    "6:00 - 7:00pm",
    "7:00 - 8:00pm"
  ];

  @override
  void initState() {
    super.initState();
    availableTimeSlots = List<String>.from(allTimeSlots);
  }

  Future<void> _fetchAvailableTimeSlots() async {
    if (startDate == null) return;

    setState(() {
      isLoadingSlots = true;
    });

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(startDate!);
      final response = await http.get(
        Uri.parse('$API_URL/facilities/reservations/${widget.facility['id']}?date=$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> reservations = json.decode(response.body);

        final reservedSlots = reservations
            .map((reservation) => reservation['timeSlot'] as String)
            .toSet();


        setState(() {
          availableTimeSlots = allTimeSlots
              .where((slot) => !reservedSlots.contains(slot))
              .toList();
          
          if (selectedTime != null && !availableTimeSlots.contains(selectedTime)) {
            selectedTime = null;
          }
          
          isLoadingSlots = false;
        });
      } else {
        setState(() {
          availableTimeSlots = List<String>.from(allTimeSlots);
          isLoadingSlots = false;
        });
      }
    } catch (e) {
      setState(() {
        availableTimeSlots = List<String>.from(allTimeSlots);
        isLoadingSlots = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching time slots: $e')),
      );
    }
  }

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dateSelector(
                  label: 'Date',
                  selectedDate: startDate,
                  onPicked: (picked) async {
                    setState(() {
                      startDate = picked;
                      selectedTime = null; 
                    });
                    await _fetchAvailableTimeSlots();
                  },
                ),
                const SizedBox(width: 6),
                isLoadingSlots
                    ? const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: CircularProgressIndicator(),
                      )
                    : TimeSlotSelector(
                        availableSlots: availableTimeSlots,
                        onSelected: (time) {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                      )
              ],
            ),
            const SizedBox(height: 24),

            ReservationSummaryCard(
              facility: widget.facility,
              date: startDate,
              time: selectedTime,
              onConfirm: () async {
                if (startDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid date')),
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

                if (selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select a valid time slot!')),
                  );
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse('$API_URL/facilities/reservations/'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      "user": widget.user,
                      "facility": widget.facility,
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
              if (picked != null) {
                await onPicked(picked);
              }
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