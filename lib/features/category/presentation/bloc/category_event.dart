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
