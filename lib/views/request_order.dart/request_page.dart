// // import 'package:flutter/material.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // // 🔹 تعريف ألوان التدرج الكحلي الغامق
// // const Color _navyStart = Color(0xFF070B35); // Cetacean Blue
// // const Color _navyEnd = Color(0xFF191382); // Cadmium Blue

// // // ------------------------------------------
// // // 📄 شاشة تأكيد الطلب الجديدة (OrderSuccessScreen)
// // // ------------------------------------------
// // class OrderSuccessScreen extends StatelessWidget {
// //   const OrderSuccessScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: TextDirection.rtl,
// //       child: Scaffold(
// //         // 💡 استخدام AppBar لتضمين زر العودة بشكل احترافي
// //         appBar: AppBar(
// //           backgroundColor: Colors.transparent, // لجعل الخلفية شفافة
// //           elevation: 0,
// //           leading: IconButton(
// //             // ⬅️ استخدام أيقونة Cupertino
// //             icon: const Icon(
// //               CupertinoIcons.chevron_forward, // سهم iOS متجه لليمين
// //               color: Colors.white,
// //               size: 28,
// //             ),
// //             onPressed: () {
// //               // العودة إلى الشاشة السابقة (شاشة طلب الوقود)
// //               Navigator.pop(context);
// //             },
// //           ),
// //         ),
// //         extendBodyBehindAppBar: true, // لجعل المحتوى يمتد خلف الـ AppBar
// //         body: Container(
// //           width: double.infinity,
// //           decoration: const BoxDecoration(
// //             // 🎨 خلفية متدرجة احترافية
// //             gradient: LinearGradient(
// //               colors: [_navyStart, _navyEnd],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //           ),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               // ✨ أيقونة النجاح
// //               Icon(
// //                 Icons.check_circle_outline,
// //                 color: Colors.white,
// //                 size: 100.w,
// //               ),
// //               SizedBox(height: 20.h),
// //               Text(
// //                 "✅ تم تأكيد الطلب بنجاح!",
// //                 style: TextStyle(
// //                   fontSize: 24.sp,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               SizedBox(height: 15.h),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 40.w),
// //                 child: Text(
// //                   "تاجرنا العزيز، تم استلام طلب الوقود الخاص بك بنجاح. سنراجع التفاصيل وسنرسل لك إشعارًا بظهور صفحة الدفع قريبًا.",
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize: 15.sp,
// //                     color: Colors.white70,
// //                     height: 1.5,
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 60.h),
// //               TextButton(
// //                 onPressed: () {
// //                   // العودة إلى الشاشة الرئيسية (أول مسار في مكدس الملاحة)
// //                   Navigator.popUntil(context, (route) => route.isFirst); 
// //                 },
// //                 style: TextButton.styleFrom(
// //                   padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
// //                   backgroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10.r),
// //                   ),
// //                 ),
// //                 child: Text(
// //                   "العودة إلى الصفحة الرئيسية",
// //                   style: TextStyle(
// //                     color: _navyEnd,
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 16.sp,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // // ------------------------------------------
// // // 🔹 حركة انتقال مخصصة (Slide Transition)
// // // ------------------------------------------
// // Route _createRoute() {
// //   return PageRouteBuilder(
// //     pageBuilder: (context, animation, secondaryAnimation) => const OrderSuccessScreen(),
// //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //       const begin = Offset(0.0, 1.0); // يبدأ من الأسفل
// //       const end = Offset.zero; // ينتهي في المنتصف
// //       const curve = Curves.easeOutCubic; // منحنى انزلاق ناعم

// //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

// //       return SlideTransition(
// //         position: animation.drive(tween),
// //         child: child,
// //       );
// //     },
// //     transitionDuration: const Duration(milliseconds: 600), // مدة أطول لحركة أكثر جمالاً
// //   );
// // }


// // // ------------------------------------------
// // // ⛽ الصفحة الرئيسية (OrderWaterPage)
// // // ------------------------------------------
// // class OrderWaterPage extends StatefulWidget {
// //   const OrderWaterPage({super.key});

// //   @override
// //   State<OrderWaterPage> createState() => _OrderWaterPageState();
// // }

// // class _OrderWaterPageState extends State<OrderWaterPage> {
// //   // ⛽ حقول الوقود
// //   String? selectedFuelType;
// //   int? selectedFuelLiters;
// //   final TextEditingController _notesController = TextEditingController();

// //   final List<String> fuelOptions = [
// //     "بنزين 91",
// //     "بنزين 95",
// //     "ديزل",
// //     "كيروسين"
// //   ];

// //   final List<int> fuelLitersOptions = [
// //     20000,
// //     32000,
// //   ];
  
// //   final GlobalKey<FormState> _fuelFormKey = GlobalKey<FormState>();

// //   @override
// //   void dispose() {
// //     _notesController.dispose();
// //     super.dispose();
// //   }

// //   // 🔹 ويدجت زر مصمم بتدرج لوني
// //   Widget _buildGradientButton({
// //     required Widget child,
// //     required VoidCallback onPressed,
// //   }) {
// //     return DecoratedBox(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(10.r),
// //         gradient: const LinearGradient(
// //           colors: [_navyEnd, _navyStart],
// //           begin: Alignment.centerRight,
// //           end: Alignment.centerLeft,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: _navyStart.withOpacity(0.5),
// //             spreadRadius: 1,
// //             blurRadius: 5,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: ElevatedButton(
// //         onPressed: onPressed,
// //         style: ElevatedButton.styleFrom(
// //           minimumSize: Size(double.infinity, 50.h),
// //           backgroundColor: Colors.transparent,
// //           shadowColor: Colors.transparent,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(10.r),
// //           ),
// //           padding: EdgeInsets.zero,
// //         ),
// //         child: child,
// //       ),
// //     );
// //   }
  
// //   Widget _buildFuelTypeDropdown() {
// //     return DropdownButtonFormField<String>(
// //       value: selectedFuelType,
// //       hint: const Text("اختر نوع الوقود"),
// //       isExpanded: true,
// //       onChanged: (val) {
// //         setState(() {
// //           selectedFuelType = val;
// //         });
// //       },
// //       decoration: _getInputDecoration(
// //         hint: "اختر نوع الوقود",
// //         prefixIcon: Icons.local_gas_station_rounded,
// //       ),
// //       validator: (value) =>
// //           value == null ? 'الرجاء اختيار نوع الوقود' : null,
// //       style: TextStyle(fontSize: 15.sp, color: _navyStart),
// //       items: fuelOptions
// //           .map((e) => DropdownMenuItem(
// //                 value: e,
// //                 child: Text(e, textAlign: TextAlign.right),
// //               ))
// //           .toList(),
// //       dropdownColor: Colors.white,
// //       elevation: 8,
// //       borderRadius: BorderRadius.circular(12.r),
// //     );
// //   }

// //   Widget _buildFuelLitersDropdown() {
// //     return DropdownButtonFormField<int>(
// //       value: selectedFuelLiters,
// //       hint: const Text("اختر عدد اللترات المطلوبة"),
// //       isExpanded: true,
// //       onChanged: (val) {
// //         setState(() {
// //           selectedFuelLiters = val;
// //         });
// //       },
// //       decoration: _getInputDecoration(
// //         hint: "اختر عدد اللترات",
// //         prefixIcon: Icons.local_gas_station_rounded,
// //         suffixText: "لتر",
// //       ),
// //       validator: (value) =>
// //           value == null ? 'الرجاء اختيار عدد اللترات' : null,
// //       style: TextStyle(fontSize: 15.sp, color: _navyStart),
// //       items: fuelLitersOptions
// //           .map((e) => DropdownMenuItem(
// //                 value: e,
// //                 child: Text("$e لتر", textAlign: TextAlign.right),
// //               ))
// //           .toList(),
// //       dropdownColor: Colors.white,
// //       elevation: 8,
// //       borderRadius: BorderRadius.circular(12.r),
// //     );
// //   }

// //   Widget _buildNotesField() {
// //     return TextFormField(
// //       controller: _notesController,
// //       maxLines: 3,
// //       textDirection: TextDirection.rtl,
// //       textAlign: TextAlign.right,
// //       decoration: _getInputDecoration(
// //         hint: "ملاحظات إضافية (مثل: وقت التسليم المفضل)",
// //         prefixIcon: Icons.notes_rounded,
// //       ).copyWith(
// //         contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
// //       ),
// //       style: TextStyle(fontSize: 15.sp, color: _navyStart),
// //     );
// //   }
  
// //   InputDecoration _getInputDecoration({
// //     required String hint,
// //     IconData? prefixIcon,
// //     String? suffixText,
// //   }) {
// //     return InputDecoration(
// //       filled: true,
// //       fillColor: Colors.white,
// //       contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
// //       hintText: hint,
// //       hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
// //       prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _navyEnd) : null,
// //       suffixText: suffixText,
// //       suffixStyle: TextStyle(fontSize: 14.sp, color: _navyEnd),
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8.r),
// //         borderSide: const BorderSide(color: _navyEnd, width: 1.5),
// //       ),
// //       enabledBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8.r),
// //         borderSide: BorderSide(color: _navyEnd.withOpacity(0.5), width: 1),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8.r),
// //         borderSide: const BorderSide(color: _navyEnd, width: 2),
// //       ),
// //       errorBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8.r),
// //         borderSide: const BorderSide(color: Colors.red, width: 1.5),
// //       ),
// //       focusedErrorBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8.r),
// //         borderSide: const BorderSide(color: Colors.red, width: 2),
// //       ),
// //       suffixIcon: prefixIcon == Icons.local_gas_station_rounded || prefixIcon == Icons.liquor 
// //           ? const Icon(Icons.keyboard_arrow_down_rounded, color: _navyEnd)
// //           : null,
// //     );
// //   }

// //   // 🚨 الدالة المُعدلة لإضافة مربع حوار التأكيد قبل الانتقال
// //   void _showOrderConfirmationDialog() {
// //     // 1. التحقق من صحة الحقول أولاً
// //     if (!_fuelFormKey.currentState!.validate()) {
// //       return;
// //     }

// //     // 2. إظهار مربع حوار تأكيد الطلب
// //     showDialog(
// //       context: context,
// //       barrierDismissible: true, // يمكن الإغلاق بالضغط خارج المربع
// //       builder: (BuildContext context) {
// //         return Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: AlertDialog(
// //             title: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.info_outline, color: _navyEnd, size: 28),
// //                 SizedBox(width: 8.w),
// //                 Text("تأكيد طلب الوقود", style: TextStyle(color: _navyStart, fontWeight: FontWeight.bold)),
// //               ],
// //             ),
// //             content: Text(
// //               "سيتم مراجعة الطلب لتحديد أفضل سعر. وعند الدفع والتأكيد، سيتم التوصيل في وقت يتراوح بين **12 ساعة و 24 ساعة**.",
// //               textAlign: TextAlign.center,
// //               style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// //             ),
// //             actionsAlignment: MainAxisAlignment.spaceAround,
// //             actions: [
// //               // زر الإلغاء
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context); // إغلاق مربع الحوار
// //                 },
// //                 child: Text("إلغاء",
// //                     style: TextStyle(
// //                         color: Colors.red, fontWeight: FontWeight.bold)),
// //               ),
// //               // زر التأكيد (يقوم بالانتقال إلى شاشة النجاح)
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context); // إغلاق مربع الحوار أولاً
// //                   // 3. الانتقال إلى شاشة النجاح بحركة مخصصة
// //                   Navigator.of(context).push(_createRoute());
// //                 },
// //                 child: Text("تأكيد الطلب",
// //                     style: TextStyle(
// //                         color: _navyEnd, fontWeight: FontWeight.bold)),
// //               ),
// //             ],
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15.r),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: TextDirection.rtl,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           backgroundColor: _navyStart,
// //           title: const Text(
// //             "اطلب وقود الآن",
// //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //           ),
// //           centerTitle: true,
// //           iconTheme: const IconThemeData(color: Colors.white),
// //         ),
// //         body: Stack(
// //           children: [
// //             // ✅ الخلفية مع الصورة في المنتصف
// //             Container(
// //               width: double.infinity,
// //               height: double.infinity,
// //               color: Colors.grey[50],
// //               child: Center(
// //                 child: Opacity(
// //                   opacity: 0.1,
// //                   child: Image.asset(
// //                     'assets/images/logo2.png',
// //                     width: 250.w,
// //                     fit: BoxFit.contain,
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             // ✅ المحتوى
// //             SingleChildScrollView(
// //               padding: EdgeInsets.all(20.w),
// //               child: Form(
// //                 key: _fuelFormKey,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "⛽ اختر تفاصيل طلب الوقود:",
// //                       style: TextStyle(
// //                         fontSize: 18.sp,
// //                         fontWeight: FontWeight.bold,
// //                         color: _navyStart,
// //                       ),
// //                     ),
// //                     SizedBox(height: 25.h),

// //                     // 1. حقل نوع الوقود (Dropdown)
// //                     _buildFuelTypeDropdown(),
// //                     SizedBox(height: 15.h),

// //                     // 2. حقل عدد لترات الوقود (Dropdown)
// //                     _buildFuelLitersDropdown(),
// //                     SizedBox(height: 15.h),
                    
// //                     // 3. حقل الملاحظات
// //                     Text(
// //                       "ملاحظات إضافية:",
// //                       style: TextStyle(
// //                         fontSize: 16.sp,
// //                         fontWeight: FontWeight.w600,
// //                         color: _navyStart,
// //                       ),
// //                     ),
// //                     SizedBox(height: 8.h),
// //                     _buildNotesField(),

// //                     SizedBox(height: 50.h),

// //                     // ✅ زر تقديم الطلب
// //                     _buildGradientButton(
// //                       onPressed: _showOrderConfirmationDialog,
// //                       child: Text(
// //                         "تأكيد طلب الوقود",
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 17.sp,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),

// //                     SizedBox(height: 30.h),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }







import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/controllers/petrolController.dart';
import 'package:foodly/views/screens/order_success_screen.dart';
import 'package:get/get.dart';


const Color _navyStart = Color(0xFF070B35);
const Color _navyEnd = Color(0xFF191382);
const Color kWhite70 = Colors.white70;
const Color kGrey700 = Color.fromARGB(255, 66, 66, 66);
const Color kGrayLight = Color.fromARGB(255, 175, 175, 175);

// -------------------- حركة الانتقال --------------------
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const OrderSuccessScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}

// -------------------- فقاعات متحركة --------------------
class Bubble {
  final Color color;
  final double size;
  final double speed;
  final Offset startOffset;
  Bubble({required this.color, required this.size, required this.speed, required this.startOffset});
}

class BubblePainter extends CustomPainter {
  final double animationValue;
  final List<Bubble> bubbles;
  BubblePainter({required this.animationValue, required this.bubbles});
  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      double x = size.width * bubble.startOffset.dx;
      double y = (size.height * bubble.startOffset.dy + size.height * bubble.speed * animationValue) %
              (size.height + bubble.size * 2) -
          bubble.size;

      final paint = Paint()..color = bubble.color..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0);
      canvas.drawCircle(Offset(x, y), bubble.size / 2, paint);

      if (y > -bubble.size) {
        canvas.drawCircle(
          Offset(x, y),
          bubble.size / 2,
          Paint()
            ..color = Colors.white.withOpacity(0.05)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0
            ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5.0),
        );
      }
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

class BubblesBackground extends StatefulWidget {
  const BubblesBackground({super.key});
  @override
  State<BubblesBackground> createState() => _BubblesBackgroundState();
}

class _BubblesBackgroundState extends State<BubblesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 25), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BubblePainter(
            animationValue: _controller.value,
            bubbles: [
              Bubble(color: Colors.white.withOpacity(0.15), size: 100.w, speed: 0.005, startOffset: const Offset(0.3, 0.7)),
              Bubble(color: Colors.white.withOpacity(0.10), size: 150.w, speed: 0.003, startOffset: const Offset(0.8, 0.2)),
              Bubble(color: Colors.white.withOpacity(0.12), size: 70.w, speed: 0.008, startOffset: const Offset(0.1, 0.4)),
              Bubble(color: Colors.white.withOpacity(0.08), size: 180.w, speed: 0.002, startOffset: const Offset(0.6, 0.9)),
            ],
          ),
          child: Container(),
        );
      },
    );
  }
}

// -------------------- الصفحة الرئيسية --------------------
class OrderWaterPage extends StatefulWidget {
  const OrderWaterPage({super.key});
  @override
  State<OrderWaterPage> createState() => _OrderWaterPageState();
}

class _OrderWaterPageState extends State<OrderWaterPage> {
  final OrderController _orderController = Get.put(OrderController());

  String? selectedFuelType;
  int? selectedFuelLiters;
  final TextEditingController _notesController = TextEditingController();

  bool _isOrderProcessing = false;

  final List<String> fuelOptions = ["بنزين 91", "بنزين 95", "ديزل", "كيروسين"];
  final List<int> fuelLitersOptions = [20000, 32000];
  final GlobalKey<FormState> _fuelFormKey = GlobalKey<FormState>();

  final String userToken = "ضع توكن المستخدم هنا"; // جلبه من login

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  InputDecoration _getInputDecoration({required String hint, IconData? prefixIcon, String? suffixText}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _navyEnd) : null,
      suffixText: suffixText,
      suffixStyle: TextStyle(fontSize: 14.sp, color: _navyEnd),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9.r),
        borderSide: const BorderSide(color: _navyEnd, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9.r),
        borderSide: BorderSide(color: _navyEnd.withOpacity(0.5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9.r),
        borderSide: const BorderSide(color: _navyEnd, width: 2),
      ),
    );
  }

  Widget _buildFuelTypeDropdown() => DropdownButtonFormField<String>(
        value: selectedFuelType,
        hint: const Text("اختر نوع الوقود"),
        isExpanded: true,
        onChanged: (val) => setState(() => selectedFuelType = val),
        decoration: _getInputDecoration(hint: "اختر نوع الوقود", prefixIcon: Icons.local_gas_station_rounded),
        validator: (value) => value == null ? 'الرجاء اختيار نوع الوقود' : null,
        items: fuelOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, textAlign: TextAlign.right))).toList(),
      );

  Widget _buildFuelLitersDropdown() => DropdownButtonFormField<int>(
        value: selectedFuelLiters,
        hint: const Text("اختر عدد اللترات"),
        isExpanded: true,
        onChanged: (val) => setState(() => selectedFuelLiters = val),
        decoration: _getInputDecoration(hint: "اختر عدد اللترات", prefixIcon: Icons.local_gas_station_rounded, suffixText: "لتر"),
        validator: (value) => value == null ? 'الرجاء اختيار عدد اللترات' : null,
        items: fuelLitersOptions.map((e) => DropdownMenuItem(value: e, child: Text("$e لتر"))).toList(),
      );

  Widget _buildNotesField() => TextFormField(
        controller: _notesController,
        maxLines: 3,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        decoration: _getInputDecoration(hint: "ملاحظات إضافية", prefixIcon: Icons.notes_rounded),
      );

  Widget _buildGradientButton({required Widget child, required VoidCallback onPressed}) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: const LinearGradient(colors: [_navyEnd, _navyStart]),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50.h),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            padding: EdgeInsets.zero,
          ),
          child: child,
        ),
      );

  void _showOrderConfirmationDialog() {
    if (!_fuelFormKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: _navyEnd, size: 28),
              SizedBox(width: 8.w),
              Text("تأكيد طلب الوقود", style: TextStyle(color: _navyStart, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            "سيتم مراجعة الطلب لتحديد أفضل سعر. عند الدفع والتأكيد، سيتم التوصيل خلال 12-24 ساعة.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: kGrey700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _isOrderProcessing = true);

                try {
                  await _orderController.createOrder(
                    fuelType: selectedFuelType!,
                    fuelLiters: selectedFuelLiters!.toDouble(),
                    notes: _notesController.text,
                    token: userToken,
                  );

                  setState(() => _isOrderProcessing = false);
                  Navigator.of(context).push(_createRoute());
                } catch (e) {
                  setState(() => _isOrderProcessing = false);
                  Get.snackbar('خطأ', 'فشل في إنشاء الطلب: $e');
                }
              },
              child: const Text("تأكيد الطلب", style: TextStyle(color: _navyEnd, fontWeight: FontWeight.bold)),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(preferredSize: const Size.fromHeight(5), child: Container(color: Colors.white.withOpacity(0.3), height: 1)),
          backgroundColor: _navyStart,
          title: const Text("اطلب وقود الآن", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[50],
              child: Center(
                child: Opacity(opacity: 0.1, child: Image.asset('assets/images/logo2.png', width: 250.w, fit: BoxFit.contain)),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Form(
                key: _fuelFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("⛽ اختر تفاصيل طلب الوقود:", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: _navyStart)),
                    SizedBox(height: 25.h),
                    _buildFuelTypeDropdown(),
                    SizedBox(height: 15.h),
                    _buildFuelLitersDropdown(),
                    SizedBox(height: 15.h),
                    Text("ملاحظات إضافية:", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: _navyStart)),
                    SizedBox(height: 8.h),
                    _buildNotesField(),
                    SizedBox(height: 50.h),
                    _isOrderProcessing
                        ? const Center(child: CircularProgressIndicator())
                        : _buildGradientButton(
                            onPressed: _showOrderConfirmationDialog,
                            child: Text("تأكيد طلب الوقود", style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.bold)),
                          ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
