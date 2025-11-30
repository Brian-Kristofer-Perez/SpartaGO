import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparta_go/pages/facilities/facilities.dart';
import 'package:sparta_go/pages/equipment/equipment.dart';
import 'package:sparta_go/pages/reservation/reservation.dart';
import 'package:sparta_go/pages/profile/profile.dart';

class IncomingEventsPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const IncomingEventsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<IncomingEventsPage> createState() => _IncomingEventsPageState();
}

class _IncomingEventsPageState extends State<IncomingEventsPage> {
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      );
    });
  }

  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    
    final firstWeekday = firstDay.weekday % 7;
    
    List<DateTime?> days = [];
    
    for (int i = 0; i < firstWeekday; i++) {
      days.add(null);
    }
    
    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(_selectedMonth.year, _selectedMonth.month, day));
    }
    
    return days;
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => FacilitiesPage(user: widget.user),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => EquipmentPage(user: widget.user),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ReservationPage(user: widget.user),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(user: widget.user),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.fitness_center,
                    color: Colors.red,
                    size: 80,
                  ),
                ),
                
                const SizedBox(height: 20),

                const Text(
                  'Incoming Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _previousMonth,
                            icon: const Icon(Icons.chevron_left),
                            color: Colors.black,
                          ),
                          Text(
                            DateFormat('MMMM yyyy').format(_selectedMonth),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: _nextMonth,
                            icon: const Icon(Icons.chevron_right),
                            color: Colors.black,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                            .map((day) => SizedBox(
                                  width: 35,
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: day == 'Su' || day == 'Sa'
                                            ? Colors.red.shade400
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 10),

                      _buildCalendarGrid(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, 
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Equipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final days = _getDaysInMonth();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        
        if (day == null) {
          return const SizedBox.shrink();
        }

        final isToday = day.year == DateTime.now().year &&
            day.month == DateTime.now().month &&
            day.day == DateTime.now().day;

        final isSelected = _selectedDate != null &&
            day.day == _selectedDate!.day &&
            day.month == _selectedDate!.month &&
            day.year == _selectedDate!.year;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = day;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF8B1E1E)
                  : isToday
                      ? Colors.grey.shade200
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: const Color(0xFF8B1E1E), width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? const Color(0xFF8B1E1E)
                          : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}