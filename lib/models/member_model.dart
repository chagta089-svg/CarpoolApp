class MemberModel {
  String? memberId;     
  String? firstName;    
  String? lastName;     
  String? password;     
  String? gender;       
  String? phone;        
  String? imageFace;    
  String? imageIdCard;  
  String? regisDate;    
  String? status;       

  MemberModel({
    this.memberId,
    this.firstName,
    this.lastName,
    this.password,
    this.gender,
    this.phone,
    this.imageFace,
    this.imageIdCard,
    this.regisDate,
    this.status,
  });

  void loginPassenger() {
    print("ระบบกำลังตรวจสอบสิทธิ์ผู้ใช้งาน: $memberId");
  }

  void registerPassenger() {
    print("ระบบกำลังบันทึกข้อมูลสมาชิกใหม่: $firstName $lastName");
  }

  void editProfile() {
    print("ระบบกำลังอัปเดตข้อมูลผู้ใช้งาน: $memberId");
  }

  factory MemberModel.fromJson(Map<String, dynamic> json, String documentId) {
    return MemberModel(
      memberId: documentId,
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      password: json['password']?.toString(),
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      imageFace: json['imageFace']?.toString(),
      imageIdCard: json['imageIdCard']?.toString(),
      regisDate: json['regisDate']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'gender': gender,
      'phone': phone,
      'imageFace': imageFace,
      'imageIdCard': imageIdCard,
      'regisDate': regisDate,
      'status': status,
    };
  }
}