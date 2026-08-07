class CarModel {
  String? carId;          
  String? vehicleName;    
  String? model;          
  String? licensePlate;   
  String? imageDrivingLicense;   
  String? imageCar;              

  CarModel({
    this.carId,
    this.vehicleName,
    this.model,
    this.licensePlate,
    this.imageDrivingLicense,   
    this.imageCar,              
  });

  factory CarModel.fromJson(Map<String, dynamic> json, String documentId) {
    return CarModel(
      carId: documentId,
      vehicleName: json['vehicleName'],
      model: json['model'],
      licensePlate: json['licensePlate'],           
      imageDrivingLicense: json['imageDrivingLicense'],  
      imageCar: json['imageCar'],                   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleName': vehicleName,
      'model': model,
      'licensePlate': licensePlate,
      'imageDrivingLicense': imageDrivingLicense,   
      'imageCar': imageCar,                         
    };
  }
}