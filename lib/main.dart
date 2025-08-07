import 'package:booker_front/data/repositories/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/router/app_router.dart';
import 'presentation/screens/booking_entity/bloc/booking_entity_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BookingEntityBloc>.value(
          value: BookingEntityBloc(
            BookingRepository(),
          ),
        ),
        // другие BlocProvider, если нужно
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Booker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
