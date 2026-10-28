import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/screen/auth_services.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/signup_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<bool> _signIn() async {
    final String input = _email.text.trim();
    final String password = _password.text;

    if (input.isEmpty || password.isEmpty) {
      _showErrorDialog("Username/Email atau Password tidak boleh kosong.");
      return false;
    }

    final String email = input.contains('@')
        ? input
        : '${input.replaceAll(' ', '').toLowerCase()}@shadowpost.com';

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        return true;
      } else {
        _showErrorDialog("Email atau Password salah. Silahkan coba lagi.");
        return false;
      }
    } catch (e) {
      _showErrorDialog("Terjadi kesalahan: $e");
      return false;
    }
  }

  Future<void> getUserID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await for (var authState in auth.authStateChanges()) {
      if (authState != null) {
        globals.uid = authState.uid;
        break;
      }
    }
  }

  String _generateRandomName() {
    final random = Random();
    const List<String> prefixes = ['Anon', 'User', 'Guest', 'Visitor'];
    const List<String> suffixes = ['123', '456', '789', 'abc', 'def'];
    return '${prefixes[random.nextInt(prefixes.length)]}${suffixes[random.nextInt(suffixes.length)]}';
  }

  Future<void> getNamaUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await for (var authState in auth.authStateChanges()) {
      if (authState != null) {
        try {
          DocumentSnapshot snap =
              await _usersCollection.doc(authState.uid).get();
          if (snap.exists) {
            final data = snap.data() as Map<String, dynamic>;
            if (data.containsKey('name')) globals.nama = data['name'];
            if (data.containsKey('url')) globals.url = data['url'];
          } else {
            String randomName = _generateRandomName();
            globals.nama = randomName;
            await _usersCollection.doc(authState.uid).set({'name': randomName});
          }
        } catch (e) {
          debugPrint('Error: $e');
        }
        break;
      }
    }
  }

  Future<void> tunggu() async {
    setState(() => _isLoading = true);
    bool success = await _signIn();
    if (success) {
      await getUserID();
      await getNamaUser();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Login Gagal",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Color(0xFF8F94FB),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String googleSvg = '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18">
      <path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.66-5.17 3.66-9.17z"/>
      <path fill="#34A853" d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.1-6.72-4.93H1.25v3.15C3.26 21.36 7.34 24 12 24z"/>
      <path fill="#FBBC05" d="M5.28 14.27c-.25-.72-.38-1.49-.38-2.27s.13-1.55.38-2.27V6.58H1.25C.45 8.18 0 9.97 0 12s.45 3.82 1.25 5.42l4.03-3.15z"/>
      <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.34 0 3.26 2.64 1.25 6.58l4.03 3.15c.95-2.83 3.6-4.98 6.72-4.98z"/>
    </svg>
    ''';

    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      body: Stack(
        children: [
          // ── Subtle Top Right Ambient Glow ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x8C262038),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── App Logo (Centered & Bigger) ──
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Headline ──
                      const Text(
                        "Login to Shadow Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Label: Email or Username ──
                      const Text(
                        "Username or Email",
                        style: TextStyle(
                          color: Color(0xFFC0C4CC),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ── Input: Email or Username ──
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1C22),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF272932),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: "username atau nama@email.com",
                            hintStyle: TextStyle(
                              color: Color(0xFF8E929E),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // ── Label: Password ──
                      const Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xFFC0C4CC),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ── Input: Password ──
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1C22),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF272932),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18,
                        vertical:15),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _password,
                          obscureText: _isPasswordObscured,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            hintStyle: const TextStyle(
                              color: Color(0xFF8E929E),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isCollapsed: true,
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF7A7E85),
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordObscured = !_isPasswordObscured;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Forget Password Link ──
                      GestureDetector(
                        onTap: () {
                          _showErrorDialog(
                            "Silakan hubungi administrator untuk mengatur ulang kata sandi Anda.",
                          );
                        },
                        child: const Text(
                          "Forget Password",
                          style: TextStyle(
                            color: Color(0xFF7A7E85),
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF7A7E85),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),

                      // ── Primary Button: Login ──
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF282A36),
                                Color(0xFF1E202A),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF383B48),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x4D000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _isLoading ? null : tunggu,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // ── Social Login: Google ──
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF16171C),
                            side: const BorderSide(
                              color: Color(0xFF23252E),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            _showErrorDialog(
                              "Login dengan Google akan segera tersedia.",
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.string(
                                googleSvg,
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Login with Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Social Login: Apple ──
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF16171C),
                            side: const BorderSide(
                              color: Color(0xFF23252E),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            _showErrorDialog(
                              "Login dengan Apple akan segera tersedia.",
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.apple,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Login with Apple",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Bottom Signup Link ──
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "New user? ",
                              style: TextStyle(
                                color: Color(0xFF7A7E85),
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Signup",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}