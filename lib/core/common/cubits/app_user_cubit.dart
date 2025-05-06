import 'package:bloc/bloc.dart';
import 'package:expense_tracker_app/features/auth/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<UserEntity?> {
  AppUserCubit() : super(null);

  setUser(UserEntity userEntity) => emit(userEntity);
  clearUser() => emit(null);
}
