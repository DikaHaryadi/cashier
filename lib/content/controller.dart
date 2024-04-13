import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  // Menggunakan Map untuk menyimpan harga menu dan minuman
  final Map<String, int> menuPrices = {
    'mie ayam': 13000,
    'mie ayam bakso': 15000,
    'bakso urat': 15000,
    'bakso telor': 18000,
    'bakso beranak': 17000,
    'bakso mercon': 20000,
  };

  final Map<String, int> drinkPrices = {
    'stee': 4000,
    'air gelas': 1000,
    'lemineral': 2000,
    'es teh manis hangat': 5000,
    'es good day': 5000,
    'milkshake': 5000,
  };

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

  final box = GetStorage();

  void toggleDrink(String item) {
    if (selectedDrink.contains(item)) {
      selectedDrink.remove(item);
      totalDrinkPrice.value -= drinkPrices[item] ?? 0;
    } else {
      selectedDrink.add(item);
      totalDrinkPrice.value += drinkPrices[item] ?? 0;
    }
    updateTotalPrice(); // Panggil updateTotalPrice setiap kali ada perubahan
  }

  void removeDrink(String drink) {
    if (selectedDrink.contains(drink)) {
      selectedDrink.remove(drink);
      totalDrinkPrice.value -= drinkPrices[drink] ?? 0;
      calculateTotalPrice();
    }
  }

  void addDrink(String drink) {
    selectedDrink.add(drink);
    totalDrinkPrice.value += drinkPrices[drink] ?? 0;
    calculateTotalPrice();
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
      totalMenuPrice.value -= menuPrices[menu] ?? 0;
      calculateTotalPrice();
    }
  }

  void addMenu(String menu) {
    selectedMenu.add(menu);
    totalMenuPrice.value += menuPrices[menu] ?? 0;
    calculateTotalPrice();
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

  @override
  void onInit() {
    calculateTotalPriceHari();
    print('total price hari $totalPriceHari');
    super.onInit();
  }
}
