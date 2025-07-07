class UserModel {
  final String? name;
  final String? surname;
  final String? passwordHash;
  final String? email;
  final String? gender;
  final String? phoneNumber;

  UserModel({
    this.name,
    this.surname,
    this.passwordHash,
    this.email,
    this.gender,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'] as String?,
        surname: json['surname'] as String?,
        email: json['email'] as String?,
        gender: json['gender'] as String?,
        phoneNumber: json['phoneNumber'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'passwordHash': passwordHash,
      'email': email,
      'gender': gender,
      'phoneNumber': phoneNumber,
    };
  }

  static UserModel dummyUser = UserModel(
    name: 'John',
    surname: 'Doe',
    passwordHash: 'password123',
    email: 'john_doe@gmail.com',
    gender: 'Erkek',
    phoneNumber: '1234567890',
  );
}
