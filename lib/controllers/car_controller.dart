import 'package:firebase_database/firebase_database.dart';
import '../services/firebase_service.dart';
import '../models/car_model.dart';

class CarController {

final DatabaseReference _dbRef = dbRef;

  // เพิ่มข้อมูลรถ
  Future<bool> addCar(String memberId, CarModel car) async {
    try {
      await _dbRef.child('Member/$memberId/Car').set(car.toJson());
      return true;
    } catch (e) {
      print("Error adding car: $e");
      return false;
    }
  }

  // ดึงข้อมูลรถของคนขับ
  Future<CarModel?> getCarByMemberId(String memberId) async {
    try {
      DataSnapshot snapshot = await _dbRef.child('Member/$memberId/Car').get();
      if (snapshot.exists) {
        return CarModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map), snapshot.key ?? "no_id");
      }
      return null;
    } catch (e) {
      print("Error fetching car: $e");
      return null;
    }
  }
}