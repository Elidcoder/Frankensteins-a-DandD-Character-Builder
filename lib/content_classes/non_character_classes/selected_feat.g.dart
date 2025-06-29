// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_feat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedFeat _$SelectedFeatFromJson(Map<String, dynamic> json) => SelectedFeat(
      feat: Feat.fromJson(json['feat'] as Map<String, dynamic>),
      timesTaken: (json['timesTaken'] as num).toInt(),
    );

Map<String, dynamic> _$SelectedFeatToJson(SelectedFeat instance) =>
    <String, dynamic>{
      'feat': instance.feat,
      'timesTaken': instance.timesTaken,
    };
