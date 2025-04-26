import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Calendar/controller/calendar_controller.dart';

class CalendarScreen extends StatelessWidget {
  final CalendarController calendarController = Get.find(); // ✅ Corrected Controller

  CalendarScreen({super.key});

  @override





  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Plans"),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            /// **Calendar Widget**
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                /// **Customize each day cell**
                markerBuilder: (context, date, events) {
                  final hiredDabbawalas = calendarController.hiredDabbawalasList
                      .where((dabbawala) =>
                          date.isAtSameMomentAs(dabbawala.startDate) ||
                          date.isAtSameMomentAs(dabbawala.endDate))
                      .toList();

                  if (hiredDabbawalas.isNotEmpty) {
                    return Column(
                      children: [
                        ...hiredDabbawalas.map((dabbawala) {
                          return Text(
                            dabbawala.name,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          );
                        }),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hiredDabbawalas.any((d) => date.isAtSameMomentAs(d.startDate))
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),

            /// **List of Active Dabbawala Plans**
            Expanded(
              child: ListView.builder(
                itemCount: calendarController.hiredDabbawalasList.length,
                itemBuilder: (context, index) {
                  final dabbawala = calendarController.hiredDabbawalasList[index];
                  return ListTile(
                    title: Text(dabbawala.name),
                    subtitle: Text(
                      "Plan: ${dabbawala.startDate.toLocal()} - ${dabbawala.endDate.toLocal()}",
                    ),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
