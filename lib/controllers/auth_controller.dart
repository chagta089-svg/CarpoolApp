import 'package:get/get.dart';
import '../models/member_model.dart';

class AuthController extends GetxController {
  // ตัวแปรเก็บข้อมูลสมาชิกที่กำลังล็อกอิน 
  final Rx<MemberModel?> _currentUser = Rx<MemberModel?>(null);

  // ดึงข้อมูล User ออกมาใช้
  MemberModel? get currentUser => _currentUser.value;

  // เช็คสถานะว่าล็อกอินอยู่หรือไม่
  bool get isLoggedIn => _currentUser.value != null;

  // เมธอดสำหรับบันทึกข้อมูลตอนล็อกอินสำเร็จ
  void login(MemberModel user) {
    _currentUser.value = user;
    print("GetX: ล็อกอินสำเร็จด้วย ID: ${user.memberId}");
  }

  // เมธอดสำหรับออกจากระบบ
  void logout() {
    _currentUser.value = null;
    print("GetX: ออกจากระบบแล้ว");
  }
}