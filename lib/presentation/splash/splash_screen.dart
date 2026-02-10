import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_assets.dart';
import '../../core/routes/app_router.dart';
import '../../core/utils/app_logger.dart';
import '../../provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage(AppAssets.bg), context);
    super.didChangeDependencies();
  }

  Future<void> _navigateToNext() async {
    AppLogger.log('Splash Screen loaded, waiting...');
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    AppLogger.info(
      'Auth check: isAuthenticated = ${authProvider.isAuthenticated}',
    );

    if (authProvider.isAuthenticated) {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021400),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bg, fit: BoxFit.cover,),
          Container(color: const Color(0xFF021400).withOpacity(0.6)),
          Center(child: SvgPicture.asset(AppAssets.logoXsSvg, width: 200)),
        ],
      ),
    );
  }
}
