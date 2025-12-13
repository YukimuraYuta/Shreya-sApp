import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    // 1. FRONTEND VALIDATION
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 2. SHOW LOADING SPINNER
    setState(() => _isLoading = true);

    // ============================================================
    // TODO: BACKEND TEAM - INTEGRATE LOGIN API HERE
    // ============================================================

    // 3. SIMULATE NETWORK DELAY
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 4. HANDLE SUCCESS (For UI Demo: Always succeeds)
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login Successful!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to Home Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // --- APP BAR FIX START ---
      extendBodyBehindAppBar:
          true, // Optional: Makes body go behind AppBar for full transparent effect
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Keep transparent
        elevation: 0,
        scrolledUnderElevation: 0, // <--- THIS FIXES THE COLOR CHANGE ON SCROLL
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // --- APP BAR FIX END ---
      body: SingleChildScrollView(
        // Added padding at top so content doesn't hide behind transparent AppBar
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Hop In – Log In to Your\nRideFlow Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Access your rides, track trips, manage payments, and travel anywhere with ease.",
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              const SizedBox(height: 40),

              // Email Field
              _buildLabel("Email"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: "name@example.com",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              // Password Field
              _buildLabel("Password"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 16),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: const Color(0xFFFFC107),
                          checkColor: Colors.black,
                          side: BorderSide(color: Colors.grey[600]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Remember Me",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFFFFC107)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- LOGIN BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    disabledBackgroundColor: const Color(
                      0xFFFFC107,
                    ).withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[800])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Or",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[800])),
                ],
              ),

              const SizedBox(height: 30),

              // Social Buttons
              _buildSocialButton(
                text: "Continue with Google",
                icon: Icons.g_mobiledata,
                color: const Color(0xFF1E1E1E),
                borderColor: Colors.grey[800],
                textColor: Colors.white,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildSocialButton(
                text: "Continue with Apple",
                icon: Icons.apple,
                color: const Color(0xFF1E1E1E),
                borderColor: Colors.grey[800],
                textColor: Colors.white,
                onTap: () {},
              ),

              const SizedBox(height: 40),

              // Register Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't Have An Account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Color(0xFFFFC107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: Colors.grey[500]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Placeholder Home Screen ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("RideFlow Home"),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 100, color: Color(0xFFFFC107)),
            SizedBox(height: 20),
            Text(
              "Welcome to RideFlow!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
