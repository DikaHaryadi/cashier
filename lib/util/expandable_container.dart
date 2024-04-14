import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeci/content/controller.dart';

class ExpandableContainer extends StatefulWidget {
  final String tanggal;
  final String totalPrice;
  final String totalMenu;
  final String totalDrink;
  final List<dynamic> menu;
  final List<dynamic> payMenu;
  final List<dynamic> drink;
  final List<dynamic> payDrink;
  final Map<String, int> menuCount;
  final Map<String, int> drinkCount;
  final Map<String, int> menuTotalPrice;
  final Map<String, int> drinkTotalPrice;

  const ExpandableContainer({
    Key? key,
    required this.tanggal,
    required this.totalPrice,
    required this.totalMenu,
    required this.totalDrink,
    required this.menu,
    required this.drink,
    required this.payMenu,
    required this.payDrink,
    required this.menuCount,
    required this.drinkCount,
    required this.menuTotalPrice,
    required this.drinkTotalPrice,
  }) : super(key: key);

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  final OrderController controller = Get.put(OrderController());
  bool _isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadiusDirectional.all(Radius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: const EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            toggleExpansion();
          },
          children: [
            ExpansionPanel(
              backgroundColor: Colors.white,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return InkWell(
                  onTap: toggleExpansion,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.tanggal,
                          maxFontSize: 16,
                          minFontSize: 14,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                        AutoSizeText(
                          'Total Pemesanan : ${widget.totalPrice}',
                          maxFontSize: 16,
                          minFontSize: 14,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
              body: FadeTransition(
                opacity: animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    AutoSizeText(
                      'Keterangan Produk',
                      maxFontSize: 18,
                      minFontSize: 16,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: _isExpanded ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    if (widget.totalMenu.isNotEmpty) ...[
                      AutoSizeText(
                        'Makanan:',
                        maxFontSize: 18,
                        minFontSize: 16,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          color: _isExpanded ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      AutoSizeText(
                        widget.menuCount.isEmpty
                            ? 'Tidak ada makanan yang dipesan'
                            : 'Kategori Makanan : ${widget.menuCount}',
                        maxFontSize: 14,
                        minFontSize: 12,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          color: _isExpanded ? Colors.black : Colors.white,
                        ),
                      ),
                      AutoSizeText(
                        widget.menuTotalPrice.isEmpty
                            ? ''
                            : 'Total Harga: ${widget.menuTotalPrice}',
                        maxFontSize: 14,
                        minFontSize: 12,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          color: _isExpanded ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10.0),
                    if (widget.totalDrink.isNotEmpty) ...[
                      AutoSizeText(
                        'Minuman:',
                        maxFontSize: 18,
                        minFontSize: 16,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          color: _isExpanded ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        widget.drinkCount.isEmpty
                            ? 'Tidak ada minuman yang dipesan'
                            : 'Kategori Minuman : ${widget.drinkCount}',
                        maxFontSize: 14,
                        minFontSize: 12,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          color: _isExpanded ? Colors.black : Colors.white,
                        ),
                      ),
                      AutoSizeText(
                        widget.drinkTotalPrice.isEmpty
                            ? ''
                            : 'Total Harga: ${widget.drinkTotalPrice}',
                        maxFontSize: 14,
                        minFontSize: 12,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          color: _isExpanded ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              isExpanded: _isExpanded,
            ),
          ],
        ),
      ),
    );
  }
}
