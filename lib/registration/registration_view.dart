import 'package:syncraft/utils/import_export.dart';
// enum UserRole { admin, projectManager, teamMember }

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  RegistrationController registrationController = RegistrationController();
  @override
  void initState() {
    super.initState();
    Get.put(registrationController);
  }
  // bool isLogin = true;
  // String _email = '';
  // String _password = '';
  // UserRole? _selectedRole = UserRole.admin;
  // bool _rememberMe = false;

  // String heading = 'Welcome Back!';
  // bool isVisible = true;

  // Define consistent spacing
  String heading = 'Welcome Back!';
  bool isVisible = true;

  final double _formFieldSpacing = 20.0;
  final double _sectionSpacing = 30.0;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // --- Your Authentication Logic Here ---


      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text('Login attempt for ${registrationController.email}...'),
          duration: const Duration(seconds: 2),
        backgroundColor: Colors.greenAccent,
        ),);

      Get.toNamed(RT_TEMP_PAGE);

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
    // Get theme for consistent styling
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea( // Ensures content is not obscured by system UI (notches, etc.)
        child: Center( // Center the form vertically
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                    heading,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: _formFieldSpacing / 2),

                  Text(
                    'Please sign in to continue.', // Or "Fill in the details below."
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: _sectionSpacing * 1.5),

                  // Email Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.alternate_email, color: theme.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    style: textTheme.bodyLarge,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email address is required.';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) => registrationController.email = value!,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: _formFieldSpacing),

                  // Password Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline, color: theme.primaryColor),
                      suffixIcon: IconButton(onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      }, icon: Icon( isVisible ?  Icons.visibility : Icons.visibility_off)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    style: textTheme.bodyLarge,
                    obscureText: isVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required.';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) => registrationController.password = value!,
                    textInputAction: TextInputAction.done, // For better keyboard navigation
                    onFieldSubmitted: (_) => _submitForm(), // Submit on keyboard done
                  ),
                  SizedBox(height: _sectionSpacing),

                  // User Role Radio Buttons in a Single Row
                  Text(
                    'Select Your Role:',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: _formFieldSpacing / 2),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space evenly
                    children: UserRole.values.map((role) {
                      return Expanded( // Allows each radio button option to take available space
                        child: InkWell( // Makes the whole area tappable
                          onTap: () {
                            setState(() {
                              registrationController.selectedRole = role;
                            });
                          },
                          borderRadius: BorderRadius.circular(8.0), // Optional: for tap feedback
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // So the Row doesn't expand unnecessarily
                              children: <Widget>[
                                Radio<UserRole>(
                                  value: role,
                                  groupValue: registrationController.selectedRole,
                                  onChanged: (UserRole? value) {
                                    setState(() {
                                      registrationController.selectedRole = value;
                                    });
                                  },
                                  activeColor: theme.primaryColor,
                                  visualDensity: VisualDensity.compact, // Makes radio button smaller
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap area slightly
                                ),
                                Flexible( // Allows text to wrap if needed, though unlikely for short role names
                                  child: Text(
                                    _getRoleString(role),
                                    style: textTheme.bodyMedium, // Adjusted for potentially smaller space
                                    overflow: TextOverflow.ellipsis, // Handle overflow if text is too long
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: _formFieldSpacing),

                  // Remember Me Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: registrationController.rememberMe,
                        onChanged: (bool? value) {
                          setState(() => registrationController.rememberMe = value!);
                        },
                        activeColor: theme.primaryColor,
                        visualDensity: VisualDensity.compact, // More compact
                      ),
                      GestureDetector( // Makes the text clickable too
                        onTap: () {
                          setState(() => registrationController.rememberMe = !registrationController.rememberMe);
                        },
                        child: Text(
                          'Remember me',
                          style: textTheme.bodyLarge?.copyWith(color: Colors.grey[800]),
                        ),
                      ),
                      const Spacer(), // Pushes "Forgot Password" to the right

                      /*
                      TextButton for forget password
                      TextButton(
                        onPressed: () {
                          // Handle "Forgot Password"
                          print('Forgot Password Tapped');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
                        ),
                      ),
                      */

                    ],
                  ),
                  SizedBox(height: _sectionSpacing * 1.5),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor, // Background color of the button
                      foregroundColor: theme.colorScheme.onPrimary, // <<< THIS IS THE TEXT COLOR
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Added horizontal padding
                      textStyle: textTheme.titleMedium?.copyWith(
                        // color: theme.colorScheme.onPrimary, // We set foregroundColor directly, so this can be removed or kept for font weight/size
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // You can adjust font size here if needed
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                      minimumSize: const Size(double.infinity, 50), // Ensure button takes full width and has a good height
                    ),
                    child: Text(registrationController.isLogin ? 'Login ': 'Register'), // Or "Register"
                  ),
                  SizedBox(height: _formFieldSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                       registrationController.isLogin ?  "Don't have an account?" : "Already have an account?",
                        style: textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to registration page or toggle form type
                          print(!registrationController.isLogin ? 'Sign Up' : "Login");
                          setState(() {
                            registrationController.isLogin = !registrationController.isLogin;
                            heading = registrationController.isLogin ? "Welcome Back!" : 'Welcome To Syncraft!';
                          });
                        },
                        child: Text(
                          registrationController.isLogin ? 'Sign Up' : 'Login', // Or "Sign In"
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getRoleString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.projectManager:
        return 'Manager';
      case UserRole.teamMember:
        return 'Member';
    }
  }
}
