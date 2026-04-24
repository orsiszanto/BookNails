import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/services/service_list_screen.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/error/error_screen.dart';
import 'bloc/cubit/auth_cubit.dart';
import 'bloc/cubit/category_cubit.dart';
import 'bloc/cubit/service_cubit.dart';
import 'bloc/cubit/appointment_cubit.dart';
import 'bloc/cubit/user_cubit.dart';
import 'bloc/cubit/nail_artist_profile_cubit.dart';
import 'services/auth_service.dart';
import 'services/category_service.dart';
import 'services/service_service.dart';
import 'services/appointment_service.dart';
import 'services/user_service.dart';
import 'services/nail_artist_profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(CategoryService()),
        ),
        BlocProvider(
          create: (context) => ServiceCubit(ServiceService()),
        ),
        BlocProvider(
          create: (context) => AppointmentCubit(AppointmentService()),
        ),
        BlocProvider(
          create: (context) => UserCubit(UserService()),
        ),
        BlocProvider(
          create: (context) => NailArtistProfileCubit(NailArtistProfileService()),
        ),
      ],
      child: MaterialApp.router(
        title: 'BookNails',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: _router,
      ),
    );
  }
}

// Routing configuration
final GoRouter _router = GoRouter(
  initialLocation: '/login',
  errorBuilder: (context, state) => ErrorScreen(
    message: 'Útvonal nem található: ${state.uri.toString()}',
  ),
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/registration',
      name: 'registration',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/services',
      name: 'services',
      builder: (context, state) => const ServiceListScreen(),
    ),
    GoRoute(
      path: '/booking/:serviceId',
      name: 'booking',
      builder: (context, state) => BookingScreen(
        serviceId: state.pathParameters['serviceId'],
      ),
    ),
  ],
);

/// Bottom Navigation táb kontroller demonstration
class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ServiceListScreen(),
    BookingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Főoldal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: 'Szolgáltatások',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Foglalás',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
