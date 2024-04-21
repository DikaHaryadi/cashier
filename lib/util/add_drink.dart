import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeci/content/controller.dart';
import 'package:makeci/content/currency_formatter.dart';

class AddDrinkPage extends StatelessWidget {
  final TextEditingController drinkNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final OrderController orderController = Get.find<OrderController>();

  AddDrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Menu Minuman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15.0),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(offset: Offset(2, 2), color: Colors.black)
              ]),
              child: TextField(
                key: const Key('drinkNameTextField'),
                controller: drinkNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15.0),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(offset: Offset(2, 2), color: Colors.black)
              ]),
              child: TextField(
                key: const Key('priceTextField'),
                controller: priceController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CustomCurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Harga (IDR)',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String drinkName = drinkNameController.text.trim();
                String priceText = priceController.text.trim();

                // Membersihkan input harga dari karakter non-angka
                String cleanedPrice =
                    priceText.replaceAll(RegExp(r'[^0-9]'), '');

                if (drinkName.isNotEmpty && cleanedPrice.isNotEmpty) {
                  int price = int.tryParse(cleanedPrice) ?? 0;
                  orderController.addDrinkPrice(drinkName, price);
                  drinkNameController.clear();
                  priceController.clear();
                } else {
                  // Tampilkan pesan kesalahan jika input kosong
                  Get.snackbar(
                    'Error',
                    'Mohon lengkapi semua kolom',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: AutoSizeText(
                'Tambahkan Menu',
                style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
