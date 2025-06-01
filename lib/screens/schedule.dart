import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JadwalScreen extends HookConsumerWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedDate = useState(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Date Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isToday(selectedDate.value)
                        ? 'Hari ini, ${_getFormattedDate(selectedDate.value)}'
                        : _getFormattedDate(selectedDate.value),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Calendar picker button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => _selectDate(context, selectedDate),
                      icon: Icon(
                        LucideIcons.calendar,
                        size: 20,
                        color: colorScheme.onSurface,
                      ),
                      tooltip: 'Pilih Tanggal',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Week Days Navigation
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: List.generate(_weekDays.length, (index) {
                final isSelectedDay = index == selectedDate.value.weekday - 1;
                final isToday =
                    index == DateTime.now().weekday - 1 &&
                    _isToday(selectedDate.value);

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Calculate the date for the selected weekday
                      final currentWeekday = selectedDate.value.weekday - 1;
                      final dayDifference = index - currentWeekday;
                      selectedDate.value = selectedDate.value.add(
                        Duration(days: dayDifference),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelectedDay
                                ? colorScheme.primary
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            isToday && !isSelectedDay
                                ? Border.all(
                                  color: colorScheme.primary,
                                  width: 1,
                                )
                                : null,
                      ),
                      child: Text(
                        _weekDays[index],
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isSelectedDay
                                  ? colorScheme.onPrimary
                                  : (isToday
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant),
                          fontWeight:
                              isSelectedDay || isToday
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 32),

          // Schedule List
          ...() {
            final scheduleForDate = _getScheduleForDate(selectedDate.value);
            if (scheduleForDate.isEmpty) {
              return [
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.calendar,
                            size: 28,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada jadwal',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nikmati hari bebasmu!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            }

            return [
              Column(
                children: List.generate(scheduleForDate.length, (index) {
                  final schedule = scheduleForDate[index];
                  final isBreak = schedule['subject'] == 'Istirahat';
                  final currentTime = DateTime.now();
                  final scheduleStart = _parseTime(
                    schedule['startTime'] as String,
                    selectedDate.value,
                  );
                  final scheduleEnd = _parseTime(
                    schedule['endTime'] as String,
                    selectedDate.value,
                  );
                  final isCurrentClass =
                      _isToday(selectedDate.value) &&
                      currentTime.isAfter(scheduleStart) &&
                      currentTime.isBefore(scheduleEnd);
                  final isUpcoming =
                      _isToday(selectedDate.value) &&
                      currentTime.isBefore(scheduleStart);

                  return Container(
                    margin: EdgeInsets.only(bottom: index == scheduleForDate.length - 1 ? 0 : 12),
                    child: _buildModernScheduleCard(
                      context,
                      schedule,
                      isBreak: isBreak,
                      isCurrentClass: isCurrentClass,
                      isUpcoming: isUpcoming,
                    ),
                  );
                }),
              ),
            ];
          }(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildModernScheduleCard(
    BuildContext context,
    Map<String, dynamic> schedule, {
    bool isBreak = false,
    bool isCurrentClass = false,
    bool isUpcoming = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scheduleColor = schedule['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCurrentClass 
            ? colorScheme.primaryContainer.withOpacity(0.3)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentClass 
              ? colorScheme.primary.withOpacity(0.3)
              : colorScheme.outlineVariant.withOpacity(0.2),
          width: isCurrentClass ? 1.5 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Time and Status Indicator
          Column(
            children: [
              // Time
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrentClass 
                      ? colorScheme.primary.withOpacity(0.1)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      schedule['startTime'] as String,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isCurrentClass 
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                    Text(
                      schedule['endTime'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Color indicator
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isCurrentClass ? colorScheme.primary : scheduleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        schedule['subject'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isBreak
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isCurrentClass)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Live',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      )
                    else if (isUpcoming)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Next',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),

                if (!isBreak) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          LucideIcons.user,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        schedule['teacher'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          LucideIcons.mapPin,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        schedule['room'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    ValueNotifier<DateTime> selectedDate,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MinimalDatePicker(
        initialDate: selectedDate.value,
        onDateSelected: (date) {
          selectedDate.value = date;
          Navigator.pop(context);
        },
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  DateTime _parseTime(String timeString, DateTime date) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String _getFormattedDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  List<Map<String, dynamic>> _getScheduleForDate(DateTime date) {
    // Simulate different schedules for different days
    final weekday = date.weekday;

    switch (weekday) {
      case 1: // Monday
        return _todaySchedule;
      case 2: // Tuesday
        return _tuesdaySchedule;
      case 3: // Wednesday
        return _wednesdaySchedule;
      case 4: // Thursday
        return _thursdaySchedule;
      case 5: // Friday
        return _fridaySchedule;
      case 6: // Saturday
        return _saturdaySchedule;
      case 7: // Sunday
        return []; // No classes on Sunday
      default:
        return [];
    }
  }
}

final _weekDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

final _todaySchedule = [
  {
    'subject': 'Matematika Lanjut',
    'teacher': 'Pak Budi',
    'room': 'Ruang 101',
    'startTime': '08:00',
    'endTime': '09:30',
    'color': Colors.blue,
  },
  {
    'subject': 'Fisika Dasar',
    'teacher': 'Bu Sari',
    'room': 'Lab Fisika',
    'startTime': '10:00',
    'endTime': '11:30',
    'color': Colors.green,
  },
  {
    'subject': 'Istirahat',
    'teacher': '',
    'room': '',
    'startTime': '12:00',
    'endTime': '13:00',
    'color': Colors.grey,
  },
  {
    'subject': 'Kimia Organik',
    'teacher': 'Pak Joko',
    'room': 'Lab Kimia',
    'startTime': '13:00',
    'endTime': '14:30',
    'color': Colors.purple,
  },
  {
    'subject': 'Bahasa Inggris',
    'teacher': 'Miss Anna',
    'room': 'Ruang 205',
    'startTime': '15:00',
    'endTime': '16:30',
    'color': Colors.orange,
  },
];

final _tuesdaySchedule = [
  {
    'subject': 'Bahasa Indonesia',
    'teacher': 'Bu Maya',
    'room': 'Ruang 102',
    'startTime': '08:00',
    'endTime': '09:30',
    'color': Colors.red,
  },
  {
    'subject': 'Biologi',
    'teacher': 'Pak Andi',
    'room': 'Lab Biologi',
    'startTime': '10:00',
    'endTime': '11:30',
    'color': Colors.teal,
  },
  {
    'subject': 'Istirahat',
    'teacher': '',
    'room': '',
    'startTime': '12:00',
    'endTime': '13:00',
    'color': Colors.grey,
  },
  {
    'subject': 'Sejarah',
    'teacher': 'Bu Rina',
    'room': 'Ruang 103',
    'startTime': '13:00',
    'endTime': '14:30',
    'color': Colors.brown,
  },
];

final _wednesdaySchedule = [
  {
    'subject': 'Olahraga',
    'teacher': 'Pak Herman',
    'room': 'Lapangan',
    'startTime': '08:00',
    'endTime': '09:30',
    'color': Colors.green,
  },
  {
    'subject': 'Seni Budaya',
    'teacher': 'Bu Dewi',
    'room': 'Ruang Seni',
    'startTime': '10:00',
    'endTime': '11:30',
    'color': Colors.pink,
  },
];

final _thursdaySchedule = [
  {
    'subject': 'Ekonomi',
    'teacher': 'Pak Bambang',
    'room': 'Ruang 104',
    'startTime': '08:00',
    'endTime': '09:30',
    'color': Colors.indigo,
  },
  {
    'subject': 'Geografi',
    'teacher': 'Bu Linda',
    'room': 'Ruang 105',
    'startTime': '10:00',
    'endTime': '11:30',
    'color': Colors.cyan,
  },
  {
    'subject': 'Istirahat',
    'teacher': '',
    'room': '',
    'startTime': '12:00',
    'endTime': '13:00',
    'color': Colors.grey,
  },
];

final _fridaySchedule = [
  {
    'subject': 'Agama',
    'teacher': 'Pak Usman',
    'room': 'Ruang 106',
    'startTime': '08:00',
    'endTime': '09:30',
    'color': Colors.amber,
  },
  {
    'subject': 'PKN',
    'teacher': 'Bu Sinta',
    'room': 'Ruang 107',
    'startTime': '10:00',
    'endTime': '11:30',
    'color': Colors.deepOrange,
  },
];

final _saturdaySchedule = [
  {
    'subject': 'Ekstrakurikuler',
    'teacher': 'Berbagai Guru',
    'room': 'Berbagai Ruang',
    'startTime': '08:00',
    'endTime': '11:00',
    'color': Colors.purple,
  },
];

class _MinimalDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const _MinimalDatePicker({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<_MinimalDatePicker> createState() => _MinimalDatePickerState();
}

class _MinimalDatePickerState extends State<_MinimalDatePicker> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous month
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                    });
                  },
                  icon: Icon(
                    LucideIcons.chevronLeft,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                
                // Month and year
                Text(
                  _getMonthYearText(_currentMonth),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                
                // Next month
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                    });
                  },
                  icon: Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar Grid
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Weekday headers
                Row(
                  children: ['S', 'S', 'R', 'K', 'J', 'S', 'M'].map((day) {
                    return Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 8),
                
                // Calendar days
                ..._buildCalendarWeeks(),
              ],
            ),
          ),
          
          // Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onDateSelected(_selectedDate),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Pilih',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarWeeks() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final today = DateTime.now();
    
    // Get first day of month and calculate padding
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    // Fix: Correct calculation for first day of calendar grid
    final startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday));
    
    List<Widget> weeks = [];
    DateTime currentDate = startDate;
    
    for (int week = 0; week < 6; week++) {
      List<Widget> days = [];
      
      for (int day = 0; day < 7; day++) {
        final isCurrentMonth = currentDate.month == _currentMonth.month;
        final isToday = currentDate.year == today.year &&
                       currentDate.month == today.month &&
                       currentDate.day == today.day;
        final isSelected = currentDate.year == _selectedDate.year &&
                          currentDate.month == _selectedDate.month &&
                          currentDate.day == _selectedDate.day;
        
        // Capture the date for the tap handler
        final dateToSelect = DateTime(currentDate.year, currentDate.month, currentDate.day);
        
        days.add(
          Expanded(
            child: GestureDetector(
              onTap: isCurrentMonth ? () {
                setState(() {
                  _selectedDate = dateToSelect;
                });
              } : null,
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : (isToday && isCurrentMonth
                          ? colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                  border: isToday && !isSelected && isCurrentMonth
                      ? Border.all(color: colorScheme.primary, width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${currentDate.day}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (isCurrentMonth
                              ? (isToday
                                  ? colorScheme.primary
                                  : colorScheme.onSurface)
                              : colorScheme.onSurfaceVariant.withOpacity(0.4)),
                      fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        
        currentDate = currentDate.add(const Duration(days: 1));
      }
      
      weeks.add(Row(children: days));
      
      // Stop if we've passed the current month and have at least 4 weeks
      if (week >= 3 && currentDate.month != _currentMonth.month) {
        break;
      }
    }
    
    return weeks;
  }

  String _getMonthYearText(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
