import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  // Menggunakan Map untuk menyimpan harga menu dan minuman
  final RxMap menuPrices = {}.obs;

  final RxMap drinkPrices = {}.obs;

  // Variabel untuk menyimpan pilihan pengguna
  RxList<String> selectedMenu = <String>[].obs;
  RxList<String> selectedDrink = <String>[].obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<Map<String, dynamic>> selectedDateOrders =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> orderHistory = <Map<String, dynamic>>[].obs;
  // Variabel untuk menyimpan total harga harian
  RxInt totalPriceHari = 0.obs;

  // Variabel untuk menyimpan total harga menu dan minuman
  RxInt totalMenuPrice = 0.obs;
  RxInt totalDrinkPrice = 0.obs;

  // Variabel untuk menyimpan total harga keseluruhan
  RxInt totalPrice = 0.obs;
  RxInt uangKembalian = 0.obs;

  final box = GetStorage();
  final TextEditingController hKembalian = TextEditingController();

  void addMenuPrice(String menuName, int price) {
    box.write('menu_$menuName', price);
    Get.snackbar(
      'Berhasil',
      'Menambahkan Minuman Baru Berhasil!',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
    getMenuPricesFromStorage(); // Panggil fungsi untuk mengambil data dari storage
    // Tampilkan snackbar atau pesan lainnya
  }

  void addDrinkPrice(String drinkName, int price) {
    // Menyimpan data minuman dengan kunci yang sesuai
    box.write('drink_$drinkName', price);
    Get.snackbar(
      'Berhasil',
      'Menambahkan Minuman Baru Berhasil!',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
    getDrinkPricesFromStorage(); // Memperbarui antarmuka pengguna setelah menambahkan minuman baru
  }

  // Fungsi untuk mengambil data menu dari GetStorage
  void getMenuPricesFromStorage() {
    Map<String, int> menuPricesFromStorage = {};
    box.getKeys().forEach((key) {
      if (key.startsWith('menu_')) {
        String menuName = key.substring(5);
        print(key.toString());
        int price = box.read(key);
        menuPricesFromStorage[menuName] = price;
      }
    });
    menuPrices.assignAll(menuPricesFromStorage); // Update menuPrices
  }

  void getDrinkPricesFromStorage() {
    Map<String, int> drinkPricesFromStorage = {};
    box.getKeys().forEach((key) {
      if (key.startsWith('drink_')) {
        // Mengambil nama minuman dari kunci
        String drinkName = key.substring(6);
        // Mengambil harga dari data yang disimpan
        int price = box.read(key);
        drinkPricesFromStorage[drinkName] = price;
      }
    });
    drinkPrices.assignAll(drinkPricesFromStorage); //Update drinkPrices
  }

  // Fungsi untuk menghapus harga menu
  void deleteMenu(String menuName) {
    box.remove('menu_$menuName');
    getMenuPricesFromStorage(); // Panggil fungsi untuk mengambil data dari storage
    // Tampilkan snackbar atau pesan lainnya
  }

  void deleteDrink(String drinkMenu) {
    box.remove('drink_$drinkMenu');
    getDrinkPricesFromStorage();
  }

  void toggleDrink(String item) {
    if (selectedDrink.contains(item)) {
      selectedDrink.remove(item);
      totalDrinkPrice -= drinkPrices[item] ?? 0;
    } else {
      selectedDrink.add(item);
      totalDrinkPrice += drinkPrices[item] ?? 0;
    }
    updateTotalPrice(); // Panggil updateTotalPrice setiap kali ada perubahan
  }

  void removeDrink(String drink) {
    if (selectedDrink.contains(drink)) {
      selectedDrink.remove(drink);
      if (drinkPrices.containsKey(drink)) {
        var drinkPrice = drinkPrices[drink];
        if (drinkPrice is int) {
          totalDrinkPrice.value -= drinkPrice;
          calculateTotalPrice();
        } else if (drinkPrice is num) {
          totalDrinkPrice.value -= drinkPrice.toInt();
          calculateTotalPrice();
        }
      }
    }
  }

  void addDrink(String drink) {
    selectedDrink.add(drink);
    if (drinkPrices.containsKey(drink)) {
      var drinkPrice = drinkPrices[drink];
      if (drinkPrice is int) {
        totalDrinkPrice.value += drinkPrice;
        calculateTotalPrice();
      } else if (drinkPrice is num) {
        totalDrinkPrice.value += drinkPrice.toInt();
        calculateTotalPrice();
      }
    }
  }

// Panggil updateTotalPrice saat ada perubahan pada pilihan menu atau minuman
  void toggleMenu(String item) {
    if (selectedMenu.contains(item)) {
      selectedMenu.remove(item);
      totalMenuPrice -= menuPrices[item] ?? 0;
    } else {
      selectedMenu.add(item);
      totalMenuPrice += menuPrices[item] ?? 0;
    }
    updateTotalPrice(); // Panggil updateTotalPrice setiap kali ada perubahan
  }

  void removeMenu(String menu) {
    if (selectedMenu.contains(menu)) {
      selectedMenu.remove(menu);
      if (menuPrices.containsKey(menu)) {
        var menuPrice = menuPrices[menu];
        if (menuPrice is int) {
          totalMenuPrice.value -= menuPrice;
          calculateTotalPrice();
        } else if (menuPrice is num) {
          totalMenuPrice.value -= menuPrice.toInt();
          calculateTotalPrice();
        }
      }
    }
  }

  void addMenu(String menu) {
    selectedMenu.add(menu);
    if (menuPrices.containsKey(menu)) {
      var menuPrice = menuPrices[menu];
      if (menuPrice is int) {
        totalMenuPrice.value += menuPrice;
        calculateTotalPrice();
      } else if (menuPrice is num) {
        totalMenuPrice.value += menuPrice.toInt();
        calculateTotalPrice();
      }
    }
  }

  // Panggil calculateTotalPrice saat ada perubahan pada pilihan menu atau minuman
  void updateTotalPrice() {
    // Panggil metode untuk menghitung total harga
    calculateTotalPrice();

    // Simpan total harga harian jika sudah lewat jam 22:00
    if (DateTime.now().hour >= 22) {
      calculateTotalPriceHari();
    }
    update();
  }

// Metode untuk menghitung total harga
  void calculateTotalPrice() {
    // Menyimpan total harga keseluruhan dengan menjumlahkan total harga menu dan minuman
    totalPrice.value = totalMenuPrice.value + totalDrinkPrice.value;

    // Mendapatkan tanggal hari ini
    DateTime currentDate = DateTime.now();

    // Jika sudah lewat dari jam 22:00, hitung total harga untuk hari tersebut
    if (currentDate.hour >= 22) {
      // Hitung total harga harian
      calculateTotalPriceHari();
    }
  }

  // Fungsi untuk mereset semua pilihan dan total harga
  void resetOrder() {
    selectedMenu.clear();
    selectedDrink.clear();
    totalMenuPrice.value = 0;
    totalDrinkPrice.value = 0;
    totalPrice.value = 0;
  }

  void saveTransaction() {
    // Mendapatkan tanggal hari ini dalam format "yyyy-MM-dd"
    String currentDate = DateTime.now().toString().split(' ')[0];

    // Mendapatkan transaksi yang akan disimpan
    Map<String, dynamic> transaction = {
      'date': currentDate,
      'selectedMenu': selectedMenu.toList(),
      'selectedDrink': selectedDrink.toList(),
      'totalMenuPrice': totalMenuPrice.value,
      'totalDrinkPrice': totalDrinkPrice.value,
      'totalPrice': totalPrice.value,
    };

    // Mendapatkan list transaksi yang sudah ada untuk tanggal hari ini
    List<dynamic> transactions = box.read(currentDate) ?? [];

    // Menambahkan transaksi baru ke dalam list transaksi
    transactions.add(transaction);

    // Menyimpan list transaksi kembali ke local storage
    box.write(currentDate, transactions);

    // Reset pesanan setelah berhasil menyimpan transaksi
    resetOrder();

    // Hitung kembali total harga harian setelah menambahkan transaksi baru
    calculateTotalPriceHari();

    // Memperbarui antarmuka pengguna setelah menambahkan transaksi baru
    update();

    // Tampilkan snackbar bahwa pesanan berhasil tersimpan
    Get.snackbar(
      'Sukses!',
      'Pesanan berhasil tersimpan',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    // Mendapatkan tanggal hari ini dalam format "yyyy-MM-dd"
    String currentDate = DateTime.now().toString().split(' ')[0];

    // Mendapatkan riwayat pemesanan untuk tanggal hari ini
    List<dynamic>? transactions = box.read<List<dynamic>>(currentDate);

    if (transactions != null) {
      // Lakukan konversi secara manual
      List<Map<String, dynamic>> mappedTransactions = transactions
          .map((transaction) => transaction as Map<String, dynamic>)
          .toList();

      // Simpan riwayat pemesanan ke dalam orderHistory
      orderHistory.assignAll(mappedTransactions);
    }

    return orderHistory;
  }

  void updateTotalRevenue() {
    // Mendapatkan tanggal hari ini dalam format "yyyy-MM-dd"
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Mendapatkan riwayat pemesanan untuk tanggal hari ini
    List<dynamic>? transactions = box.read<List<dynamic>>(currentDate);

    // Jika ada transaksi, hitung kembali total pendapatan
    if (transactions != null) {
      // Variabel untuk menyimpan total pendapatan
      num totalRevenue = 0;

      // Iterasi setiap transaksi dan tambahkan total pendapatannya
      for (var transaction in transactions) {
        totalRevenue += transaction['totalPrice'] ?? 0;
      }

      // Simpan total pendapatan kembali ke penyimpanan lokal
      box.write('totalPriceHari_$currentDate', totalRevenue);
    } else {
      // Jika tidak ada transaksi, total pendapatan untuk hari tersebut adalah 0
      box.write('totalPriceHari_$currentDate', 0);
    }
  }

  void removeOrder(int index) {
    // Mendapatkan tanggal hari ini dalam format "yyyy-MM-dd"
    String currentDate = DateTime.now().toString().split(' ')[0];

    // Mendapatkan riwayat pemesanan untuk tanggal hari ini
    List<dynamic>? transactions = box.read(currentDate);

    // Menghapus entri dengan indeks yang diberikan dari list transaksi
    transactions?.removeAt(index);

    // Menyimpan list transaksi kembali ke local storage
    box.write(currentDate, transactions);

    // Tampilkan snackbar bahwa entri berhasil dihapus
    Get.snackbar(
      'Sukses!',
      'Entri berhasil dihapus',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );

    // Memperbarui tampilan setelah menghapus entri
    update();
  }

// Metode untuk mendapatkan event-event untuk suatu tanggal
  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    // Mendapatkan histori pemesanan untuk tanggal tertentu
    List<Map<String, dynamic>>? transactions =
        box.read(day.toString().split(' ')[0])?.cast<Map<String, dynamic>>();
    return transactions ?? [];
  }

  // Metode untuk menetapkan tanggal yang dipilih
  void setSelectedDate(DateTime selectedDay, DateTime focusedDay) {
    selectedDate.value = selectedDay;
    // Memperbarui pesanan untuk tanggal yang dipilih
    selectedDateOrders.value = getEventsForDay(selectedDay);
    // Update UI after setting the selected date
    update();
  }

// Metode untuk menghitung total harga harian
  void calculateTotalPriceHari() {
    // Mendapatkan tanggal hari ini
    DateTime currentDate = DateTime.now();

    // Mendapatkan tanggal dalam format "yyyy-MM-dd"
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    // Mendapatkan semua transaksi untuk tanggal tersebut dari local storage
    List<dynamic>? transactions = box.read(formattedDate);

    if (transactions != null) {
      // Variabel untuk menyimpan total harga harian
      num totalHarian = 0;

      // Iterasi semua transaksi pada hari tersebut
      for (dynamic transaction in transactions) {
        // Mendapatkan total harga dari setiap transaksi dan menambahkannya ke totalHarian
        totalHarian += transaction['totalPrice'] ?? 0;
        update();
      }

      // Simpan total harga harian ke local storage
      box.write('totalPriceHari_$formattedDate', totalHarian);

      // Update nilai observable
      totalPriceHari.value =
          totalHarian.toInt(); // Konversi ke int sebelum disimpan
    }
  }

  void updateSelectedDateOrders(DateTime selectedDate) {
    selectedDateOrders.value = getEventsForDay(selectedDate);
  }

  void uangKembali() {
    String rxIntValue = hKembalian.text.trim();
    int total = totalPrice.value;

    // Membersihkan input harga dari karakter non-angka
    String cleanedPrice = rxIntValue.replaceAll(RegExp(r'[^0-9]'), '');
    int price = int.tryParse(cleanedPrice) ?? 0;

    if (price < total) {
      Get.snackbar(
        'Peringatan!',
        'Tolong masukkan angka dengan benar',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    uangKembalian.value = price - total;
  }

  @override
  void onInit() {
    getMenuPricesFromStorage();
    getDrinkPricesFromStorage();
    calculateTotalPriceHari();
    super.onInit();
  }
}
