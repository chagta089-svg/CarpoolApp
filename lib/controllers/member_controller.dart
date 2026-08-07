import 'package:carpool_app/services/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart'; 
import 'package:get/get.dart'; 
import '../models/member_model.dart';
import 'auth_controller.dart'; 

class MemberController {
  final DatabaseReference _dbRef = dbRef;
  
  final String _nodeName = 'Member';

  //  Login
  Future<bool> login(String id, String password) async {
    try {
      print("กำลังค้นหา ID: $id ใน Realtime Database");

      DataSnapshot snapshot = await _dbRef.child('$_nodeName/$id').get();
      
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        MemberModel user = MemberModel.fromJson(Map<String, dynamic>.from(data), id);
        
        print("รหัสผ่านที่กรอก: $password");
        print("รหัสผ่านใน DB: ${user.password}");
        
        if (user.password == password) {
          user.loginPassenger();
          
          if (!Get.isRegistered<AuthController>()) {
            Get.put(AuthController()); 
          }
          Get.find<AuthController>().login(user);

          return true;
        } else {
          print("รหัสผ่านไม่ตรงกัน!");
        }
      } else {
        print("ไม่พบ ID นี้ในระบบ");
      }
      return false;
    } catch (e) {
      print("Error Login: $e");
      return false;
    }
  }

  //  Register
  Future<bool> register(MemberModel member) async {
    try {
      if (member.memberId == null || member.memberId!.isEmpty) return false;
      
      await _dbRef.child('$_nodeName/${member.memberId}').set(member.toJson());
      member.registerPassenger();
      return true;
    } catch (e) {
      print("Error Register: $e");
      return false;
    }
  }
}