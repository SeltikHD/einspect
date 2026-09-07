import 'package:einspect/features/auth/data/models/user_model.dart';
import 'package:einspect/features/auth/domain/entities/auth_session_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  const LoginResponseModel._();

  const factory LoginResponseModel({
    required String accessToken,
    required String tokenType,
    required int expiresIn,
    required UserModel user,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  AuthSessionEntity toEntity() => AuthSessionEntity(
    accessToken: accessToken,
    tokenType: tokenType,
    expiresIn: expiresIn,
    user: user.toEntity(),
  );
}
