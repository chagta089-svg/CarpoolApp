import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../views/search/search_trip_page.dart';
import '../views/profile/view_profile_page.dart'; 
import '../views/request/list_request_share_page.dart';
import '../views/share/share_location_page.dart';
import 'package:carpool_app/views/driver/driver_menu_page.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  // ฟังก์ชันช่วยสร้างรายการหน้าตามสถานะผู้ใช้
  List<Widget> _getPages(bool isDriver) {
    List<Widget> pages = [
      const SearchTripPage(),          // Index 0: ค้นหา
      const ListRequestSharePage(),    // Index 1: คำขอ (รวมเดินทางไว้ในนี้แล้ว)
      const ShareLocationPage(),       // Index 2: แชร์ตำแหน่ง
    ];
    if (isDriver) {
      pages.add(const DriverMenuPage()); // Index 3: เมนูคนขับ (ถ้าเป็นคนขับ)
    }
    pages.add(const ViewProfilePage());  // Index สุดท้าย (3 หรือ 4): หน้าโปรไฟล์อยู่ท้ายสุดเสมอ
    return pages;
  }

  void _onItemTapped(BuildContext context, int index) {
    final AuthController authController = Get.find<AuthController>();
    final bool isDriver = authController.currentUser?.status == 'Driver';
    final List<Widget> pages = _getPages(isDriver);

    if (index < pages.length) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => pages[index],
          transitionDuration: Duration.zero, 
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final bool isDriver = authController.currentUser?.status == 'Driver';

    List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'ค้นหา'),
      const BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'คำขอ'), 
      const BottomNavigationBarItem(icon: Icon(Icons.share), label: 'แชร์'),
    ];

    if (isDriver) {
      navItems.add(const BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'คนขับ'));
    }
    navItems.add(const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'));

    int safeIndex = currentIndex;
    if (safeIndex >= navItems.length) {
      safeIndex = navItems.length - 1;
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: safeIndex, 
      selectedItemColor: const Color(0xFF1E3A8A),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 10, 
      unselectedFontSize: 10, 
      onTap: (index) => _onItemTapped(context, index), 
      items: navItems,
    );
  }
}