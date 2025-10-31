import 'package:flutter/material.dart';

class TimeSlotSelector extends StatefulWidget {

  final List<String> availableSlots;

  final ValueChanged<String>? onSelected;

  const TimeSlotSelector({
    Key? key,
    this.availableSlots = const [],
    this.onSelected,
  }) : super(key: key);

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {

  // fixed list of slots
  final List<String> _allSlots = const [
    '5:00 - 6:00pm',
    '6:00 - 7:00pm',
    '7:00 - 8:00pm',
  ];

  String? _selectedSlot;

  @override
  Widget build(BuildContext context) {

    return
      Column(
        children: [
          Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Container(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._allSlots.map((slot) {
                  final bool isAvailable = widget.availableSlots.contains(slot);
                  final bool isSelected = _selectedSlot == slot;

                  final Color bg = !isAvailable
                      ? Colors.grey.shade50
                      : (isSelected ? Colors.grey.shade100 : Colors.white);
                  final Color border = !isAvailable
                      ? Colors.grey.shade200
                      : (isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300);
                  final Color textColor = !isAvailable
                      ? Colors.grey.shade400
                      : (isSelected ? Theme.of(context).primaryColor : Colors.black87);

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: isAvailable
                        ? () => setState(() {
                          _selectedSlot = slot;
                          widget.onSelected?.call(slot);
                        })
                        : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: border, width: isSelected ? 1.4 : 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: !isAvailable
                                  ? Colors.grey.shade300
                                  : (isSelected ? Theme.of(context).primaryColor : Colors.black54),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                slot,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
          ),
        )
      ],
    );
  }
}
