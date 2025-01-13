import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_flutter/models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onInit(){
    super.onInit();
    openBox();
  }

  //Open Hive Database of todoTasks box
  void openBox() async {
    var box = await Hive.openBox<Task>('todoTasks');
    taskList.addAll(box.values);
  }

  //add task to Hive Database
  void addTask(Task task) async {
    var box = Hive.box<Task>('todoTasks');
    await box.add(task);
    taskList.add(task);
  }

  //delete task to Hive Database
  void deleteTask(int index) async {
    var box = Hive.box<Task>('todoTasks');
    box.deleteAt(index);
    taskList.removeAt(index);
  }

  //edit task to Hive Database
  void editTask(int index, Task newTask) async {
    var box = Hive.box<Task>('todoTasks');
    box.putAt(index, newTask);
    taskList[index] = newTask;
  }

  //toggle task completion status
  void toggleTaskCompletion(int index) {
    taskList[index].isCompleted = !taskList[index].isCompleted;
    taskList.refresh();
  }
}