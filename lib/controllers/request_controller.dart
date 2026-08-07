import 'package:carpool_app/services/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/request_share_model.dart';

class RequestController {
  final DatabaseReference _dbRef = dbRef;

  Future<String> sendRequest(
    String driverId,
    String tripId,
    Map<String, dynamic> requestData,
  ) async {
    try {
      String passengerId = requestData['passengerId'];

      // เช็คคำขอซ้ำก่อน
      DataSnapshot snapshot = await _dbRef
          .child('Member/$driverId/ShareTrip/$tripId/Request')
          .get();
      if (snapshot.exists) {
        Map requests = snapshot.value as Map;
        for (var key in requests.keys) {
          var req = requests[key];
          if (req['passengerId'] == passengerId) {
            String status = req['requestStatus'] ?? 'Pending';
            // ถ้าเคยส่งแล้วและยังไม่ถูกยกเลิก/ปฏิเสธ 
            if (status != 'Cancelled' &&
                status != 'Rejected' &&
                status != 'Failed' &&
                status != 'ถูกปฏิเสธ') {
              return 'duplicate'; // ส่งคำว่า duplicate กลับไป
            }
          }
        }
      }

      // ถ้าส่งค่ามาได้ (ไม่ซ้ำ) ก็บันทึกข้อมูลตามปกติ
      DatabaseReference newRef = _dbRef
          .child('Member/$driverId/ShareTrip/$tripId/Request')
          .push();
      requestData['requestId'] = newRef.key;
      await newRef.set(requestData);
      return 'success'; // บันทึกสำเร็จ
    } catch (e) {
      print("Error sending request: $e");
      return 'error'; // เกิดข้อผิดพลาด
    }
  }

  // ดึงคำขอทั้งหมดในระบบ
  Future<List<RequestShareModel>> getListRequests() async {
    try {
      DataSnapshot snapshot = await _dbRef.child('Member').get();
      if (!snapshot.exists) return [];

      List<RequestShareModel> allRequests = [];
      Map<dynamic, dynamic> membersMap =
          snapshot.value as Map<dynamic, dynamic>;

      // วนลูปหาโหนด RequestShare ใน Member แต่ละคน
      membersMap.forEach((memberId, memberData) {
        if (memberData is Map && memberData.containsKey('RequestShare')) {
          Map<dynamic, dynamic> requestsMap =
              memberData['RequestShare'] as Map<dynamic, dynamic>;
          requestsMap.forEach((requestId, requestData) {
            allRequests.add(
              RequestShareModel.fromJson(
                Map<String, dynamic>.from(requestData),
                requestId.toString(),
              ),
            );
          });
        }
      });
      return allRequests;
    } catch (e) {
      print("Error fetching requests: $e");
      return [];
    }
  }

  // อัปเดตสถานะคำขอ
  Future<bool> updateRequestStatus(
    String memberId,
    String requestId,
    String newStatus,
  ) async {
    try {
      await _dbRef.child('Member/$memberId/RequestShare/$requestId').update({
        'requestStatus': newStatus,
      });
      return true;
    } catch (e) {
      print("Error updating status: $e");
      return false;
    }
  }
}
