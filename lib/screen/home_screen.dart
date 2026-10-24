
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/beranda.dart';

import 'package:flutter_application_1/screen/globals.dart' as globals;

import 'package:flutter_application_1/screen/pengaturan.dart';
import 'package:flutter_application_1/screen/user.dart';
import 'package:flutter_application_1/utils/assets.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const Beranda(),
    const MailScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1015),
          border: Border(
            top: BorderSide(
              color: Color(0xFF1E202B),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0F1015),
          elevation: 0,
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 0 ? homeFilledIcon : homeOutlinedIcon,
                colorFilter: ColorFilter.mode(
                  _currentIndex == 0 ? Colors.white : const Color(0xFF7A7E8C),
                  BlendMode.srcIn,
                ),
                width: 22,
                height: 22,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 1 ? envelopeFilledIcon : envelopeOutlinedIcon,
                colorFilter: ColorFilter.mode(
                  _currentIndex == 1 ? Colors.white : const Color(0xFF7A7E8C),
                  BlendMode.srcIn,
                ),
                width: 22,
                height: 22,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}


class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1015),
        elevation: 0,
        toolbarHeight: 64,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFF272932),
            width: 1,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          alignment: Alignment.center,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF272932),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                globals.url.isNotEmpty
                    ? globals.url
                    : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4cFqKLnpvsbrxezgbVAojOIRTwmEH2iDSkQ&s',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 52,
          width: 52,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Pengaturan()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1B1C22),
                  border: Border.all(
                    color: const Color(0xFF272932),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFFC0C4CC),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
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

          // ── Inbox Hero Content ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1C22),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF272932),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          color: Color(0xFFC0C4CC),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        "Welcome to your inbox!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Drop a line, share posts, and have private conversations with others on Shadow Post.",
                        style: TextStyle(
                          color: Color(0xFF7A7E85),
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
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
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const user()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_square,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            "Write a message",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Pinned Compose FAB ──
          Positioned(
            bottom: 24,
            right: 20,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF282A36),
                    Color(0xFF1E202A),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF383B48),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const user()),
                    );
                  },
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.white,
                    size: 26,
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


