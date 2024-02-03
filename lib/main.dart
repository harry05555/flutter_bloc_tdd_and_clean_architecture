import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/services/injection_container.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/presentation/views/home_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => servicelocatorSL<AuthenticationCubit>(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
