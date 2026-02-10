import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_mgt_system/presentation/auth/login_screen.dart';
import 'package:patient_mgt_system/presentation/register/register_patient_screen.dart';
import 'package:patient_mgt_system/presentation/splash/splash_screen.dart';
import 'package:patient_mgt_system/presentation/home/home_screen.dart';
import '../services/storage_service.dart';


class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String registerPatient = '/register-patient';

  static final StorageService _storageService = StorageService();

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: login,
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: home,
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const HomeScreen()),
      ),
      GoRoute(
        path: registerPatient,
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const RegisterPatientScreen(),
        ),
      ),
    ],
    redirect: (context, state) async {
      final isLoggedIn = await _storageService.hasToken();
      final currentPath = state.matchedLocation;

      if (currentPath == splash) return null;

      if (!isLoggedIn && currentPath != login) {
        return login;
      }

      if (isLoggedIn && currentPath == login) {
        return home;
      }

      return null;
    },
  );

  static CustomTransitionPage _slideTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
