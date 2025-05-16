import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/category/domain/repositories/category_repository.dart';

class LoadCategories extends UseCase<Either, NoParams>{
  final CategoryRepository categoryRepository;

  LoadCategories(this.categoryRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    final response = await categoryRepository.loadCategories();
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