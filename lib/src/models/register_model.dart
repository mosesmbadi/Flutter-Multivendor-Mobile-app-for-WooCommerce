class RegisterModel {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String password;
  String username;
  String companyName;
  RegisterModel({this.firstName, this.lastName, this.email, this.phoneNumber, this.password, this.username,this.companyName});

  Map<String, dynamic> toJson() => {
    "first_name": firstName == null ? '' : firstName,
    "last_name": lastName == null ? '' : lastName,
    "email": email == null ? '' : email,
    "phone_number": phoneNumber == null ? '' : phoneNumber,
    "password": password == null ? '' : password,
    "username": email == null ? '' : email,
    "company_name":companyName == null ? '' : companyName
  };
}