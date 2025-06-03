import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/category/domain/repositories/category_repository.dart';

class EditCategory extends UseCase<Either, EditCategoryParams> {
  final CategoryRepository categoryRepository;

  EditCategory(this.categoryRepository);

  @override
  Future<Either> call({EditCategoryParams? params}) async {
    final response = await categoryRepository.editCategory(
      categoryId: params!.categoryId,
      name: params.name,
      iconName: params.iconName,
      color: params.color,
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

class EditCategoryParams {
  final String categoryId;
  final String name;
  final String iconName;
  final String color;

  EditCategoryParams({
    required this.categoryId,
    required this.name,
    required this.iconName,
    required this.color,
  });
}
