class ShareTripModel {
  String? tripId;               
  String? originProvince;       
  String? destinationProvince;  
  String? tripDate;             
  String? departureTime;        
  double? currentLatitude;      
  double? currentLongitude;     
  double? dropoffLatitude;      
  double? dropoffLongitude;     
  int? maxSeats;                
  int? availableSeats;          
  double? personCost;           
  String? tripDetail;           
  String? linkShare;            
  String? tripStatus;  
  List<String>? routeDetails;  
  String? luggageCondition;         

  ShareTripModel({
    this.tripId,
    this.originProvince,
    this.destinationProvince,
    this.tripDate,
    this.departureTime,
    this.currentLatitude,
    this.currentLongitude,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.maxSeats,
    this.availableSeats,
    this.personCost,
    this.tripDetail,
    this.linkShare,
    this.tripStatus,
    this.routeDetails,
    this.luggageCondition,
  });

  factory ShareTripModel.fromJson(Map<String, dynamic> json, String documentId) {
    // แปลง routeDetails จาก JSON เป็น List<String>
    List<String> routeList = [];
    if (json['routeDetails'] != null) {
      if (json['routeDetails'] is List) {
        routeList = List<String>.from(json['routeDetails']);
      } else if (json['routeDetails'] is String) {
        // ถ้าเป็น String เดิม (กรณีเก่า) ให้แปลงเป็น List
        String routeStr = json['routeDetails'] as String;
        if (routeStr.isNotEmpty) {
          routeList = routeStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }
      }
    }
    
    return ShareTripModel(
      tripId: documentId,
      originProvince: json['originProvince'],
      destinationProvince: json['destinationProvince'],
      tripDate: json['tripDate'],
      departureTime: json['departureTime'],
      currentLatitude: (json['currentLatitude'] ?? 0.0).toDouble(),
      currentLongitude: (json['currentLongitude'] ?? 0.0).toDouble(),
      dropoffLatitude: (json['dropoffLatitude'] ?? 0.0).toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] ?? 0.0).toDouble(),
      maxSeats: json['maxSeats'],
      availableSeats: json['availableSeats'],
      personCost: (json['personCost'] ?? 0.0).toDouble(),
      tripDetail: json['tripDetail'],
      linkShare: json['linkShare'],
      tripStatus: json['tripStatus'],
      routeDetails: routeList.isNotEmpty ? routeList : null,
      luggageCondition: json['luggageCondition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originProvince': originProvince,
      'destinationProvince': destinationProvince,
      'tripDate': tripDate,
      'departureTime': departureTime,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
      'dropoffLatitude': dropoffLatitude,
      'dropoffLongitude': dropoffLongitude,
      'maxSeats': maxSeats,
      'availableSeats': availableSeats,
      'personCost': personCost,
      'tripDetail': tripDetail,
      'linkShare': linkShare,
      'tripStatus': tripStatus,
      'routeDetails': routeDetails, // เก็บเป็น List
      'luggageCondition': luggageCondition,
    };
  }
}