import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:foodly/constants/constants.dart'; // يحتوي على appBaseUrl

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;
  final String currency;
  final String? restaurantName;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.currency,
    this.restaurantName,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedBankKey;
  String? _selectedIban;
  bool _transferConfirmed = false;
  PlatformFile? _receiptFile;

  late final Map<String, dynamic> _banksData;

  // بيانات البنوك
  final String banksJson = '''
  {
    "alrajhi": {
      "name": "مصرف الراجحي",
      "iban": "SA9910000000123456789123"
    },
    "alahli": {
      "name": "البنك الأهلي السعودي",
      "iban": "SA5610000000987654321123"
    },
    "stcpay": {
      "name": "محفظة STC Pay",
      "iban": "SA5015000000123456789900"
    }
  }
  ''';

  @override
  void initState() {
    super.initState();
    try {
      _banksData = json.decode(banksJson);
    } catch (e) {
      debugPrint('❌ خطأ في قراءة JSON البنوك: $e');
      _banksData = {};
    }
  }

  void _onBankSelected(String? bankKey) {
    setState(() {
      _selectedBankKey = bankKey;
      _transferConfirmed = false;
      _receiptFile = null;
      if (bankKey != null && _banksData.containsKey(bankKey)) {
        _selectedIban = _banksData[bankKey]['iban'];
      } else {
        _selectedIban = null;
      }
    });
  }

  Future<void> _pickReceiptFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _receiptFile = result.files.single;
      });
    }
  }

  Future<void> _submitPayment() async {
    if (_receiptFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ الرجاء إرفاق إيصال التحويل للمتابعة.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedBankKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ يرجى اختيار البنك المحول إليه أولاً.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // ✅ تحديث الرابط للـ endpoint الصحيح
      final url = Uri.parse("$appBaseUrl/api/payments");

      final request = http.MultipartRequest('POST', url);

      // 🔹 جلب التوكن من التخزين المحلي
      final box = GetStorage();
      String? token = box.read("token");
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // 🔹 حقول مطابقة لـ PaymentModel
      request.fields['orderId'] = widget.orderId;
      request.fields['totalAmount'] = widget.totalAmount.toString();
      request.fields['currency'] = widget.currency;
      request.fields['bank'] = _banksData[_selectedBankKey]!['name'];
      request.fields['iban'] = _banksData[_selectedBankKey]!['iban'];
      request.fields['status'] = "Pending";

      // 🔹 إضافة الملف المرفق
      request.files.add(
        await http.MultipartFile.fromPath(
          'receiptFile',
          _receiptFile!.path!,
        ),
      );

      // 🔹 إرسال الطلب
      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم إرسال الدفع بنجاح. الطلب قيد المراجعة.'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        debugPrint("❌ فشل الدفع: ${response.statusCode}");
        debugPrint("الرد: $resBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الإرسال: $resBody'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("⚠️ خطأ أثناء الإرسال: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء الإرسال: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color kLightWhite = Colors.white;
    const Color kBlueDark = Color.fromARGB(255, 14, 34, 65);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: kBlueDark,
        title: const Text(
          "إتمام الدفع بالتحويل البنكي",
          style: TextStyle(fontSize: 18, color: kLightWhite, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. ملخص الطلب', Icons.receipt_long, kBlueDark),
              _buildOrderSummary(kBlueDark),
              const SizedBox(height: 30),
              _buildSectionTitle('2. اختر البنك للتحويل', Icons.account_balance, kBlueDark),
              _buildBankSelection(),
              if (_selectedIban != null) ...[
                const SizedBox(height: 20),
                _buildIbanDisplay(kBlueDark),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _transferConfirmed = true;
                      _receiptFile = null;
                    });
                  },
                  icon: Icon(
                    _transferConfirmed ? Icons.check_circle_outline : Icons.done_all,
                    color: kLightWhite,
                  ),
                  label: Text(
                    _transferConfirmed
                        ? 'تم تأكيد إتمام التحويل ✅'
                        : 'أكّد إتمام التحويل البنكي',
                    style: const TextStyle(fontSize: 16, color: kLightWhite, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _transferConfirmed ? Colors.green.shade700 : kBlueDark,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                ),
              ],
              if (_transferConfirmed) ...[
                const Divider(height: 40),
                _buildSectionTitle('3. إرفاق الإيصال والتأكيد النهائي', Icons.upload_file, kBlueDark),
                _buildReceiptUpload(kBlueDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color kBlueDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        children: [
          Icon(icon, color: kBlueDark, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Color kBlueDark) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow('رقم الطلب', widget.orderId, Icons.tag, false, kBlueDark),
            const Divider(height: 20),
            _buildSummaryRow('المبلغ الإجمالي للدفع',
                '${widget.totalAmount} ${widget.currency}', Icons.price_change, true, kBlueDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, IconData icon, bool isTotal, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: isTotal ? color.withOpacity(0.8) : Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? color : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBankSelection() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        prefixIcon: const Icon(Icons.credit_card, color: Colors.teal),
        labelText: 'اختر البنك المحول إليه',
        hintText: 'الرجاء اختيار بنك...',
      ),
      value: _selectedBankKey,
      items: _banksData.keys.map((key) {
        return DropdownMenuItem<String>(
          value: key,
          child: Text(_banksData[key]['name']),
        );
      }).toList(),
      onChanged: _onBankSelected,
    );
  }

  Widget _buildIbanDisplay(Color kBlueDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: kBlueDark),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'رقم الايبان لـ ${_banksData[_selectedBankKey]!['name']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(
            _selectedIban ?? '',
            style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptUpload(Color kBlueDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_receiptFile != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file, color: Colors.green),
                const SizedBox(width: 10),
                Expanded(child: Text('الملف: ${_receiptFile!.name}')),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _receiptFile = null),
                ),
              ],
            ),
          ),
        OutlinedButton.icon(
          onPressed: _pickReceiptFile,
          icon: const Icon(Icons.cloud_upload_outlined, size: 24),
          label: Text(_receiptFile == null ? 'اختر ملف إيصال التحويل' : 'تغيير الإيصال'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(color: kBlueDark, width: 1.5),
            foregroundColor: kBlueDark,
          ),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: _submitPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
          ),
          child: const Text(
            'إرسال وتأكيد الطلب الآن',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
