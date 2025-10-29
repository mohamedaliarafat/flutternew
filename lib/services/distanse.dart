// // ignore_for_file: unused_local_variable

// import 'dart:math';

// import 'package:foodly/models/distance_time.dart';

// class Distance {
//   DistanceTime calculateDistanceTimePrice(double lat1, double lon1, double lat2, double lon2, 
//   double speedKmPerHr, double pricePerKm){
//     var rlat1 = _toRadians(lat1);
//     var rlat2 = _toRadians(lat2);
//     var rlon1 = _toRadians(lon1);
//     var rlon2 = _toRadians(lon2);
//   }


//     final a = pow(sin(rLat / 2), 2) +
//         cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);

//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));



//   static double _toRadians(double degree) => degree * pi / 180;
// }

// void main() {
//   final distance = Distance.calculateDistance(
//     startLatitude: 24.7136, // الرياض
//     startLongitude: 46.6753,
//     endLatitude: 21.3891, // جدة
//     endLongitude: 39.8579,
//   );

//   print('المسافة بين الرياض وجدة: ${distance.toStringAsFixed(2)} كم');
// }
