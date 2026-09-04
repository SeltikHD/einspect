// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionModel {

 String get clientId; String get userId; String get workOrderId; String? get serverId; String? get observation; String? get condition; double? get latitude; double? get longitude; String? get photoPath; String get status; String? get failureReason; DateTime? get capturedAt; DateTime? get syncedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of InspectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionModelCopyWith<InspectionModel> get copyWith => _$InspectionModelCopyWithImpl<InspectionModel>(this as InspectionModel, _$identity);

  /// Serializes this InspectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionModel&&(identical(other.clientId, _this.clientId) || other.clientId == _this.clientId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.workOrderId, _this.workOrderId) || other.workOrderId == _this.workOrderId)&&(identical(other.serverId, _this.serverId) || other.serverId == _this.serverId)&&(identical(other.observation, _this.observation) || other.observation == _this.observation)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.failureReason, _this.failureReason) || other.failureReason == _this.failureReason)&&(identical(other.capturedAt, _this.capturedAt) || other.capturedAt == _this.capturedAt)&&(identical(other.syncedAt, _this.syncedAt) || other.syncedAt == _this.syncedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectionModel;
  return Object.hash(runtimeType,_this.clientId,_this.userId,_this.workOrderId,_this.serverId,_this.observation,_this.condition,_this.latitude,_this.longitude,_this.photoPath,_this.status,_this.failureReason,_this.capturedAt,_this.syncedAt,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as InspectionModel;
  return 'InspectionModel(clientId: ${_this.clientId}, userId: ${_this.userId}, workOrderId: ${_this.workOrderId}, serverId: ${_this.serverId}, observation: ${_this.observation}, condition: ${_this.condition}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, photoPath: ${_this.photoPath}, status: ${_this.status}, failureReason: ${_this.failureReason}, capturedAt: ${_this.capturedAt}, syncedAt: ${_this.syncedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $InspectionModelCopyWith<$Res>  {
  factory $InspectionModelCopyWith(InspectionModel value, $Res Function(InspectionModel) _then) = _$InspectionModelCopyWithImpl;
@useResult
$Res call({
 String clientId, String userId, String workOrderId, String? serverId, String? observation, String? condition, double? latitude, double? longitude, String? photoPath, String status, String? failureReason, DateTime? capturedAt, DateTime? syncedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$InspectionModelCopyWithImpl<$Res>
    implements $InspectionModelCopyWith<$Res> {
  _$InspectionModelCopyWithImpl(this._self, this._then);

  final InspectionModel _self;
  final $Res Function(InspectionModel) _then;

/// Create a copy of InspectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientId = null,Object? userId = null,Object? workOrderId = null,Object? serverId = freezed,Object? observation = freezed,Object? condition = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? photoPath = freezed,Object? status = null,Object? failureReason = freezed,Object? capturedAt = freezed,Object? syncedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(InspectionModel(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,workOrderId: null == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String?,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InspectionModel].
extension InspectionModelPatterns on InspectionModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionModel value)  $default,){
final _that = this;
switch (_that) {
case _InspectionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientId,  String userId,  String workOrderId,  String? serverId,  String? observation,  String? condition,  double? latitude,  double? longitude,  String? photoPath,  String status,  String? failureReason,  DateTime? capturedAt,  DateTime? syncedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionModel() when $default != null:
return $default(_that.clientId,_that.userId,_that.workOrderId,_that.serverId,_that.observation,_that.condition,_that.latitude,_that.longitude,_that.photoPath,_that.status,_that.failureReason,_that.capturedAt,_that.syncedAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientId,  String userId,  String workOrderId,  String? serverId,  String? observation,  String? condition,  double? latitude,  double? longitude,  String? photoPath,  String status,  String? failureReason,  DateTime? capturedAt,  DateTime? syncedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InspectionModel():
return $default(_that.clientId,_that.userId,_that.workOrderId,_that.serverId,_that.observation,_that.condition,_that.latitude,_that.longitude,_that.photoPath,_that.status,_that.failureReason,_that.capturedAt,_that.syncedAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientId,  String userId,  String workOrderId,  String? serverId,  String? observation,  String? condition,  double? latitude,  double? longitude,  String? photoPath,  String status,  String? failureReason,  DateTime? capturedAt,  DateTime? syncedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InspectionModel() when $default != null:
return $default(_that.clientId,_that.userId,_that.workOrderId,_that.serverId,_that.observation,_that.condition,_that.latitude,_that.longitude,_that.photoPath,_that.status,_that.failureReason,_that.capturedAt,_that.syncedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionModel extends InspectionModel {
  const _InspectionModel({required this.clientId, required this.userId, required this.workOrderId, this.serverId, this.observation, this.condition, this.latitude, this.longitude, this.photoPath, this.status = 'draft', this.failureReason, this.capturedAt, this.syncedAt, required this.createdAt, required this.updatedAt}): super._();
  factory _InspectionModel.fromJson(Map<String, dynamic> json) => _$InspectionModelFromJson(json);

@override final  String clientId;
@override final  String userId;
@override final  String workOrderId;
@override final  String? serverId;
@override final  String? observation;
@override final  String? condition;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? photoPath;
@override@JsonKey() final  String status;
@override final  String? failureReason;
@override final  DateTime? capturedAt;
@override final  DateTime? syncedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of InspectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionModelCopyWith<_InspectionModel> get copyWith => __$InspectionModelCopyWithImpl<_InspectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionModel&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,clientId,userId,workOrderId,serverId,observation,condition,latitude,longitude,photoPath,status,failureReason,capturedAt,syncedAt,createdAt,updatedAt);
}

@override
String toString() {
    return 'InspectionModel(clientId: $clientId, userId: $userId, workOrderId: $workOrderId, serverId: $serverId, observation: $observation, condition: $condition, latitude: $latitude, longitude: $longitude, photoPath: $photoPath, status: $status, failureReason: $failureReason, capturedAt: $capturedAt, syncedAt: $syncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InspectionModelCopyWith<$Res> implements $InspectionModelCopyWith<$Res> {
  factory _$InspectionModelCopyWith(_InspectionModel value, $Res Function(_InspectionModel) _then) = __$InspectionModelCopyWithImpl;
@override @useResult
$Res call({
 String clientId, String userId, String workOrderId, String? serverId, String? observation, String? condition, double? latitude, double? longitude, String? photoPath, String status, String? failureReason, DateTime? capturedAt, DateTime? syncedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$InspectionModelCopyWithImpl<$Res>
    implements _$InspectionModelCopyWith<$Res> {
  __$InspectionModelCopyWithImpl(this._self, this._then);

  final _InspectionModel _self;
  final $Res Function(_InspectionModel) _then;

/// Create a copy of InspectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientId = null,Object? userId = null,Object? workOrderId = null,Object? serverId = freezed,Object? observation = freezed,Object? condition = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? photoPath = freezed,Object? status = null,Object? failureReason = freezed,Object? capturedAt = freezed,Object? syncedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_InspectionModel(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,workOrderId: null == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String?,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
