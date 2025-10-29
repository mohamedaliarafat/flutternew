import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';

// تعريف بيانات المنتجات
class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl; // رابط الصورة

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

// =======================================================
// صفحة تفاصيل وتتبع الطلب (بتصميم فاخر)
// =======================================================
class OrderTrackingPage extends StatefulWidget {
  final String orderNumber;
  final String date;
  final double total;
  final String paymentMethod;
  final String shippingAddress;
  final String orderStatus;
  final List<OrderItem> items; // تمرير قائمة المنتجات مباشرة

  const OrderTrackingPage({
    super.key,
    required this.orderNumber,
    required this.date,
    required this.total,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.orderStatus,
    required this.items, // يجب أن تكون قائمة المنتجات مطلوبة
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late int currentStep; // الخطوة الحالية في تتبع الطلب

  final List<Map<String, dynamic>> trackingStepsData = [
    {'title': 'تم استلام الطلب', 'icon': Icons.receipt_long},
    {'title': 'قيد التجهيز والشحن', 'icon': Icons.inventory_2_outlined},
    {'title': 'الشحنة في الطريق', 'icon': Icons.local_shipping_outlined},
    {'title': 'تم التوصيل بنجاح', 'icon': Icons.check_circle_outline},
  ];

  @override
  void initState() {
    super.initState();
    currentStep = _mapOrderStatusToStep(widget.orderStatus);
  }

  int _mapOrderStatusToStep(String status) {
    switch (status) {
      case 'Placed':
        return 0;
      case 'Preparing':
      case 'Accepted':
        return 1;
      case 'Out_for_Delivery':
        return 2;
      case 'Delivered':
        return 3;
      default:
        return 0; // حالة افتراضية
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // لون خلفية خفيف وأنيق
      appBar: AppBar(
        
        backgroundColor: kBlueDark, // شريط علوي أبيض نظيف
        elevation: 0, // إزالة الظل من الـ AppBar
        title: const Text(
          'تتبع طلبك',
          style: TextStyle(
            color: kLightWhite,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87), // لون أيقونات الـ AppBar
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTrackingSection(),
          const SizedBox(height: 20), // زيادة المسافة
          _buildOrderDetailsCard(),
          const SizedBox(height: 20),
          _buildProductsCard(),
          const SizedBox(height: 20),
          _buildShippingAndPaymentCard(),
        ],
      ),
    );
  }

  // =======================================================
  // بناء مكون تتبع الطلب (مع تحسينات جمالية)
  // =======================================================
  Widget _buildTrackingSection() {
    return Card(
      elevation: 6, // ظل أعمق
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // انحناء أكثر للأركان
      margin: const EdgeInsets.symmetric(horizontal: 4), // تباعد جانبي خفيف
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حالة تتبع الطلب',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.right,
            ),
            const Divider(height: 20, thickness: 1.5, color: Colors.grey),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor), // لون Stepper الرئيسي
              ),
              child: Stepper(
                physics: const NeverScrollableScrollPhysics(),
                currentStep: currentStep,
                controlsBuilder: (_, __) => Container(),
                steps: trackingStepsData.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> stepData = entry.value;
                  bool isCompleted = index <= currentStep;
                  Color stepColor = isCompleted ? Theme.of(context).primaryColor : Colors.grey[400]!;

                  return Step(
                    title: Row(
                      children: [
                        Icon(stepData['icon'], color: stepColor, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          stepData['title'],
                          style: TextStyle(
                            fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 16,
                            color: isCompleted ? Colors.black87 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(left: 34.0, bottom: 8.0), // محاذاة النص مع الأيقونة
                      child: Text(
                        isCompleted
                            ? 'آخر تحديث: ${widget.date}'
                            : 'في انتظار المرحلة السابقة',
                        style: TextStyle(
                            color: isCompleted ? Colors.green[700] : Colors.grey[500],
                            fontSize: 13),
                      ),
                    ),
                    isActive: isCompleted,
                    state: isCompleted ? StepState.complete : StepState.indexed,
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 20, thickness: 1.5, color: Colors.grey),
            _buildTrackingInfo(
                'رقم التتبع:', 'TRK123456789', Colors.blueAccent), // لون أزرق جذاب
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: فتح رابط تتبع شركة الشحن
                },
                icon: const Icon(Icons.open_in_new, size: 20),
                label: const Text('تتبع الشحنة على موقع الناقل', style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // لون الزر بلون التطبيق الرئيسي
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 4, // ظل للزر
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =======================================================
  // بناء مكون بطاقة تفاصيل الطلب
  // =======================================================
  Widget _buildOrderDetailsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص الطلب',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 20, thickness: 1.5, color: Colors.grey),
            _buildInfoRow('رقم الطلب:', widget.orderNumber, isStrong: true),
            _buildInfoRow('تاريخ الطلب:', widget.date),
            _buildInfoRow('الحالة:', trackingStepsData[currentStep]['title'],
                color: Colors.green[700]), // لون أخضر داكن
          ],
        ),
      ),
    );
  }

  // =======================================================
  // بناء مكون بطاقة المنتجات المشتراة
  // =======================================================
  Widget _buildProductsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المنتجات المطلوبة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 20, thickness: 1.5, color: Colors.grey),
            ...widget.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10), // انحناء لصور المنتجات
                        child: item.imageUrl.isNotEmpty
                            ? Image.network(
                                item.imageUrl,
                                width: 70, // حجم أكبر للصور
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container( // fallback لو فشل تحميل الصورة
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              )
                            : Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                              ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'الكمية: ${item.quantity}',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(item.price * item.quantity).toStringAsFixed(2)} ر.س',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                )).toList(),
            const Divider(height: 30, thickness: 1.5, color: Colors.grey),
            _buildPriceRow('الإجمالي الفرعي:', widget.total - 15 - 5), // قيم افتراضية
            _buildPriceRow('تكلفة الشحن:', 15.0),
            _buildPriceRow('الخصومات:', -5.0, isDiscount: true),
            const Divider(height: 30, thickness: 2.5, color: Colors.black87), // خط سميك للإجمالي
            _buildPriceRow('الإجمالي الكلي:', widget.total,
                isTotal: true, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  // =======================================================
  // بناء مكون بطاقة الشحن والدفع
  // =======================================================
  Widget _buildShippingAndPaymentCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الشحن والدفع',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 20, thickness: 1.5, color: Colors.grey),
            _buildDetailSection(
                Icons.location_on_outlined, 'عنوان الشحن', widget.shippingAddress),
            const Divider(indent: 50, endIndent: 10, thickness: 0.8), // خط أصغر بين التفاصيل
            _buildDetailSection(
                Icons.credit_card_outlined, 'طريقة الدفع', widget.paymentMethod),
          ],
        ),
      ),
    );
  }

  // =======================================================
  // المكونات المساعدة (مع تحسينات جمالية)
  // =======================================================

  Widget _buildInfoRow(String title, String value, {Color? color, bool isStrong = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // مسافة أكبر
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isStrong ? FontWeight.w700 : FontWeight.w500, // خط أثقل للعناصر المهمة
              color: color ?? Colors.black87,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, double amount,
      {Color? color, bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 18 : 15,
              color: isTotal ? color : (isDiscount ? Colors.red[700] : Colors.black87),
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}${amount.abs().toStringAsFixed(2)} ر.س',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 20 : 15,
              color: isTotal ? color : (isDiscount ? Colors.red[700] : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(IconData icon, String title, String description) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor, size: 28), // أيقونات أكبر
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)),
      subtitle: Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4), // تباعد داخلي
    );
  }

  Widget _buildTrackingInfo(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
        ],
      ),
    );
  }
}

// =======================================================
// مثال لكيفية استخدام الصفحة
// =======================================================
void main() {
  final sampleItems = [
    OrderItem(
      name: 'ساعة ذكية - أسود',
      quantity: 1,
      price: 150.0,
      imageUrl: 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Smartwatch', // رابط صورة حقيقي
    ),
    OrderItem(
      name: 'سماعات بلوتوث عالية الجودة',
      quantity: 2,
      price: 105.0,
      imageUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=Headphones',
    ),
  ];

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl, // لدعم اللغة العربية بشكل كامل
        child: OrderTrackingPage(
          orderNumber: 'ORD-2025-00123',
          date: '2025-10-27',
          total: 360.00, // يجب أن تكون القيمة المحسوبة
          paymentMethod: 'بطاقة مدى (**** 1234)',
          shippingAddress: 'شارع الملك فهد، حي المروج، الرياض، المملكة العربية السعودية، ص.ب 12345',
          orderStatus: 'Out_for_Delivery', // يمكن تغيير الحالة للاختبار (e.g., 'Delivered', 'Placed', 'Preparing')
          items: sampleItems,
        ),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue, // لون التطبيق الأساسي
        primaryColor: const Color(0xFF6200EE), // لون أساسي بنفسجي جذاب (يمكنك تغييره)
        fontFamily: 'Tajawal', // اختر خطاً يدعم العربية (تأكد من إضافته في pubspec.yaml)
      ),
    ),
  );
}