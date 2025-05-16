class CategoryEntity {
  final String categoryId;
  final String name;
  final String iconName;
  final String userId;
  final String color;
  final int type;
  final DateTime createdAt;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.iconName,
    required this.userId,
    required this.color,
    required this.type,
    required this.createdAt,
  });
}
