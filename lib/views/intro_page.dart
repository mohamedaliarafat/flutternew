import 'package:flutter/material.dart';
import 'package:foodly/views/auth/PhoneInputScreen.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'entrypoint.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // 🎬 أنميشن اللوجو
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 🌈 أنميشن الخلفية
    _color1 = ColorTween(
      begin: const Color(0xFF004481),
      end: const Color(0xFF0074A6),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _color2 = ColorTween(
      begin: const Color(0xFF002D62),
      end: const Color(0xFF00AEEF),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);

    // 🎵 تشغيل الصوت
    // _playMusic();

    // ⏱️ الانتقال بعد الأنميشن
    Future.delayed(const Duration(seconds: 8), () async {
      await _player.stop();
      Get.off(() => MainScreen());
    });
  }

  // Future<void> _playMusic() async {
  //   await _player.play(AssetSource('audio/intro.mp3'));
  // }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _color1.value ?? Colors.blue,
                  _color2.value ?? Colors.lightBlueAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 190,
                        height: 190,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
