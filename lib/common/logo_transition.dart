import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';

class LogoTransition extends StatefulWidget {
  final Widget nextPage;

  const LogoTransition({super.key, required this.nextPage});

  @override
  State<LogoTransition> createState() => _LogoTransitionState();
}

class _LogoTransitionState extends State<LogoTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            opaque: false, // 👈 مهم جدًا لجعل الخلفية شفافة
            barrierColor: Colors.transparent, // 👈 إزالة لون الخلفية تمامًا
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => widget.nextPage,
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: anim,
              child: child,
            ),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite, // 👈 شفافية كاملة
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
           "assets/images/logo2.png", // 🟡 عدّل المسار حسب شعارك
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
