// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkOrderModel {

 String get id; String get code; String get title; String get description; String get address; String get priority; String get status; double get latitude; double get longitude; DateTime get scheduledAt; DateTime get updatedAt;
/// Create a copy of WorkOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderModelCopyWith<WorkOrderModel> get copyWith => _$WorkOrderModelCopyWithImpl<WorkOrderModel>(this as WorkOrderModel, _$identity);

  /// Serializes this WorkOrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkOrderModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.scheduledAt, _this.scheduledAt) || other.scheduledAt == _this.scheduledAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkOrderModel;
  return Object.hash(runtimeType,_this.id,_this.code,_this.title,_this.description,_this.address,_this.priority,_this.status,_this.latitude,_this.longitude,_this.scheduledAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as WorkOrderModel;
  return 'WorkOrderModel(id: ${_this.id}, code: ${_this.code}, title: ${_this.title}, description: ${_this.description}, address: ${_this.address}, priority: ${_this.priority}, status: ${_this.status}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, scheduledAt: ${_this.scheduledAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $WorkOrderModelCopyWith<$Res>  {
  factory $WorkOrderModelCopyWith(WorkOrderModel value, $Res Function(WorkOrderModel) _then) = _$WorkOrderModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String title, String description, String address, String priority, String status, double latitude, double longitude, DateTime scheduledAt, DateTime updatedAt
});




}
/// @nodoc
class _$WorkOrderModelCopyWithImpl<$Res>
    implements $WorkOrderModelCopyWith<$Res> {
  _$WorkOrderModelCopyWithImpl(this._self, this._then);

  final WorkOrderModel _self;
  final $Res Function(WorkOrderModel) _then;

/// Create a copy of WorkOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? title = null,Object? description = null,Object? address = null,Object? priority = null,Object? status = null,Object? latitude = null,Object? longitude = null,Object? scheduledAt = null,Object? updatedAt = null,}) {
  return _then(WorkOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkOrderModel].
extension WorkOrderModelPatterns on WorkOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String title,  String description,  String address,  String priority,  String status,  double latitude,  double longitude,  DateTime scheduledAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrderModel() when $default != null:
return $default(_that.id,_that.code,_that.title,_that.description,_that.address,_that.priority,_that.status,_that.latitude,_that.longitude,_that.scheduledAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String title,  String description,  String address,  String priority,  String status,  double latitude,  double longitude,  DateTime scheduledAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkOrderModel():
return $default(_that.id,_that.code,_that.title,_that.description,_that.address,_that.priority,_that.status,_that.latitude,_that.longitude,_that.scheduledAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String title,  String description,  String address,  String priority,  String status,  double latitude,  double longitude,  DateTime scheduledAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrderModel() when $default != null:
return $default(_that.id,_that.code,_that.title,_that.description,_that.address,_that.priority,_that.status,_that.latitude,_that.longitude,_that.scheduledAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrderModel extends WorkOrderModel {
  const _WorkOrderModel({required this.id, required this.code, required this.title, this.description = '', required this.address, this.priority = 'medium', this.status = 'open', required this.latitude, required this.longitude, required this.scheduledAt, required this.updatedAt}): super._();
  factory _WorkOrderModel.fromJson(Map<String, dynamic> json) => _$WorkOrderModelFromJson(json);

@override final  String id;
@override final  String code;
@override final  String title;
@override@JsonKey() final  String description;
@override final  String address;
@override@JsonKey() final  String priority;
@override@JsonKey() final  String status;
@override final  double latitude;
@override final  double longitude;
@override final  DateTime scheduledAt;
@override final  DateTime updatedAt;

/// Create a copy of WorkOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderModelCopyWith<_WorkOrderModel> get copyWith => __$WorkOrderModelCopyWithImpl<_WorkOrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,title,description,address,priority,status,latitude,longitude,scheduledAt,updatedAt);
}

@override
String toString() {
    return 'WorkOrderModel(id: $id, code: $code, title: $title, description: $description, address: $address, priority: $priority, status: $status, latitude: $latitude, longitude: $longitude, scheduledAt: $scheduledAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderModelCopyWith<$Res> implements $WorkOrderModelCopyWith<$Res> {
  factory _$WorkOrderModelCopyWith(_WorkOrderModel value, $Res Function(_WorkOrderModel) _then) = __$WorkOrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String title, String description, String address, String priority, String status, double latitude, double longitude, DateTime scheduledAt, DateTime updatedAt
});




}
/// @nodoc
class __$WorkOrderModelCopyWithImpl<$Res>
    implements _$WorkOrderModelCopyWith<$Res> {
  __$WorkOrderModelCopyWithImpl(this._self, this._then);

  final _WorkOrderModel _self;
  final $Res Function(_WorkOrderModel) _then;

/// Create a copy of WorkOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? title = null,Object? description = null,Object? address = null,Object? priority = null,Object? status = null,Object? latitude = null,Object? longitude = null,Object? scheduledAt = null,Object? updatedAt = null,}) {
  return _then(_WorkOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
