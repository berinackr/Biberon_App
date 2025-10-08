import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class City {
  City({
    required this.id,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;

  City copyWith({
    int? id,
    String? name,
  }) =>
      City(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
