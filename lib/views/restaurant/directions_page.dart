import 'package:flutter/material.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CompanyLocationPage extends StatefulWidget {
  const CompanyLocationPage({super.key});

  @override
  State<CompanyLocationPage> createState() => _CompanyLocationPageState();
}

class _CompanyLocationPageState extends State<CompanyLocationPage> {
  // موقع الشركة الافتراضي (الرياض)
  static const LatLng _companyLocation = LatLng(24.7118, 46.6803); 
  
  // موقعك الحالي بناءً على الإحداثيات التي أدخلتها
  // خط العرض: 27.4844572، خط الطول: 41.7520388
  static const LatLng _myLocation = LatLng(27.4844572, 41.7520388); 
  
  final Set<Marker> _markers = {}; 
  GoogleMapController? _mapController;
  
  // لتعيين الموقع الذي يجب أن تبدأ به الكاميرا
  late LatLng _initialTarget;

  @override
  void initState() {
    super.initState();
    
    // عند بدء التشغيل، اجعل الكاميرا تستهدف موقعك بدلاً من موقع الشركة
    _initialTarget = _myLocation; 

    // إضافة علامة الشركة (باللون الأزرق)
    _markers.add(
      const Marker(
        markerId: MarkerId('companyLocation'),
        position: _companyLocation,
        infoWindow: InfoWindow(title: 'موقع الشركة الرئيسية'),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    
    // إضافة علامة موقعك الحالي (باللون الأحمر)
    _markers.add(
      const Marker(
        markerId: MarkerId('userLocation'),
        position: _myLocation,
        infoWindow: InfoWindow(title: 'موقعي الحالي'),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  // دالة لتحريك الكاميرا إلى موقع معين
  void _animateToLocation(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueDark,
        
        // -------------------------------------
        // **** 1. إضافة زر الخروج (Leading) ****
        // -------------------------------------
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          tooltip: 'خروج',
          onPressed: () => Navigator.pop(context), // وظيفة الرجوع
        ),

        title: ReusableText(text: "موقع الشركة", 
        style: appStyle(20, kLightWhite, FontWeight.w600), tex: "tex"),
        centerTitle: true,
        actions: [
          // زر لإعادة التمركز على موقعك
          IconButton(
            icon: const Icon(Icons.my_location,
            color: kLightWhite,
            ),
            tooltip: 'الانتقال إلى موقعي',
            onPressed: () => _animateToLocation(_myLocation,),
          ),
          // زر للانتقال إلى موقع الشركة
          IconButton(
            icon: const Icon(Icons.business_center,color: kLightWhite,),
            tooltip: 'الانتقال إلى موقع الشركة',
            onPressed: () => _animateToLocation(_companyLocation),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // -------------------------------------
          // 1. الخريطة
          // -------------------------------------
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _initialTarget, // تبدأ بموقعك الآن
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _markers,
            // مهم لترك مساحة للجزء السفلي القابل للسحب
            padding: const EdgeInsets.only(bottom: 250), 
          ),

          // -------------------------------------
          // 2. ورقة التفاصيل القابلة للسحب (DraggableScrollableSheet)
          // -------------------------------------
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.25,
            maxChildSize: 0.70,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10.0),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // ... (مقبض السحب وعنوان التفاصيل)
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        'تفاصيل وبيانات الشركة',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kBlueDark),
                        textAlign: TextAlign.right,
                      ),
                      const Divider(height: 30),

                      // ************ حقول تفاصيل الشركة ************
                      _buildDetailField('اسم الشركة', 'شركة البحيرة العربية', Icons.business, ),
                      _buildDetailField('العنوان التفصيلي', 'King Abdullah Rd, الصناعية الثانية، Hail 55411', Icons.location_on_outlined),
                      _buildDetailField('رقم الهاتف', '+966 5005 000 000', Icons.phone),
                      _buildDetailField('البريد الإلكتروني', 'albuhairaalarabia@gmail.com', Icons.email_outlined),
                      
                      const SizedBox(height: 20),

                      // ... (وصف الشركة)
                      const Text('وصف عن الشركة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      const Text(
                        'تأسست الشركة في عام 1999 وهي رائدة ، ملتزمون بتقديم أفضل الخدمات لعملائنا.',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  // ودجت مساعد لبناء حقول التفاصيل (نفس الكود السابق، محاذاة لليسار LTR)
  Widget _buildDetailField(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal.shade700, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}