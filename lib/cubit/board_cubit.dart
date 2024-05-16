import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/models/task.dart';
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

  Future<void> addTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.add(newTask);
    await emitTasks(tasks);
  }

  Future<void> removeTask(Task removedTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.remove(removedTask);
    await emitTasks(tasks);
  }

  Future<void> checkTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check!);
    await emitTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTasksBoardState(tasks: tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return null;
    }

    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }
}
