import 'package:bloc/bloc.dart';

class DashboardCubit extends Cubit<int> {
  DashboardCubit() : super(0);

  void reset() => emit(0);
  void set(index) => emit(index);
}
