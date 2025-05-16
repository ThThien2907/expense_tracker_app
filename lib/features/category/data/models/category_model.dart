import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {

  CategoryModel({
    required super.categoryId,
    required super.name,
    required super.iconName,
    required super.userId,
    required super.color,
    required super.type, required super.createdAt,
  });

  Map<String, dynamic> toMap() {
      return <String, dynamic>{
          'category_id': categoryId,
          'name': name,
          'icon_name': iconName,
          'user_id': userId,
          'type': type,
          'color': color,
          'created_at': createdAt,
      };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
      return CategoryModel(
          categoryId: map['category_id'] ?? '',
          name: map['name'] ?? '',
          iconName: map['icon_name'] ?? '',
          userId: map['user_id'] ?? '',
          type: map['type'] as int,
          color: map['color'],
          createdAt: DateTime.parse(map['created_at']),
      );
  }
}
