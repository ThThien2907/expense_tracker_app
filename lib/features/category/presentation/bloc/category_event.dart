part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
}

final class CategoryStarted extends CategoryEvent {
  final Completer<void>? completer;

  const CategoryStarted({this.completer});

  @override
  List<Object?> get props => [completer];
}

final class CategoryAdded extends CategoryEvent {
  final String name;
  final String iconName;
  final String color;
  final int type;

  const CategoryAdded({
    required this.name,
    required this.iconName,
    required this.color,
    required this.type,
  });

  @override
  List<Object?> get props => [name, iconName, color, type];
}

final class CategoryEdited extends CategoryEvent {
  final String categoryId;
  final String name;
  final String iconName;
  final String color;
  final Bloc transactionBloc;
  final Bloc budgetBloc;

  const CategoryEdited({
    required this.categoryId,
    required this.name,
    required this.iconName,
    required this.color,
    required this.transactionBloc,
    required this.budgetBloc,
  });

  @override
  List<Object?> get props => [categoryId, name, iconName, color, transactionBloc, budgetBloc];
}

final class CategoryRemoved extends CategoryEvent {
  final String categoryId;
  final Bloc transactionBloc;
  final Bloc budgetBloc;
  final Bloc walletBloc;

  const CategoryRemoved({
    required this.categoryId,
    required this.transactionBloc,
    required this.budgetBloc,
    required this.walletBloc,
  });

  @override
  List<Object?> get props => [categoryId, transactionBloc, budgetBloc, walletBloc];
}

final class ClearCategories extends CategoryEvent {

  @override
  List<Object?> get props => [];
}
