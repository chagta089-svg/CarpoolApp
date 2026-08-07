class RequestShareModel {
  String? requestId;         
  String? pickupLocation;    
  String? dropoffLocation;   
  String? requestType;       
  String? requestDate;       
  double? pickLatitude;      
  double? pickLongitude;     
  String? requestDetail;     
  String? requestStatus;     

  RequestShareModel({
    this.requestId,
    this.pickupLocation,
    this.dropoffLocation,
    this.requestType,
    this.requestDate,
    this.pickLatitude,
    this.pickLongitude,
    this.requestDetail,
    this.requestStatus,
  });

  factory RequestShareModel.fromJson(Map<String, dynamic> json, String documentId) {
    return RequestShareModel(
      requestId: documentId,
      pickupLocation: json['pickupLocation'],
      dropoffLocation: json['dropoffLocation'],
      requestType: json['requestType'],
      requestDate: json['requestDate'],
      pickLatitude: (json['pickLatitude'] ?? 0.0).toDouble(),
      pickLongitude: (json['pickLongitude'] ?? 0.0).toDouble(),
      requestDetail: json['requestDetail'],
      requestStatus: json['requestStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'requestType': requestType,
      'requestDate': requestDate,
      'pickLatitude': pickLatitude,
      'pickLongitude': pickLongitude,
      'requestDetail': requestDetail,
      'requestStatus': requestStatus,
    };
  }
}