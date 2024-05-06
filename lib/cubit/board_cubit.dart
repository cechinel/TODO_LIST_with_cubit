import 'package:bloc/bloc.dart';
import 'package:todo/repositories/board_repository.dart';
import 'package:todo/states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (_) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> addTasks() async {}

  Future<void> removeTasks() async {}

  Future<void> checkTasks() async {}
}
