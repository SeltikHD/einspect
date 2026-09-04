import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/user_entity.dart';

class LoginResponseModel extends AuthSessionEntity {
  const LoginResponseModel({
    required super.accessToken,
    required super.tokenType,
    required super.expiresIn,
    required super.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>;

    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String,
      expiresIn: json['expiresIn'] as int,
      user: UserEntity(
        id: userData['id'] as String,
        name: userData['name'] as String,
        email: userData['email'] as String,
        role: userData['role'] as String,
      ),
    );
  }
}
