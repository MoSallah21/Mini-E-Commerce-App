// ==========================
// HomePage Widget
// Checks authentication & profile completion
// ==========================
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/products/presentation/pages/all_products_page.dart';
import '../features/profile/data/datasources/profile_local_datasource.dart';
import '../features/profile/presentation/pages/add_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthLocalDatasource authLocalDatasource;
  late ProfileLocalDatasource profileLocalDatasource;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize local datasources for auth & profile
    authLocalDatasource = AuthLocalDatasourceImp(
      secureStorage: const FlutterSecureStorage(),
    );
    profileLocalDatasource = ProfileLocalDatasourceImp();

    // Check user authentication & profile
    _checkAuthenticationStatus();
  }

  // ==========================
  // Authentication & Profile Check
  // ==========================
  Future<void> _checkAuthenticationStatus() async {
    try {
      // Check if auth token exists
      final token = await authLocalDatasource.getAuthToken();

      if (token.isEmpty) {
        _navigateToLogin();
        return;
      }

      // Check if user profile exists
      try {
        final user = profileLocalDatasource.getCachedUser();

        if (user.fullName != null && user.fullName!.isNotEmpty) {
          _navigateToAllProducts(); // Profile complete
        } else {
          _navigateToAddProfile(); // Profile incomplete
        }
      } catch (e) {
        _navigateToAddProfile(); // Profile data missing
      }
    } catch (e) {
      _navigateToLogin(); // No auth token
    }
  }

  // Navigation helpers
  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _navigateToAllProducts() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AllProductsPage()),
      );
    }
  }

  void _navigateToAddProfile() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddProfilePage()),
      );
    }
  }

  // ==========================
  // UI - Splash / Loading Screen
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo with shadow
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_cart,
                size: 60,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 30),

            // Welcome text
            Text(
              'Welcome to our store',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Status message
            Text(
              'Checking login status...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}