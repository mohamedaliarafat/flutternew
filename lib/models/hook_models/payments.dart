import 'package:foodly/models/payment_model';
import 'package:foodly/models/api_error.dart';

class FetchPayments {
  final List<PaymentModel>? data;
  final bool isLoading;
  final Exception? error;
  final Function refetch;
  final ApiError? apiError;

  FetchPayments({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.refetch,
    this.apiError,
  });
}
