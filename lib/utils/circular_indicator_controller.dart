import 'import_export.dart'; // Update path if needed

class TaskController extends GetxController {
  var tasks = <String>[].obs;

  Future<void> fetchTasks() async {
    // Show loading dialog
    Get.dialog(const LoadingScreen(), barrierDismissible: false);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    tasks.assignAll(['Task 1', 'Task 2', 'Task 3']);

    // Close loading dialog
    if (Get.isDialogOpen ?? false) Get.back();

    // Optionally show a success message
    Get.snackbar("Success", "Tasks loaded!");
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.deepPurple),
              SizedBox(height: 16),
              Text("Please wait...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}