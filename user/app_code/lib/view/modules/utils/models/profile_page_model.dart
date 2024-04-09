class ProfilePageModel {
  String fullName;
  String userName;
  String bio;
  String phoneNumber;
  String gender;
  String dob;
  String profileImage;
  String bgImage;
  String email;
  String department;
  String companyName;
  String location;

  ProfilePageModel({
    required this.fullName,
    required this.userName,
    required this.bio,
    required this.phoneNumber,
    required this.gender,
    required this.dob,
    required this.profileImage,
    required this.bgImage,
    required this.email,
    required this.department,
    required this.companyName,
    required this.location,
  });

  factory ProfilePageModel.fromMap(Map<String, dynamic> data) {
    return ProfilePageModel(
      fullName: data['fullName'],
      userName: data['userName'],
      bio: data['bio'],
      phoneNumber: data['phoneNumber'],
      gender: data['gender'],
      dob: data['dob'],
      profileImage: data['profileImage'],
      bgImage: data['bgImage'],
      email: data['email'],
      department: data['department'],
      companyName: data['companyName'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'userName': userName,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dob': dob,
      'profileImage': profileImage,
      'bgImage': bgImage,
      'email': email,
      'department': department,
      'companyName': companyName,
      'location': location,
    };
  }
}
