import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Users.dart';
import 'dart:convert';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Users CRUD',
        initialRoute: '/',
        routes: {
          '/': (context) => const Homepage(),
          '/login': (context) => const Login(),
        },
      );
}

class Homepage extends StatefulWidget {
  static const routeName = "/";
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomeState();
}

class _HomeState extends State<Homepage> {
  List<Users> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 90, 50, 150),
      ),
      drawer: SideMenu(),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(users[index].fullname!),
              subtitle: Text(users[index].email!),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  // Navigate to the edit screen with the current user data
                  final updatedUser = await Navigator.push<Users>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditUser(user: users[index]),
                    ),
                  );

                  if (updatedUser != null) {
                    setState(() {
                      users[index] = updatedUser;
                    });
                  }
                },
              ),
              onTap: () {
                // Navigate to UserInfo screen when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfo(user: users[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newUser = await Navigator.push<Users>(
            context,
            MaterialPageRoute(builder: (context) => const AddEditUser()),
          );

          if (newUser != null) {
            setState(() {
              users.add(newUser);
            });
          }
        },
        child: const Icon(Icons.person_add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 90, 50, 150),
      ),
    );
  }
}


class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String accountName = "N/A";
    String accountEmail = "N/A";
    String accountUrl =
        "https://scontent-bkk1-2.xx.fbcdn.net/v/t39.30808-6/365265772_3633599600246280_1457981737915636914_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEoXt-WLQYLbUJlRrFhpzRJ-4BFesFs94X7gEV6wWz3hd2jQA3hwVwULOOZtNszBvsavnyWwFw_MZ45m4tcFrIc&_nc_ohc=JYUYwNbgJv4Q7kNvgFO9JMI&_nc_ht=scontent-bkk1-2.xx&_nc_gid=A2ypkMkA8I6Avsc9gRZTBkw&oh=00_AYBKhVNthfUkSReok2_rTEr_opqY1lTmkp1rSlTbf5C5tw&oe=66D3A551";
    Users user = Configure.login;
    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, Homepage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Login"),
            onTap: () {
              Navigator.pushNamed(context, Login.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class Configure {
  static String server = "172.16.42.241:3000";
  static List<String> gender = ["None", "Male", "Female", "Other"];
  static Users login = Users();
}

class Login extends StatefulWidget {
  static const routeName = "/login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Users user = Users();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textHeader(),
              emailInputField(),
              passwordInputField(),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  submitButton(),
                  const SizedBox(width: 10.0),
                  backButton(),
                  const SizedBox(width: 10.0),
                  registerLink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textHeader() {
    return const Text(
      "Login",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: "a@test.com",
      decoration: const InputDecoration(
        labelText: "Email:",
        icon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Invalid email format";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: "1a2a3a",
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password:",
        icon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue,
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          print("User: ${user.toJson()}");
          login(user, context); // Pass context here
        }
      },
      child: const Text("Login"),
    );
  }

  Widget backButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Back"),
    );
  }

  Widget registerLink() {
    return InkWell(
      child: const Text("Sign Up"),
      onTap: () {},
    );
  }

  Future<void> login(Users user, BuildContext context) async {
    var url = Uri.parse('http://${Configure.server}/Users');

    try {
      var response = await http.get(url);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        print("Users from server: $users");

        var loggedInUser = users.firstWhere(
          (u) => u['email'] == user.email && u['password'] == user.password,
          orElse: () => null,
        );

        print("LoggedInUser: $loggedInUser");

        if (loggedInUser != null) {
          Configure.login = Users.fromJson(loggedInUser);
          Navigator.pushReplacementNamed(context, Homepage.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: ${response.statusCode} - ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error: Unable to connect to server")),
      );
    }
  }
}

List<Users> _userList = [];

Future<void> getUsers() async {
  var url = Uri.http(Configure.server, "users");
  var resp = await http.get(url);
}

class UserInfo extends StatelessWidget {
  final Users user;
  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          child: ListView(
            children: [
              ListTile(
                title: const Text("Full Name"),
                subtitle: Text(user.fullname ?? "N/A"),
              ),
              ListTile(
                title: const Text("Email"),
                subtitle: Text(user.email ?? "N/A"),
              ),
              ListTile(
                title: const Text("Gender"),
                subtitle: Text(user.gender ?? "N/A"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddEditUser extends StatefulWidget {
  final Users? user;

  const AddEditUser({this.user, Key? key}) : super(key: key);

  @override
  State<AddEditUser> createState() => _AddEditUserState();
}

class _AddEditUserState extends State<AddEditUser> {
  final _formKey = GlobalKey<FormState>();
  late Users _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user ?? Users();
  }

  Widget buildInputField(String label, String? initialValue, Function(String?) onSave, IconData icon) {
    return Focus(
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return TextFormField(
            initialValue: initialValue,
            obscureText: label == 'Password' ? true : false, // ซ่อน password โดยไม่มีไอคอน
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: isFocused ? const Color.fromRGBO(104,80,163,255) : Colors.grey),
              prefixIcon: Icon(icon, color: isFocused ? const Color.fromRGBO(104,80,163,255) : Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color.fromRGBO(104,80,163,255)),
              ),
            ),
            onSaved: onSave,
          );
        },
      ),
    );
  }

  Widget buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _user.gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.person, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(104,80,163,255)),
        ),
      ),
      items: ['None', 'Male', 'Female']
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: (value) => setState(() {
        _user.gender = value;
      }),
    );
  }

  Future<void> saveUser() async {
    _formKey.currentState?.save();
    Navigator.pop(context, _user); // ส่งข้อมูลผู้ใช้กลับไปยังหน้าหลัก
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Form',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 111, 42, 164),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField('Full Name', _user.fullname, (value) => _user.fullname = value, Icons.person),
              buildInputField('Email', _user.email, (value) => _user.email = value, Icons.email),
              buildInputField('Password', _user.password, (value) => _user.password = value, Icons.lock),
              buildGenderField(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(104,80,163,255),
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class UserForm extends StatefulWidget {
//   const UserForm({super.key});

//   @override
//   State<UserForm> createState() => _UserFormState();
// }

// class _UserFormState extends State<UserForm> {
//   final _formKey = GlobalKey<FormState>();
//   late Users user;

//   @override
//   Widget build(BuildContext context) {
//     try {
//       user = ModalRoute.of(context)!.settings.arguments as Users;
//       print(user.fullname);
//     } catch (e) {
//       user = Users();
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Form"),
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(10),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               fnameInputField(),
//               emailInputField(),
//               passwordInputField(),
//               genderFormInput(),
//               const SizedBox(
//                 height: 10,
//               ),
//               submitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget fnameInputField() {
//     return TextFormField(
//       initialValue: user.fullname,
//       decoration: const InputDecoration(
//         labelText: "Fullname",
//         icon: Icon(Icons.person),
//       ),
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "This field is required";
//         }
//         return null;
//       },
//       onSaved: (newValue) => user.fullname = newValue,
//     );
//   }

//   Widget emailInputField() {
//     return TextFormField(
//       initialValue: user.email,
//       decoration: const InputDecoration(
//         labelText: "Email",
//         icon: Icon(Icons.email),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "This field is required";
//         }
//         return null;
//       },
//       onSaved: (newValue) => user.email = newValue,
//     );
//   }

//   Widget passwordInputField() {
//     return TextFormField(
//       initialValue: user.password,
//       obscureText: true,
//       decoration: const InputDecoration(
//         labelText: "Password",
//         icon: Icon(Icons.lock),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "This field is required";
//         }
//         return null;
//       },
//       onSaved: (newValue) => user.password = newValue,
//     );
//   }

//   Widget submitButton() {
//     return ElevatedButton(
//       onPressed: () {
//         if (_formKey.currentState!.validate()) {
//           _formKey.currentState!.save();
//           print(user.toJson().toString());
//           if (user.id == null) {
//             addNewUser(user);
//           } else {
//             updateData(user);
//           }
//         }
//       },
//       child: const Text("Save"),
//     );
//   }

//   Widget genderFormInput() {
//     var initGen = "None";
//     try {
//       if (user.gender != null) {
//         initGen = user.gender!;
//       }
//     } catch (e) {
//       initGen = "None";
//     }
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(
//         labelText: "Gender",
//         icon: Icon(Icons.person),
//       ),
//       value: initGen,
//       items: Configure.gender.map((String val) {
//         return DropdownMenuItem(
//           value: val,
//           child: Text(val),
//         );
//       }).toList(),
//       onChanged: (String? value) {
//         setState(() {
//           user.gender = value;
//         });
//       },
//       onSaved: (newValue) => user.gender = newValue,
//     );
//   }

//   Future<void> addNewUser(Users user) async {
//     var url = Uri.http(Configure.server, "users");
//     var resp = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(user.toJson()),
//     );
//     var rs = usersFromJson("[${resp.body}]");
//     if (rs.length == 1) {
//       Navigator.pop(context, "refresh");
//     }
//   }

//   Future<void> updateData(Users user) async {
//     var url = Uri.http(Configure.server, "user/${user.id}");
//     var resp = await http.put(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(user.toJson()),
//     );
//     var rs = usersFromJson("[${resp.body}]");
//     if (rs.length == 1) {
//       Navigator.pop(context, "refresh");
//     }
//   }
// }