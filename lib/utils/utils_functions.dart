import 'package:syncraft/utils/import_export.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Get.offAllNamed(RT_LOGIN_REGISTRATION_PAGE); // Clears all and routes to login
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}