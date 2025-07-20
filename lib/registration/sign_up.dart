import '../utils/import_export.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  var mp = Get.arguments;
  late RegistrationController registrationController;

  final double _formFieldSpacing = 20.0;
  final double _sectionSpacing = 30.0;
  @override
  void initState() {
    super.initState();
    registrationController = RegistrationController(username: mp?[USER_EMAIL], password: mp?[USER_PASSWORD]);

  }

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      APIHandler apiHandler = APIHandler();
      mp[USER_NAME] = registrationController.username;
      mp[ADMIN_ID] = registrationController.adminID;

      Map<String,dynamic> mapID = await apiHandler.getSignUpData(mp);
      if(mapID["id"] == null){
        Get.back();
      }
      else{
        if (mp[USER_ROLE] == "admin") {
          Get.toNamed(RT_ADMIN_DASHBOARD, arguments: mapID);
        }
        else if (mp[USER_ROLE] == "manager") {
          Get.toNamed(RT_MANAGER_DASHBOARD, arguments: mapID);
        }
        else {
          Get.toNamed(RT_MEMBER_DASHBOARD, arguments: mapID);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
              'Registration attempt for ${registrationController.username}...'),
          duration: const Duration(seconds: 2),
        ),);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // App Logo (Optional, but professional)
                  // FlutterLogo(size: 80, style: FlutterLogoStyle.markOnly),
                  // SizedBox(height: _sectionSpacing * 1.5),

                  Text(
                    "Profile Details",
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: _formFieldSpacing / 2),

                  // username
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      hintText: 'harsh parmar',
                      prefixIcon: Icon(Icons.person, color: theme.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    style: textTheme.bodyLarge,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'User name is required.';
                      }
                      return null;
                    },
                    onChanged: (value) => registrationController.username = value,
                  ),
                  SizedBox(height: _formFieldSpacing),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Admin ID',
                      hintText: "Enter your admins id",
                      prefixIcon: Icon(FontAwesomeIcons.idCard,
                          color: theme.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    style: textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'admin ID is required.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>  registrationController.adminID = value,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: _sectionSpacing),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          theme.primaryColor, // Background color of the button
                      foregroundColor: theme
                          .colorScheme.onPrimary, // <<< THIS IS THE TEXT COLOR
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0), // Added horizontal padding
                      textStyle: textTheme.titleMedium?.copyWith(
                        // color: theme.colorScheme.onPrimary, // We set foregroundColor directly, so this can be removed or kept for font weight/size
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // You can adjust font size here if needed
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                      minimumSize: const Size(double.infinity,
                          50), // Ensure button takes full width and has a good height
                    ),
                    child: const Text('Register'), // Or "Register"
                  ),
                  SizedBox(height: _formFieldSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
