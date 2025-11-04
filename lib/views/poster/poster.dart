import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color kNavyStart = Color(0xFF070B35);
const Color kNavyEnd = Color(0xFF191382);
const Color kLightBlue = Color(0xFF42A5F5);
const Color kGrey700 = Color(0xFF616161);

class OfferModel {
  final String title;
  final String description;
  final String imageUrl;
  final String validity;

  OfferModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.validity,
  });
}

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  final List<OfferModel> offersData = [
    OfferModel(
      title: "خصم 20% على بنزين 95",
      description: "احصل على خصم فوري عند طلب 32,000 لتر أو أكثر من بنزين 95.",
      imageUrl: 'assets/images/122.jpg',
      validity: "ينتهي في 15 نوفمبر",
    ),
    OfferModel(
      title: "عرض الديزل الشامل",
      description: "توصيل مجاني لأي كمية ديزل تزيد عن 50,000 لتر داخل المدينة.",
      imageUrl: 'assets/images/122.jpg',
      validity: "عرض مستمر",
    ),
    OfferModel(
      title: "نقاط مكافآت مضاعفة",
      description: "اجمع نقاط مكافآت مضاعفة على جميع الطلبات المدفوعة عبر البطاقة الائتمانية.",
      imageUrl: 'assets/images/122.jpg',
      validity: "صالح لمدة أسبوعين",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showOfferDetails(BuildContext context, OfferModel offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black54.withOpacity(0.3),
            child: GestureDetector(
              onTap: () {}, // عشان تمنع إغلاق النافذة لما تضغط داخلها
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                padding: EdgeInsets.all(20.w),
                margin: EdgeInsets.only(top: 150.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2))
                  ],
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Hero(
                          tag: offer.title,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              offer.imageUrl,
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          offer.title,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: kNavyStart,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          offer.description,
                          style: TextStyle(fontSize: 16.sp, color: kGrey700),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.redAccent, size: 18.w),
                            SizedBox(width: 6.w),
                            Text(
                              offer.validity,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("✅ تم تفعيل العرض: ${offer.title}"),
                                  backgroundColor: kNavyEnd,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kNavyEnd,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.w, vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              "استفد من العرض الآن",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfferCard(BuildContext context, OfferModel offer, int index) {
    return FadeTransition(
      opacity: _fadeIn,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: kNavyEnd.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: () => _showOfferDetails(context, offer),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: offer.title,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                  child: Image.asset(
                    offer.imageUrl,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: kNavyStart,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      offer.description,
                      style: TextStyle(fontSize: 14.sp, color: kGrey700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        const Icon(Icons.local_offer, color: kLightBlue, size: 18),
                        SizedBox(width: 6.w),
                        Text(
                          offer.validity,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: kNavyStart,
          elevation: 4,
          centerTitle: true,
          title: Text(
            "العروض الحالية",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20.sp),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.r),
              bottomRight: Radius.circular(25.r),
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeIn,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
            physics: const BouncingScrollPhysics(),
            itemCount: offersData.length,
            itemBuilder: (context, index) =>
                _buildOfferCard(context, offersData[index], index),
          ),
        ),
      ),
    );
  }
}
