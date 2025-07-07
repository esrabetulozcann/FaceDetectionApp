class UserSignInModel {

  final String password;
  final String email;


  UserSignInModel({
    required this.password,
    required this.email,

  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'email': email,

    };
  }
}
