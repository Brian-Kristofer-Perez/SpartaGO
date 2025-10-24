import 'package:flutter/material.dart';
import 'package:sparta_go/pages/facility-borrow-request/ReservationSummaryCard.dart';
import 'package:sparta_go/pages/facility-borrow-request/TimeSlotSelector.dart';
import '../../common/calendar/calendar.dart';

class FacilityBorrowRequestWidget extends StatefulWidget {

  final Map<String,dynamic> facility;
  const FacilityBorrowRequestWidget({super.key, required this.facility});

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
                SizedBox(width: 6),

                TimeSlotSelector(
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
              onConfirm: () {
                print("Hello world");
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
                  ? "${selectedDate.year}-${selectedDate.month}-${selectedDate
                  .day}"
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
