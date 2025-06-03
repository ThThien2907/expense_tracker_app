import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/category/data/data_sources/category_remote_datasource.dart';
import 'package:expense_tracker_app/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource categoryRemoteDatasource;

  CategoryRepositoryImpl(this.categoryRemoteDatasource);

  @override
  Future<Either> loadCategories() async {
    final response = await categoryRemoteDatasource.loadCategories();
    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> addNewCategory({
    required String name,
    required String iconName,
    required String color,
    required int type,
  }) async {
    final response = await categoryRemoteDatasource.addNewCategory(
      name: name,
      iconName: iconName,
      color: color,
      type: type,
    );
    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> deleteCategory({required String categoryId}) async {
    final response = await categoryRemoteDatasource.deleteCategory(
      categoryId: categoryId,
    );
    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> editCategory({
    required String categoryId,
    required String name,
    required String iconName,
    required String color,
  }) async {
    final response = await categoryRemoteDatasource.editCategory(
      categoryId: categoryId,
      name: name,
      iconName: iconName,
      color: color,
    );
    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }
}
