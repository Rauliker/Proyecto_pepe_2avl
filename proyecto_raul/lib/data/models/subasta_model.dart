import 'package:proyecto_raul/domain/entities/subastas_entities.dart';

class SubastaModel {
  final SubastaEntity subastaEntity;

  SubastaModel({required this.subastaEntity});

  factory SubastaModel.fromJson(Map<String, dynamic> json) {
    return SubastaModel(
      subastaEntity: SubastaEntity.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return subastaEntity.toJson();
  }
}
