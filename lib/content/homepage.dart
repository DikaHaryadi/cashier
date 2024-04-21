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
            Text(controller.box.read('drink_aqua').toString()),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  'Makanan',
                  maxFontSize: 16,
                  minFontSize: 14,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
                InkWell(
                  onTap: () => Get.toNamed('/add-menu'),
                  child: const Icon(
                    Icons.add_box_rounded,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Obx(
              () => controller.menuPrices.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 20 / 5,
                          child: Image.asset(
                            'assets/empty.jpg',
                          ),
                        ),
                        AutoSizeText(
                          'Tidak ada menu makanan',
                          maxFontSize: 20,
                          minFontSize: 18,
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        )
                      ],
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.menuPrices.length,
                      itemBuilder: (context, index) {
                        final menuName =
                            controller.menuPrices.keys.elementAt(index);
                        final menuPrice =
                            controller.menuPrices.values.elementAt(index);
                        return Obx(() => Dismissible(
                              key: Key(menuName),
                              onDismissed: (direction) {
                                controller.deleteMenu(menuName);
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 8.0),
                                margin: const EdgeInsets.only(bottom: 10.0),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(-2, 2),
                                      blurRadius: 1,
                                      blurStyle: BlurStyle.normal,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    AutoSizeText(
                                      '${controller.selectedMenu.where((item) => item == menuName).length}',
                                      maxFontSize: 14,
                                      minFontSize: 12,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
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
                                ),
                              ),
                            ));
                      },
                    ),
            ),
            const SizedBox(height: 10.0),
            controller.menuPrices.values.isEmpty
                ? const SizedBox.shrink()
                : Obx(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  'Minuman',
                  maxFontSize: 16,
                  minFontSize: 14,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
                InkWell(
                    onTap: () => Get.toNamed('/add-drink'),
                    child: const Icon(
                      Icons.add_box,
                      color: Colors.blue,
                    ))
              ],
            ),
            const SizedBox(height: 10.0),
            Obx(
              () => controller.drinkPrices.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 20 / 5,
                          child: Image.asset(
                            'assets/empty.jpg',
                          ),
                        ),
                        AutoSizeText(
                          'Tidak ada menu minuman',
                          maxFontSize: 20,
                          minFontSize: 18,
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.drinkPrices.length,
                      itemBuilder: (context, index) {
                        final drinkName =
                            controller.drinkPrices.keys.elementAt(index);
                        final drinkPrice =
                            controller.drinkPrices.values.elementAt(index);
                        return Obx(() => Dismissible(
                              key: Key(drinkName),
                              onDismissed: (direction) {
                                controller.deleteDrink(drinkName);
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 8.0),
                                margin: const EdgeInsets.only(bottom: 10.0),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(-2, 2),
                                      blurRadius: 1,
                                      blurStyle: BlurStyle.normal,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            drinkName.toUpperCase(),
                                            maxFontSize: 18,
                                            minFontSize: 16,
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          AutoSizeText(
                                            'Rp. ${NumberFormat("#,##0.###", "id_ID").format(drinkPrice)}',
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
                                        controller.removeDrink(drinkName);
                                      },
                                    ),
                                    const SizedBox(width: 10.0),
                                    AutoSizeText(
                                      '${controller.selectedDrink.where((item) => item == drinkName).length}',
                                      maxFontSize: 14,
                                      minFontSize: 12,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
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
                                ),
                              ),
                            ));
                      },
                    ),
            ),
            const SizedBox(height: 10.0),
            controller.drinkPrices.values.isEmpty
                ? const SizedBox.shrink()
                : Obx(
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
            controller.drinkPrices.values.isEmpty &&
                    controller.menuPrices.values.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  color: controller.totalPrice
                                                              .value ==
                                                          0
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
            const SizedBox(height: 10.0),
            GetBuilder<OrderController>(
              builder: (controller) {
                // Variabel untuk menyimpan total harga masing-masing menu dan minuman
                Map<String, int> menuTotalPrice = {};
                Map<String, int> drinkTotalPrice = {};

                return FutureBuilder<List<dynamic>>(
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
                        return Center(
                          child: AutoSizeText(
                            'Belum ada riwayat pemesanan',
                            minFontSize: 14,
                            maxFontSize: 15,
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      } else {
                        orders = orders.reversed.toList();

                        for (var order in orders) {
                          // Menghitung total harga masing-masing menu
                          order['selectedMenu'].forEach((menu) {
                            var menuPrice = controller.menuPrices[menu];
                            if (menuPrice is int) {
                              menuTotalPrice[menu] =
                                  (menuTotalPrice[menu] ?? 0) + menuPrice;
                            } else if (menuPrice is num) {
                              menuTotalPrice[menu] =
                                  (menuTotalPrice[menu] ?? 0) +
                                      menuPrice.toInt();
                            }
                          });

                          // Menghitung total harga masing-masing minuman
                          order['selectedDrink'].forEach((drink) {
                            var drinkPrice = controller.drinkPrices[drink];
                            if (drinkPrice is int) {
                              drinkTotalPrice[drink] =
                                  (drinkTotalPrice[drink] ?? 0) + drinkPrice;
                            } else if (drinkPrice is num) {
                              drinkTotalPrice[drink] =
                                  (drinkTotalPrice[drink] ?? 0) +
                                      drinkPrice.toInt();
                            }
                          });
                        }

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
                            order['selectedMenu'].forEach((menu) {
                              menuCount[menu] = (menuCount[menu] ?? 0) + 1;
                            });

                            // Menghitung jumlah pesanan dan total harga masing-masing minuman
                            Map<String, int> drinkCount = {};
                            order['selectedDrink'].forEach((drink) {
                              drinkCount[drink] = (drinkCount[drink] ?? 0) + 1;
                            });

                            return Dismissible(
                              key: Key(orders[index]['date']),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                controller.removeOrder(index);
                                controller.updateTotalRevenue();
                              },
                              background: Container(
                                color: Colors.red,
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
                                menuCount: menuCount,
                                drinkCount: drinkCount,
                                menuTotalPrice: menuTotalPrice,
                                drinkTotalPrice: drinkTotalPrice,
                                payMenu: order['selectedMenu']
                                    .map((menu) => controller.menuPrices[menu])
                                    .toList(),
                                payDrink: order['selectedDrink']
                                    .map((drink) =>
                                        controller.drinkPrices[drink])
                                    .toList(),
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                );
              },
            ),
            TextButton(
              onPressed: () {
                Get.toNamed('/histori-perweek');
              },
              child: const Align(
                alignment: Alignment.center,
                child: AutoSizeText('Cek Histori Pemesanan Perminggu',
                    maxFontSize: 16,
                    minFontSize: 14,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
