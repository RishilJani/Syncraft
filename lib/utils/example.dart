import 'import_export.dart';
import 'circular_indicator_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Circular Loading Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fetch Tasks")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => controller.fetchTasks(),
          child: const Text("Fetch from API"),
        ),
      ),
    );
  }
}
