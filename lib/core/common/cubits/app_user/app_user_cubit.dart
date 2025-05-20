import 'package:expense_tracker_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppUserCubit extends Cubit<UserEntity?> {
  AppUserCubit() : super(null);

  setUser(UserEntity userEntity) => emit(userEntity);
  clearUser() => emit(null);
}
