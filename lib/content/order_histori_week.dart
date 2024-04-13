import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeci/content/controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPemesanan extends StatefulWidget {
  const CalendarPemesanan({super.key});

  @override
  State<CalendarPemesanan> createState() => _CalendarPemesananState();
}

class _CalendarPemesananState extends State<CalendarPemesanan> {
  @override
  void initState() {
    super.initState();

    final orderController = Get.find<OrderController>();

    // Mengisi selectedDateOrders saat halaman dimuat
    orderController.selectedDateOrders.value =
        orderController.getEventsForDay(orderController.selectedDate.value);
    print(orderController.selectedDate.value);

    // Menerapkan pembaruan ketika selectedDate berubah
    ever(orderController.selectedDate, (_) {
      orderController.selectedDateOrders.value =
          orderController.getEventsForDay(orderController.selectedDate.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GetBuilder<OrderController>(
      builder: (orderController) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: orderController.selectedDate.value,
            eventLoader: orderController.getEventsForDay,
            calendarFormat: CalendarFormat.month,
            locale: 'id_ID',
            availableCalendarFormats: const {
              CalendarFormat.month: 'Bulan',
              CalendarFormat.week: 'Per-Hari'
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                orderController.setSelectedDate(selectedDay, focusedDay);
                orderController.updateSelectedDateOrders(selectedDay);
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(orderController.selectedDate.value, day);
            },
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderController.selectedDateOrders.length,
              itemBuilder: (context, index) {
                final order = orderController.selectedDateOrders[index];
                return ListTile(
                  title: Text('Total Harga: ${order['totalPrice']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Menu: ${order['selectedMenu'].join(', ')}'),
                      Text('Minuman: ${order['selectedDrink'].join(', ')}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    )));
  }
}
