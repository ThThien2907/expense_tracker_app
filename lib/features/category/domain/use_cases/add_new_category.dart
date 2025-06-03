import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/category/domain/repositories/category_repository.dart';

class AddNewCategory extends UseCase<Either, AddNewCategoryParams> {
  final CategoryRepository categoryRepository;

  AddNewCategory(this.categoryRepository);

  @override
  Future<Either> call({AddNewCategoryParams? params}) async {
    final response = await categoryRepository.addNewCategory(
      name: params!.name,
      iconName: params.iconName,
      color: params.color,
      type: params.type,
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

class AddNewCategoryParams {
  final String name;
  final String iconName;
  final String color;
  final int type;

  AddNewCategoryParams({
    required this.name,
    required this.iconName,
    required this.color,
    required this.type,
  });
}
