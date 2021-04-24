import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  MarkerCubit() : super(MarkerInitial());
}
