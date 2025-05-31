import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedTypeCubit extends Cubit<int>{
  SelectedTypeCubit() : super(0);

  setType(int type) => emit(type);
}