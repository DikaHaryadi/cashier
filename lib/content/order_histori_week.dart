import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:makeci/content/controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPemesanan extends StatefulWidget {
  const CalendarPemesanan({super.key});

  @override
  State<CalendarPemesanan> createState() => _CalendarPemesananState();
}

class _CalendarPemesananState extends State<CalendarPemesanan> {
  final box = GetStorage();
  // DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();

    final orderController = Get.find<OrderController>();

    // Mengisi selectedDateOrders saat halaman dimuat
    orderController.selectedDateOrders.value =
        orderController.getEventsForDay(orderController.selectedDate.value);

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
      builder: (orderController) => ListView(
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
          _pendapatan(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.selectedDateOrders.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> order =
                  orderController.selectedDateOrders[index];
              int nomer = index + 1;
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                margin: const EdgeInsets.only(
                    bottom: 10.0, left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(-2, 2),
                          blurRadius: .5,
                          blurStyle: BlurStyle.inner,
                          color: Colors.grey,
                          spreadRadius: 1)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          order['totalMenuPrice'] == 0
                              ? 'Tidak Ada Pesanan Makanan'
                              : 'Total Makanan : Rp.${NumberFormat("#,##0.###", "id_ID").format(order['totalMenuPrice'])}',
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.aBeeZee(
                              color: order['totalMenuPrice'] == 0
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: order['totalMenuPrice'] == 0
                                  ? FontWeight.bold
                                  : FontWeight.w400),
                        ),
                        AutoSizeText(
                          order['totalDrinkPrice'] == 0
                              ? 'Tidak Ada Pesanan Minuman'
                              : 'Total Minuman : Rp.${NumberFormat("#,##0.###", "id_ID").format(order['totalDrinkPrice'])}',
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.aBeeZee(
                              color: order['totalDrinkPrice'] == 0
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: order['totalDrinkPrice'] == 0
                                  ? FontWeight.bold
                                  : FontWeight.w400),
                        ),
                        AutoSizeText(
                          'Total Pemesanan : Rp.${NumberFormat("#,##0.###", "id_ID").format(order['totalPrice'])}',
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.aBeeZee(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      minRadius: 10,
                      maxRadius: 15,
                      child: AutoSizeText(
                        '$nomer',
                        minFontSize: 14,
                        maxFontSize: 16,
                        style: GoogleFonts.aBeeZee(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    )));
  }

  _pendapatan() {
    final orderController = Get.find<OrderController>();
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(orderController.selectedDate.value);

    final totalPriceHari = box.read('totalPriceHari_$formattedDate');

    if (totalPriceHari != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
        child: AutoSizeText(
          'Total Pendapatan Hari Ini\nRp. ${NumberFormat("#,##0.###", "id_ID").format(totalPriceHari)}',
          maxFontSize: 18,
          minFontSize: 16,
          style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: AutoSizeText(
          'Belum ada transaksi',
          maxFontSize: 18,
          minFontSize: 16,
          style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
  }
}
