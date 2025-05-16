import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/category/data/data_sources/category_remote_datasource.dart';
import 'package:expense_tracker_app/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository{
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

}