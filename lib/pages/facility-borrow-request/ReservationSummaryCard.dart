import 'package:flutter/material.dart';

class ReservationSummaryCard extends StatelessWidget {
  final Map<String, dynamic> facility;
  final DateTime? date;
  final String? time;
  final VoidCallback? onConfirm;

  const ReservationSummaryCard({
    Key? key,
    required this.facility,
    required this.date,
    required this.time,
    this.onConfirm,
  }) : super(key: key);

  static const _borderColor = Color(0xFFDFDFDF);
  static const _buttonColor = Color(0xFF8B1E1E);

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );
    final valueStyle = TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    );

    return Center(
      child: SizedBox(
        width: 320,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 1.6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reservation Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _buildInfoRow('Facility:', facility["name"], labelStyle, valueStyle),
              const SizedBox(height: 12),
              _buildInfoRow('Date:', date == null ? "No date selected" : "${date?.year}-${date?.month}-${date?.day}", labelStyle, valueStyle),
              const SizedBox(height: 12),
              _buildInfoRow('Time:', time ?? "No time selected", labelStyle, valueStyle),

              const SizedBox(height: 18),
              
              Center(
                child: SizedBox(
                  width: 300,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: const Text(
                      'Confirm Reservation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label,
      String value,
      TextStyle labelStyle,
      TextStyle valueStyle,
      ) {
    return Row(
      children: [
        // left label
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: labelStyle,
          ),
        ),

        // right value (right aligned)
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: valueStyle,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
