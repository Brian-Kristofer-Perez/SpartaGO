import 'package:flutter/material.dart';

class TimeSlotSelector extends StatefulWidget {

  final List<String> takenSlots;

  final ValueChanged<String>? onSelected;

  const TimeSlotSelector({
    Key? key,
    this.takenSlots = const ['07:00 - 08:00 PM'],
    this.onSelected,
  }) : super(key: key);

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {

  // fixed list of slots
  final List<String> _allSlots = const [
    '05:00 - 06:00 PM',
    '06:00 - 07:00 PM',
    '07:00 - 08:00 PM',
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
                  final bool isTaken = widget.takenSlots.contains(slot);
                  final bool isSelected = _selectedSlot == slot;

                  final Color bg = isTaken
                      ? Colors.grey.shade50
                      : (isSelected ? Colors.grey.shade100 : Colors.white);
                  final Color border = isTaken
                      ? Colors.grey.shade200
                      : (isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300);
                  final Color textColor = isTaken
                      ? Colors.grey.shade400
                      : (isSelected ? Theme.of(context).primaryColor : Colors.black87);

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: isTaken ? null : () {

                        // update current state and pass to parent via callback
                        setState(() => _selectedSlot = slot);
                        widget.onSelected?.call(slot);

                      },
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
                              color: isTaken
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
