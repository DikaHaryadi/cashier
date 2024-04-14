import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:makeci/content/controller.dart';
import 'package:makeci/content/currency_formatter.dart';
import 'package:makeci/util/expandable_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.put(OrderController());

    return Scaffold(
      backgroundColor: const Color(0xFFfcf4f1),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: [
            AutoSizeText(
              'Daftar Menu',
              maxFontSize: 24,
              minFontSize: 20,
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5.0),
            AspectRatio(
              aspectRatio: 10 / 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'assets/banner.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  'Pesanan Hari ini',
                  maxFontSize: 24,
                  minFontSize: 20,
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                AutoSizeText(
                  ' - ${DateFormat('EEEE, MMM d', 'id_ID').format(DateTime.now())}',
                  maxFontSize: 16,
                  minFontSize: 14,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            AutoSizeText(
              'Makanan',
              maxFontSize: 16,
              minFontSize: 14,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: Colors.black),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.menuPrices.length,
              itemBuilder: (context, index) {
                final String menuName =
                    controller.menuPrices.keys.toList()[index];
                final int menuPrice =
                    controller.menuPrices.values.toList()[index];
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(-2, 2),
                              blurRadius: 1,
                              blurStyle: BlurStyle.normal)
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                menuName.toUpperCase(),
                                maxFontSize: 18,
                                minFontSize: 16,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              AutoSizeText(
                                'Rp. ${NumberFormat("#,##0.###", "id_ID").format(menuPrice)}',
                                maxFontSize: 14,
                                minFontSize: 12,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            controller.removeMenu(menuName);
                          },
                        ),
                        const SizedBox(width: 10.0),
                        Obx(
                          () => AutoSizeText(
                            '${controller.selectedMenu.where((item) => item == menuName).length}',
                            maxFontSize: 14,
                            minFontSize: 12,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            controller.addMenu(menuName);
                          },
                        ),
                      ],
                    ));
              },
            ),
            const SizedBox(height: 10.0),
            Obx(
              () => Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  color: controller.totalMenuPrice.value == 0
                      ? Colors.red
                      : Colors.green.shade400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        'Total Makanan',
                        maxFontSize: 14,
                        minFontSize: 12,
                        style: GoogleFonts.montserrat(
                          fontWeight: controller.totalMenuPrice.value == 0
                              ? FontWeight.w400
                              : FontWeight.bold,
                          color: controller.totalMenuPrice.value == 0
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      AutoSizeText(
                        'Rp. ${NumberFormat("#,##0.###", "id_ID").format(controller.totalMenuPrice.value)}',
                        maxFontSize: 14,
                        minFontSize: 12,
                        style: GoogleFonts.montserrat(
                          fontWeight: controller.totalMenuPrice.value == 0
                              ? FontWeight.w400
                              : FontWeight.bold,
                          color: controller.totalMenuPrice.value == 0
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 20.0),
            AutoSizeText(
              'Minuman',
              maxFontSize: 16,
              minFontSize: 14,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: Colors.black),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.drinkPrices.length,
              itemBuilder: (context, index) {
                final String drinkName =
                    controller.drinkPrices.keys.toList()[index];
                final int drinkPrice =
                    controller.drinkPrices.values.toList()[index];
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(-2, 2),
                              blurRadius: 1,
                              blurStyle: BlurStyle.normal)
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                drinkName.toUpperCase(),
                                maxFontSize: 18,
                                minFontSize: 16,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              AutoSizeText(
                                'Rp. ${NumberFormat("#,##0.###", "id_ID").format(drinkPrice)}',
                                maxFontSize: 14,
                                minFontSize: 12,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            controller.removeDrink(drinkName);
                          },
                        ),
                        const SizedBox(width: 10.0),
                        Obx(
                          () => AutoSizeText(
                            '${controller.selectedDrink.where((item) => item == drinkName).length}',
                            maxFontSize: 14,
                            minFontSize: 12,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            controller.addDrink(drinkName);
                          },
                        ),
                      ],
                    ));
              },
            ),
            const SizedBox(height: 10.0),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                color: controller.totalDrinkPrice.value == 0
                    ? Colors.red
                    : Colors.green.shade400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AutoSizeText(
                      'Total Minuman',
                      maxFontSize: 14,
                      minFontSize: 12,
                      style: GoogleFonts.montserrat(
                        fontWeight: controller.totalDrinkPrice.value == 0
                            ? FontWeight.w400
                            : FontWeight.bold,
                        color: controller.totalDrinkPrice.value == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    AutoSizeText(
                      'Rp. ${NumberFormat("#,##0.###", "id_ID").format(controller.totalDrinkPrice.value)}',
                      maxFontSize: 14,
                      minFontSize: 12,
                      style: GoogleFonts.montserrat(
                        fontWeight: controller.totalDrinkPrice.value == 0
                            ? FontWeight.w400
                            : FontWeight.bold,
                        color: controller.totalDrinkPrice.value == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside),
              ),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        'Total Pemesanan',
                        maxFontSize: 24,
                        minFontSize: 20,
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Obx(
                        () => Visibility(
                          visible: controller.totalPrice.value > 0,
                          child: GestureDetector(
                            onTap: () => controller.resetOrder(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 10.0,
                              ),
                              color: Colors.red,
                              margin: const EdgeInsets.only(right: 10.0),
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                'Hapus Pesanan',
                                maxFontSize: 14,
                                minFontSize: 12,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                                color: controller.totalPrice.value == 0
                                    ? Colors.red
                                    : Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black,
                                      blurStyle: BlurStyle.inner,
                                      offset: Offset(-2, 2))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Total Harga',
                                  maxFontSize: 14,
                                  minFontSize: 12,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                AutoSizeText(
                                  'Rp. ${NumberFormat("#,##0.###", "id_ID").format(controller.totalPrice.value)}',
                                  maxFontSize: 14,
                                  minFontSize: 12,
                                  style: GoogleFonts.aBeeZee(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38,
                                      shadows: [
                                        BoxShadow(
                                            offset: const Offset(2, 0),
                                            color:
                                                controller.totalPrice.value == 0
                                                    ? Colors.white
                                                    : Colors.green,
                                            blurRadius: .5,
                                            blurStyle: BlurStyle.outer)
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Obx(
                    () => Visibility(
                      visible: controller.totalPrice.value > 0,
                      child: ElevatedButton(
                        onPressed: () => controller.saveTransaction(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            elevation: 4,
                            shadowColor: Colors.grey.shade400),
                        child: Center(
                          child: AutoSizeText(
                            'CheckOut',
                            maxFontSize: 14,
                            minFontSize: 12,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Obx(
              () => Visibility(
                  visible: controller.totalPrice.value > 0,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15.0),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(2, 2), color: Colors.black)
                              ]),
                          child: TextFormField(
                            controller: controller.hKembalian,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CustomCurrencyInputFormatter(),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Masukan Uang Pelanggan',
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () => controller.uangKembali(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade400),
                            child: AutoSizeText(
                              'Hitung Kembalian',
                              minFontSize: 12,
                              maxFontSize: 14,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(height: 8.0),
                        AutoSizeText(
                          'Uang Kembalian : Rp.${NumberFormat("#,##0.###", "id_ID").format(controller.uangKembalian.value)}',
                          maxFontSize: 14,
                          minFontSize: 12,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  'Histori Pemesanan',
                  maxFontSize: 24,
                  minFontSize: 20,
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                AutoSizeText(
                  ' - ${DateFormat('EEEE, MMM d', 'id_ID').format(DateTime.now())}',
                  maxFontSize: 16,
                  minFontSize: 14,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Get.toNamed('/histori-perweek');
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText('Cek Histori Pemesanan Perminggu',
                    maxFontSize: 16,
                    minFontSize: 14,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            const SizedBox(height: 10.0),
            GetBuilder<OrderController>(
              builder: (controller) => FutureBuilder<List<dynamic>>(
                future: controller.getOrderHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<dynamic> orders = snapshot.data ?? [];
                    if (orders.isEmpty) {
                      return const Center(
                        child: Text('Belum ada riwayat pemesanan'),
                      );
                    } else {
                      orders = orders.reversed.toList();
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> order = orders[index];
                          String formattedDate =
                              DateFormat('EEEE, MMM d', 'id_ID')
                                  .format(DateTime.parse(order['date']));

                          // Menghitung jumlah pesanan dan total harga masing-masing menu
                          Map<String, int> menuCount = {};
                          Map<String, int> menuTotalPrice = {};
                          for (String menu in order['selectedMenu']) {
                            menuCount.update(menu, (value) => value + 1,
                                ifAbsent: () => 1);
                            int menuIndex = controller.menuPrices.keys
                                .toList()
                                .indexOf(menu);
                            if (menuIndex != -1) {
                              menuTotalPrice.update(
                                menu,
                                (value) =>
                                    (value) +
                                    (controller.menuPrices[menu] ?? 0),
                                ifAbsent: () =>
                                    (controller.menuPrices[menu] ?? 0),
                              );
                            }
                          }

                          // Menghitung jumlah pesanan dan total harga masing-masing minuman
                          Map<String, int> drinkCount = {};
                          Map<String, int> drinkTotalPrice = {};
                          for (String drink in order['selectedDrink']) {
                            drinkCount.update(drink, (value) => value + 1,
                                ifAbsent: () => 1);
                            int drinkIndex = controller.drinkPrices.keys
                                .toList()
                                .indexOf(drink);
                            if (drinkIndex != -1) {
                              drinkTotalPrice.update(
                                drink,
                                (value) =>
                                    (value) +
                                    (controller.drinkPrices[drink] ?? 0),
                                ifAbsent: () =>
                                    (controller.drinkPrices[drink] ?? 0),
                              );
                            }
                          }
                          return Dismissible(
                            key: Key(orders[index]['date']), // Gunakan key unik
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              // Panggil fungsi removeOrder untuk menghapus entri saat item digeser
                              controller.removeOrder(index);
                            },
                            background: Container(
                              color: Colors
                                  .red, // Warna latar belakang saat menggeser untuk menghapus
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            child: ExpandableContainer(
                              tanggal: formattedDate,
                              totalPrice:
                                  'Rp. ${NumberFormat("#,##0.###", "id_ID").format(order['totalPrice'])}',
                              totalMenu:
                                  'Rp. ${NumberFormat("#,##0.###", "id_ID").format(order['totalMenuPrice'])}',
                              totalDrink:
                                  'Rp. ${NumberFormat("#,##0.###", "id_ID").format(order['totalDrinkPrice'])}',
                              menu: order['selectedMenu'],
                              drink: order['selectedDrink'],
                              menuCount:
                                  menuCount, // Mengisi properti menuCount dengan nilai yang telah dihitung
                              drinkCount:
                                  drinkCount, // Mengisi properti drinkCount dengan nilai yang telah dihitung
                              menuTotalPrice:
                                  menuTotalPrice, // Mengisi properti menuTotalPrice dengan nilai yang telah dihitung
                              drinkTotalPrice:
                                  drinkTotalPrice, // Mengisi properti drinkTotalPrice dengan nilai yang telah dihitung
                              payMenu: order['selectedMenu']
                                  .map((menu) => controller.menuPrices[menu])
                                  .toList(),
                              payDrink: order['selectedDrink']
                                  .map((drink) => controller.drinkPrices[drink])
                                  .toList(),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
