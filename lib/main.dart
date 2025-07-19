import 'package:syncraft/member/dashboard/dashboard_view.dart';
import 'package:syncraft/utils/import_export.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: MemberDashboardView(memberId: 1,memberName: "Harsh", teamName: "Tech wizards", currentProject: MemberProject(id: 17, name: "Hackathon", description: "Converstech", totalTasks: 10, completedTasks: 5),),
      home: MemberDashboardView(memberId: 1, memberName: "Harsh",),
    );
  }
}
