import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sagile_mobile/home/view/custom_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> events = {
    DateTime.utc(DateTime.now().year, DateTime.now().month, 1): [
      {
        "project": "Project 1",
        "task": "Task 1",
        "status": "Done",
      },
      {
        "project": "Project 1",
        "task": "Task 2",
        "status": "In-Progress",
      },
    ],
    DateTime.utc(DateTime.now().year, DateTime.now().month, 8): [
      {
        "project": "Project 2",
        "task": "Task 1",
        "status": "In-Progress",
      },
      {
        "project": "Project 3",
        "task": "Task 1",
        "status": "In-Progress",
      },
      {
        "project": "Project 3",
        "task": "Task 2",
        "status": "Planning",
      },
      {
        "project": "Project 3",
        "task": "Task 3",
        "status": "Planning",
      },
    ],
    DateTime.utc(DateTime.now().year, DateTime.now().month, 15): [
      {
        "project": "Project 4",
        "task": "Task 1",
        "status": "In-Progress",
      },
      {
        "project": "Project 4",
        "task": "Task 2",
        "status": "In-Progress",
      },
      {
        "project": "Project 5",
        "task": "Task 1",
        "status": "Done",
      },
    ],
    DateTime.utc(DateTime.now().year, DateTime.now().month, 22): [
      {
        "project": "Project 5",
        "task": "Task 2",
        "status": "Done",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SingleSection(
                      title: "Calendar",
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Divider(),
                        ),
                        TableCalendar(
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                            weekendStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          calendarStyle: CalendarStyle(
                            markerDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle),
                            markersMaxCount: 1,
                            weekendTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          firstDay: DateTime(DateTime.now().year - 1),
                          lastDay: DateTime(DateTime.now().year + 1),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          availableCalendarFormats: {
                            _calendarFormat: 'Month',
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(
                                () {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                },
                              );
                            }
                          },
                          eventLoader: (day) {
                            return events[day] ?? [];
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (events[_selectedDay] != null)
              Expanded(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SingleSection(
                          title: DateFormat('dd / MM').format(_selectedDay!),
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.0),
                              child: Divider(),
                            ),
                            ...events[_selectedDay]!
                                .map(
                                  (e) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 32),
                                        child: Text(
                                          e["project"],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: ListTile(
                                            title: Text(
                                              e["task"],
                                            ),
                                            trailing: Card(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  bottom: 4.0,
                                                ),
                                                child: Text(
                                                  e["status"],
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            dense: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
