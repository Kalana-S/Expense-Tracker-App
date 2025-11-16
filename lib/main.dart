import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/expense_model.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';

void main() async {
  // Ensure Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the Expense adapter
  Hive.registerAdapter(ExpenseAdapter());

  // Open the expenses box
  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-expense': (context) => const AddExpenseScreen(),
      },
    );
  }
}
