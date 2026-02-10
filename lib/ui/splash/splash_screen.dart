import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/routes/app_router.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/app_logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    AppLogger.log('Splash Screen loaded, waiting...');
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final hasToken = await _storageService.hasToken();
    AppLogger.info('Auth check: hasToken = $hasToken');

    if (hasToken) {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bg, fit: BoxFit.cover),
          Container(color: Color(0xFF021400).withOpacity(0.6)),
          Center(child: SvgPicture.asset(AppAssets.logoXsSvg, width: 200)),
        ],
      ),
    );
  }
}
