import 'package:flutter_application_1/domain/entities/users.dart';

class UserModel extends User{

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(id: json['id'] is int ? json['id'] : int.parse('${json['id']}'),
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phoneNumber']);
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }


  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}