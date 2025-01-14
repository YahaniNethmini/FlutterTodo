import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_flutter/controllers/task_controller.dart';
import 'package:todo_flutter/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {

  final Task? task;
  final int? index;

  const AddTaskScreen({super.key, this.task, this.index});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final TaskController taskController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if(widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.task != null
            ? "Edit Task"
            : "Add New Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Title",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter Task Title",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Task Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter Task Description",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Due Date",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            TextButton.icon(
                label: Text(selectedDate == null
                    ? "Select Due Date"
                    : '${selectedDate!.toLocal()}'.split(' ')[0]),
              icon: Icon(
                Icons.calendar_month_rounded,
                color: Colors.deepPurple,
              ),
              onPressed: () async {
                  selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                  );
                  setState(() {});
              }
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(widget.task != null
                    ? "Edit Task"
                    : "Add Task",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  if(titleController.text.isEmpty || descriptionController.text.isEmpty || selectedDate == null){
                    Get.snackbar(
                      "Error", "Please fill all the fields",
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white
                    );
                    return;
                  }

                  //edit/update
                  if(widget.task != null){
                    var updatedTask = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: selectedDate!,
                      isCompleted: widget.task!.isCompleted,
                    );
                    taskController.editTask(widget.index!, updatedTask);
                    Get.back();
                    Get.snackbar("Success", "Task Updated Successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    //add new task
                    var newTask = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: selectedDate!,
                    );
                    taskController.addTask(newTask);
                    Get.back();
                    Get.snackbar("Success", "Task Added Successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
