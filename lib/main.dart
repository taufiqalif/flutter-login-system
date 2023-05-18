import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            textStyle: const TextStyle(fontSize: 18),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.blue,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: const Login(title: 'Login App'),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool isLoggedIn = false;
  String loggedInUserName = '';

  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController registerUsernameController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  List<RegisteredUser> registeredUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: isLoggedIn ? _buildLoggedInScreen() : _buildLoginScreen(),
    );
  }

  Widget _buildLoggedInScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selamat datang, $loggedInUserName!',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoggedIn = false;
                loggedInUserName = '';
              });
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Form(
      key: _loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(
            //   'https://via.placeholder.com/150',
            //   width: 150,
            //   height: 150,
            //   fit: BoxFit.contain,
            // ),

            Icon(Icons.account_circle, size: 50 , color: Colors.blue, ),

            const SizedBox(height: 32),
            TextFormField(
              controller: loginEmailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: loginPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  if (isUserRegistered(
                      loginEmailController.text, loginPasswordController.text)) {
                    setState(() {
                      isLoggedIn = true;
                      loggedInUserName = getUserName(loginEmailController.text);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid login credentials'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Register'),
                    content: Form(
                      key: _registerFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: registerUsernameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Username",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: registerEmailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: registerPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          if (_registerFormKey.currentState!.validate()) {
                            registerUser(
                              registerUsernameController.text,
                              registerEmailController.text,
                              registerPasswordController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registration successful'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }

  bool isUserRegistered(String email, String password) {
    for (var user in registeredUsers) {
      if (user.email == email && user.password == password) {
        return true;
      }
    }
    return false;
  }

  void registerUser(String username, String email, String password) {
    registeredUsers.add(RegisteredUser(
      username: username,
      email: email,
      password: password,
    ));
  }

  String getUserName(String email) {
    for (var user in registeredUsers) {
      if (user.email == email) {
        return user.username;
      }
    }
    return '';
  }
}

class RegisteredUser {
  final String username;
  final String email;
  final String password;

  RegisteredUser({
    required this.username,
    required this.email,
    required this.password,
  });
}
