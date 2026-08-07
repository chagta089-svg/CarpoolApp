import 'package:carpool_app/services/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/share_trip_model.dart';

class TripController {
  final DatabaseReference _dbRef = dbRef;

  Future<List<Map<dynamic, dynamic>>> searchTrips(
    String origin,
    String dest, [
    DateTime? tripDate,
    String? currentUserId, // เพิ่มพารามิเตอร์นี้
  ]) async {
    try {
      DataSnapshot snapshot = await _dbRef.child('Member').get();
      List<Map<dynamic, dynamic>> tempResults = [];

      if (!snapshot.exists) return [];

      Map<dynamic, dynamic> membersMap = snapshot.value as Map<dynamic, dynamic>;

      membersMap.forEach((memberId, memberData) {
        // ข้าม member ที่เป็นตัวเอง (ไม่แสดงทริปของตัวเอง)
        if (currentUserId != null && memberId == currentUserId) {
          return; // ข้าม member นี้ไปเลย
        }

        if (memberData != null && memberData is Map && memberData['ShareTrip'] != null) {
          
          // ดึงชื่อคนขับ
          String fName = memberData['firstName']?.toString() ?? "";
          String lName = memberData['lastName']?.toString() ?? "";
          String driverName = "$fName $lName".trim();
          if (driverName.isEmpty) driverName = "ผู้ขับขี่รถ";

          Map<dynamic, dynamic> tripsMap = memberData['ShareTrip'] as Map;

          tripsMap.forEach((tripId, tripData) {
            var trip = Map<dynamic, dynamic>.from(tripData);
            trip['tripId'] = tripId;
            trip['memberId'] = memberId;
            trip['driverName'] = driverName;
            trip['statusDisplay'] = trip['tripStatus'] ?? 'ว่าง';

            trip['pickupLocation'] = tripData['pickupLocation'] ?? 'ไม่ระบุจุดนัดพบ';
            trip['routeDetails'] = tripData['routeDetails'] ?? 'ไม่ระบุ';
            trip['luggageCondition'] = tripData['luggageCondition'] ?? 'ไม่ระบุ';

            bool matchOrigin = origin.isEmpty || trip['originProvince'].toString().contains(origin);
            bool matchDest = dest.isEmpty || trip['destinationProvince'].toString().contains(dest);
            bool isOpen = trip['tripStatus'] == 'เปิดรับคำขอ';

            //  คำนวณที่นั่งว่างเพิ่ม เพื่อป้องกันทริปที่เต็มแล้วแต่คนขับยังไม่ได้เปลี่ยนสถานะ
            int maxSeats = int.tryParse(trip['maxSeats']?.toString() ?? trip['availableSeats']?.toString() ?? '0') ?? 0;
            int acceptedCount = 0;
            if (trip['Request'] != null && trip['Request'] is Map) {
              Map requests = trip['Request'] as Map;
              requests.forEach((key, req) {
                if (req is Map && (req['requestStatus'] == 'Confirmed' || req['requestStatus'] == 'ยืนยันแล้ว')) {
                  acceptedCount++;
                }
              });
            }
            int currentAvailable = maxSeats - acceptedCount;
            bool hasSeats = currentAvailable > 0;

            bool matchDate = true;
            if (tripDate != null) {
              String? tripDateStr = trip['tripDate']?.toString();
              if (tripDateStr != null && tripDateStr.isNotEmpty) {
                try {
                  List<String> parts;
                  if (tripDateStr.contains('/')) {
                    parts = tripDateStr.split('/');
                    DateTime tripDateTime = DateTime(
                      int.parse(parts[2]),
                      int.parse(parts[1]),
                      int.parse(parts[0]),
                    );
                    matchDate = tripDateTime.year == tripDate.year &&
                                tripDateTime.month == tripDate.month &&
                                tripDateTime.day == tripDate.day;
                  } else if (tripDateStr.contains('-')) {
                    parts = tripDateStr.split('-');
                    DateTime tripDateTime = DateTime(
                      int.parse(parts[0]),
                      int.parse(parts[1]),
                      int.parse(parts[2]),
                    );
                    matchDate = tripDateTime.year == tripDate.year &&
                                tripDateTime.month == tripDate.month &&
                                tripDateTime.day == tripDate.day;
                  } else {
                    matchDate = false;
                  }
                } catch (e) {
                  matchDate = false;
                }
              } else {
                matchDate = false;
              }
            }

            if (matchOrigin && matchDest && isOpen && matchDate) {
              tempResults.add(trip);
            }
          });
        }
      });

      // เรียงลำดับตามวันที่สร้าง ล่าสุดมาก่อน
      tempResults.sort((a, b) {
        String dateA = a['tripDate']?.toString() ?? '';
        String dateB = b['tripDate']?.toString() ?? '';
        
        if (dateA.isEmpty && dateB.isEmpty) return 0;
        if (dateA.isEmpty) return 1;
        if (dateB.isEmpty) return -1;
        
        try {
          List<String> partsA = dateA.split('/');
          List<String> partsB = dateB.split('/');
          if (partsA.length == 3 && partsB.length == 3) {
            DateTime dtA = DateTime(
              int.parse(partsA[2]),
              int.parse(partsA[1]),
              int.parse(partsA[0]),
            );
            DateTime dtB = DateTime(
              int.parse(partsB[2]),
              int.parse(partsB[1]),
              int.parse(partsB[0]),
            );
            return dtB.compareTo(dtA);
          }
        } catch (e) {
          return dateB.compareTo(dateA);
        }
        return dateB.compareTo(dateA);
      });

      return tempResults;
    } catch (e) {
      print("Error in searchTrips: $e");
      return [];
    }
  }

  // สร้างประกาศการเดินทาง
  Future<bool> createTrip(String memberId, ShareTripModel trip) async {
    try {
      if (trip.tripId == null || trip.tripId!.isEmpty) return false;
      await _dbRef.child('Member/$memberId/ShareTrip/${trip.tripId}').set(trip.toJson());
      return true;
    } catch (e) {
      print("Error creating trip: $e");
      return false;
    }
  }

  // ค้นหาทั้งหมดจากคนขับทุกคน 
  Future<List<ShareTripModel>> getListTrip() async {
    try {
      DataSnapshot snapshot = await _dbRef.child('Member').get();
      if (!snapshot.exists) return [];
      
      List<ShareTripModel> allTrips = [];
      Map<dynamic, dynamic> membersMap = snapshot.value as Map<dynamic, dynamic>;
      
      membersMap.forEach((memberId, memberData) {
        if (memberData is Map && memberData.containsKey('ShareTrip')) {
          Map<dynamic, dynamic> tripsMap = memberData['ShareTrip'] as Map<dynamic, dynamic>;
          tripsMap.forEach((tripId, tripData) {
            allTrips.add(ShareTripModel.fromJson(Map<String, dynamic>.from(tripData), tripId.toString()));
          });
        }
      });
      return allTrips;
    } catch (e) {
      print("Error getting trips: $e");
      return [];
    }
  }

  // แสดง Trip
  Future<ShareTripModel?> getTripById(String memberId, String tripId) async {
    try {
      DataSnapshot snapshot = await _dbRef.child('Member/$memberId/ShareTrip/$tripId').get();
      if (snapshot.exists) {
        return ShareTripModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map), snapshot.key!);
      }
      return null;
    } catch (e) {
      print("Error getting trip by id: $e");
      return null;
    }
  }

  // แก้ไขข้อมูลทริป
  Future<bool> editShareTrip(String memberId, ShareTripModel trip) async {
    try {
      await _dbRef.child('Member/$memberId/ShareTrip/${trip.tripId}').update(trip.toJson());
      return true;
    } catch (e) {
      print("Error updating trip: $e");
      return false;
    }
  }

  // ลบทริป
  Future<bool> deleteShareTrip(String memberId, String tripId) async {
    try {
      await _dbRef.child('Member/$memberId/ShareTrip/$tripId').remove();
      return true;
    } catch (e) {
      print("Error deleting trip: $e");
      return false;
    }
  }
}