import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  final usersBox = Hive.box<UserModel>('users');

  if (usersBox.isEmpty) {
    usersBox.add(UserModel(id: 1, name: 'Ahmed Ali', email: 'ahmed@gmail.com'));

    usersBox.add(
      UserModel(id: 2, name: 'Sara Mohamed', email: 'sara@gmail.com'),
    );

    usersBox.add(UserModel(id: 3, name: 'John Smith', email: 'john@gmail.com'));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Users',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usersBox = Hive.box<UserModel>('users');

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),

      body: ListView.builder(
        itemCount: usersBox.length,
        itemBuilder: (context, index) {
          final user = usersBox.getAt(index)!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text(user.id.toString())),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.email),
            ),
          );
        },
      ),
    );
  }
}
