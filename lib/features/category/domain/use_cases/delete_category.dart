import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/category/domain/repositories/category_repository.dart';

class DeleteCategory extends UseCase<Either, DeleteCategoryParams> {
  final CategoryRepository categoryRepository;

  DeleteCategory(this.categoryRepository);

  @override
  Future<Either> call({DeleteCategoryParams? params}) async {
    final response = await categoryRepository.deleteCategory(
      categoryId: params!.categoryId,
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

class DeleteCategoryParams {
  final String categoryId;

  DeleteCategoryParams({required this.categoryId});
}
