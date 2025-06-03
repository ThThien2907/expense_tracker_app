import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either> loadCategories();

  Future<Either> addNewCategory({
    required String name,
    required String iconName,
    required String color,
    required int type,
  });

  Future<Either> editCategory({
    required String categoryId,
    required String name,
    required String iconName,
    required String color,
  });

  Future<Either> deleteCategory({
    required String categoryId,
  });
}