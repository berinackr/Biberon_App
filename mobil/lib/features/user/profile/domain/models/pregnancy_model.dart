import 'package:biberon/features/user/profile/domain/models/fetus_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pregnancy_model.g.dart';

@JsonSerializable()
class Pregnancy {
  Pregnancy({
    required this.isActive,
    required this.id,
    required this.birthGiven,
    this.dueDate,
    this.type,
    this.deliveryType,
    this.notes,
    this.endDate,
    this.lastPeriodDate,
    this.fetuses,
  });

  factory Pregnancy.fromJson(Map<String, dynamic> json) =>
      _$PregnancyFromJson(json);
  @JsonKey(name: 'deliveryType')
  final String? deliveryType;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'endDate')
  final DateTime? endDate;
  @JsonKey(name: 'dueDate')
  final DateTime? dueDate;
  @JsonKey(name: 'lastPeriodDate')
  final DateTime? lastPeriodDate;
  @JsonKey(name: 'birthGiven')
  final bool birthGiven;
  @JsonKey(name: 'type')
  final String? type;
  @JsonKey(name: 'fetuses')
  final List<Fetus>? fetuses;

  Pregnancy copyWith({
    String? deliveryType,
    bool? isActive,
    String? notes,
    int? id,
    DateTime? endDate,
    DateTime? dueDate,
    DateTime? lastPeriodDate,
    bool? birthGiven,
    String? type,
    List<Fetus>? fetuses,
  }) =>
      Pregnancy(
        deliveryType: deliveryType ?? this.deliveryType,
        isActive: isActive ?? this.isActive,
        notes: notes ?? this.notes,
        id: id ?? this.id,
        endDate: endDate ?? this.endDate,
        dueDate: dueDate ?? this.dueDate,
        lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
        birthGiven: birthGiven ?? this.birthGiven,
        type: type ?? this.type,
        fetuses: fetuses ?? this.fetuses,
      );

  Map<String, dynamic> toJson() => _$PregnancyToJson(this);
}
