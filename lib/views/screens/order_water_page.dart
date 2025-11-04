// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart'; // لاستخدام أيقونات iOS
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:foodly/constants/colors.dart';
// import 'package:foodly/views/screens/widgets/gradient_button.dart';
// import 'order_success_screen.dart';

// class OrderWaterPage extends StatefulWidget {
//   const OrderWaterPage({super.key});

//   @override
//   State<OrderWaterPage> createState() => _OrderWaterPageState();
// }

// class _OrderWaterPageState extends State<OrderWaterPage> {
//   String? selectedFuelType;
//   int? selectedFuelLiters;
//   final TextEditingController _notesController = TextEditingController();

//   bool _isOrderProcessing = false;
//   bool _isReadyForPayment = false;

//   final List<String> fuelOptions = ["بنزين 91", "بنزين 95", "ديزل", "كيروسين"];
//   final List<int> fuelLitersOptions = [20000, 32000];

//   final GlobalKey<FormState> _fuelFormKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     _notesController.dispose();
//     super.dispose();
//   }

//   InputDecoration _getInputDecoration({
//     required String hint,
//     IconData? prefixIcon,
//     String? suffixText,
//   }) {
//     // تم حذف هذا الجزء من الشرح للتخفيف، لكنه موجود في الكود
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
//       hintText: hint,
//       hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
//       prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: kNavyEnd) : null,
//       suffixText: suffixText,
//       suffixStyle: TextStyle(fontSize: 14.sp, color: kNavyEnd),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(9.r),
//         borderSide: const BorderSide(color: kNavyEnd, width: 1.5),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(9.r),
//         borderSide: BorderSide(color: kNavyEnd.withOpacity(0.5), width: 1),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(9.r),
//         borderSide: const BorderSide(color: kNavyEnd, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(9.r),
//         borderSide: const BorderSide(color: Colors.red, width: 1.5),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8.r),
//         borderSide: const BorderSide(color: Colors.red, width: 2),
//       ),
//       suffixIcon: (prefixIcon == Icons.local_gas_station_rounded || prefixIcon == Icons.liquor)
//           ? const Icon(Icons.keyboard_arrow_down_rounded, color: kNavyEnd)
//           : null,
//     );
//   }

//   Widget _buildFuelTypeDropdown() {
//     return DropdownButtonFormField<String>(
//       value: selectedFuelType,
//       hint: const Text("اختر نوع الوقود"),
//       isExpanded: true,
//       onChanged: (val) => setState(() => selectedFuelType = val),
//       decoration: _getInputDecoration(hint: "اختر نوع الوقود", prefixIcon: Icons.local_gas_station_rounded),
//       validator: (value) => value == null ? 'الرجاء اختيار نوع الوقود' : null,
//       style: TextStyle(fontSize: 15.sp, color: kNavyStart),
//       items: fuelOptions
//           .map((e) => DropdownMenuItem(
//                 value: e,
//                 child: Text(e, textAlign: TextAlign.right),
//               ))
//           .toList(),
//       dropdownColor: Colors.white,
//       elevation: 8,
//       borderRadius: BorderRadius.circular(12.r),
//     );
//   }

//   Widget _buildFuelLitersDropdown() {
//     return DropdownButtonFormField<int>(
//       value: selectedFuelLiters,
//       hint: const Text("اختر عدد اللترات المطلوبة"),
//       isExpanded: true,
//       onChanged: (val) => setState(() => selectedFuelLiters = val),
//       decoration: _getInputDecoration(hint: "اختر عدد اللترات", prefixIcon: Icons.local_gas_station_rounded, suffixText: "لتر"),
//       validator: (value) => value == null ? 'الرجاء اختيار عدد اللترات' : null,
//       style: TextStyle(fontSize: 15.sp, color: kNavyStart),
//       items: fuelLitersOptions
//           .map((e) => DropdownMenuItem(
//                 value: e,
//                 child: Text("$e لتر", textAlign: TextAlign.right),
//               ))
//           .toList(),
//       dropdownColor: Colors.white,
//       elevation: 8,
//       borderRadius: BorderRadius.circular(12.r),
//     );
//   }

//   Widget _buildNotesField() {
//     return TextFormField(
//       controller: _notesController,
//       maxLines: 3,
//       textDirection: TextDirection.rtl,
//       textAlign: TextAlign.right,
//       decoration: _getInputDecoration(
//         hint: "ملاحظات إضافية (مثل: وقت التسليم المفضل)",
//         prefixIcon: Icons.notes_rounded,
//       ).copyWith(contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h)),
//       style: TextStyle(fontSize: 15.sp, color: kNavyStart),
//     );
//   }

//   void _showOrderConfirmationDialog() {
//     if (!_fuelFormKey.currentState!.validate()) return;

//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.info_outline, color: kNavyEnd, size: 28),
//               SizedBox(width: 8.w),
//               Text("تأكيد طلب الوقود", style: TextStyle(color: kNavyStart, fontWeight: FontWeight.bold)),
//             ],
//           ),
//           content: Text(
//             "سيتم مراجعة الطلب لتحديد أفضل سعر. وعند الدفع والتأكيد، سيتم التوصيل في وقت يتراوح بين 12 ساعة و 24 ساعة.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: kGrey700),
//           ),
//           actionsAlignment: MainAxisAlignment.spaceAround,
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("إلغاء", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _isOrderProcessing = true;
//                   _isReadyForPayment = false;
//                 });
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
//                 );
//               },
//               child: const Text("تأكيد الطلب", style: TextStyle(color: kNavyEnd, fontWeight: FontWeight.bold)),
//             ),
//           ],
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         // ------------------------------------------
//         // 🚀 التعديلات على الـ AppBar
//         // ------------------------------------------
//         appBar: AppBar(
//           automaticallyImplyLeading: false, // نتحكم بزر العودة يدوياً
//           backgroundColor: kNavyStart,
//           elevation: 0, // إزالة الظل أسفل الـ AppBar
//           // تطبيق الحدود الدائرية السفلية
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(25.r),
//               bottomRight: Radius.circular(25.r),
//             ),
//           ),
//           title: const Text("اطلب وقود الآن",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           centerTitle: true,
//           // تحديد زر العودة
//           leading: IconButton(
//             icon: Icon(
//               // أيقونة سهم العودة لـ iOS (تتجه لليمين في وضع RTL)
//               Icons.arrow_back_ios_new_rounded,
//               color: Colors.white,
//               size: 20.w,
//             ),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           // الخط الأبيض الفاصل (كما كان في الكود الأصلي)
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(5.0),
//             child: Container(color: Colors.white.withOpacity(0.3), height: 1.0),
//           ),
//         ),
//         // ------------------------------------------
//         // نهاية التعديلات
//         // ------------------------------------------
//         body: SingleChildScrollView(
//           padding: EdgeInsets.all(20.w),
//           child: Form(
//             key: _fuelFormKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("⛽ اختر تفاصيل طلب الوقود:",
//                     style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: kNavyStart)),
//                 SizedBox(height: 25.h),
//                 _buildFuelTypeDropdown(),
//                 SizedBox(height: 15.h),
//                 _buildFuelLitersDropdown(),
//                 SizedBox(height: 15.h),
//                 Text("ملاحظات إضافية:",
//                     style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: kNavyStart)),
//                 SizedBox(height: 8.h),
//                 _buildNotesField(),
//                 SizedBox(height: 50.h),
//                 _isOrderProcessing
//                     ? Container(
//                         padding: EdgeInsets.all(20.w),
//                         margin: EdgeInsets.only(bottom: 20.h),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: kNavyEnd, width: 2),
//                           borderRadius: BorderRadius.circular(15.r),
//                         ),
//                         child: Text("⏳ الطلب قيد المراجعة...", style: TextStyle(fontSize: 16.sp)),
//                       )
//                     : GradientButton(
//                         onPressed: _showOrderConfirmationDialog,
//                         child: Text("تأكيد طلب الوقود",
//                             style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.bold))),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }