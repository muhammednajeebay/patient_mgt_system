import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../provider/registration_provider.dart';

class PdfService {
  Future<void> generateRegistrationPdf({
    required String name,
    required String phone,
    required String address,
    required String branch,
    required String location,
    required List<SelectedTreatment> treatments,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required String dateTime,
  }) async {
    final pdf = pw.Document();

    // Load logo if available
    pw.MemoryImage? logoImage;
    try {
      final logoData = await rootBundle.load('assets/logo/logo_xl.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      // Fallback
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Watermark
              if (logoImage != null)
                pw.Center(
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Image(logoImage, width: 400),
                  ),
                ),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (logoImage != null)
                        pw.Image(logoImage, width: 80, height: 80)
                      else
                        pw.Container(
                          width: 80,
                          height: 80,
                          color: PdfColors.grey300,
                        ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            branch.toUpperCase(),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            'e-mail: unknown@gmail.com',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            'Mob: +91 9876543210 | +91 9786543210',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            'GST No: 32AABXXXXXX1ZW',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(thickness: 1, color: PdfColors.grey200),
                  pw.SizedBox(height: 20),

                  // Patient Details Header
                  pw.Text(
                    'Patient Details',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#006837'),
                    ),
                  ),
                  pw.SizedBox(height: 12),

                  // Patient Details 2-Column
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _infoRow('Name', name),
                            _infoRow('Address', address),
                            _infoRow('WhatsApp Number', phone),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _infoRow(
                              'Booked On',
                              dateTime.split('-').first +
                                  ' | ' +
                                  dateTime.split('-').last,
                            ),
                            _infoRow(
                              'Treatment Date',
                              DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            ),
                            _infoRow(
                              'Treatment Time',
                              DateFormat('hh:mm a').format(DateTime.now()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),
                  _dashedDivider(),
                  pw.SizedBox(height: 10),

                  // Treatments Header
                  pw.Row(
                    children: [
                      pw.Expanded(flex: 4, child: _headerText('Treatment')),
                      pw.Expanded(
                        flex: 2,
                        child: _headerText('Price', align: pw.TextAlign.center),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: _headerText('Male', align: pw.TextAlign.center),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: _headerText(
                          'Female',
                          align: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: _headerText('Total', align: pw.TextAlign.right),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),

                  // Treatments Rows
                  ...treatments.map((t) {
                    final price =
                        double.tryParse(t.treatment.price ?? '0') ?? 0;
                    final total = price * (t.male + t.female);
                    return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              t.treatment.name ?? '',
                              style: const pw.TextStyle(
                                color: PdfColors.grey700,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              'Rs. ${price.toInt()}',
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                color: PdfColors.grey700,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              t.male.toString(),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                color: PdfColors.grey700,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              t.female.toString(),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                color: PdfColors.grey700,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              'Rs. ${total.toInt()}',
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(
                                color: PdfColors.grey700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  pw.SizedBox(height: 10),
                  _dashedDivider(),
                  pw.SizedBox(height: 20),

                  // Financials
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          _financeRow('Total Amount', totalAmount),
                          _financeRow('Discount', discountAmount),
                          _financeRow('Advance', advanceAmount),
                          pw.SizedBox(height: 5),
                          _dashedDivider(width: 200),
                          pw.SizedBox(height: 5),
                          _financeRow(
                            'Balance',
                            balanceAmount,
                            isBalance: true,
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.Spacer(),

                  // Footer Message
                  pw.Row(
                    mainAxisAlignment: .end,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(
                            'Thank you for choosing us',
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#006837'),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Your well-being is our commitment, and we\'re honored\nyou\'ve entrusted us with your health journey',
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // Signature Placeholder (Stylized Text)
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Container(
                      margin: const pw.EdgeInsets.only(right: 50),
                      child: pw.Text(
                        '',
                        style: pw.TextStyle(
                          fontStyle: pw.FontStyle.italic,
                          fontSize: 24,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                  ),

                  pw.SizedBox(height: 50),
                  _dashedDivider(),
                  pw.SizedBox(height: 8),
                  pw.Center(
                    child: pw.Text(
                      '“Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment”',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Save or Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Receipt_${name.replaceAll(' ', '_')}.pdf',
    );
  }

  pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        children: [
          pw.Container(
            width: 90,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Text(
            ':  $value',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  pw.Widget _headerText(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(
        color: PdfColor.fromHex('#006837'),
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
      ),
    );
  }

  pw.Widget _financeRow(String label, double amount, {bool isBalance = false}) {
    return pw.Container(
      width: 200,
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBalance ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isBalance ? 14 : 11,
              color: isBalance ? PdfColors.black : PdfColors.grey900,
            ),
          ),
          pw.Text(
            'Rs. ${amount.toInt()}',
            style: pw.TextStyle(
              fontWeight: isBalance ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isBalance ? 14 : 11,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _dashedDivider({double? width}) {
    return pw.Container(
      width: width,
      child: pw.Row(
        children: List.generate(
          50,
          (index) => pw.Expanded(
            child: pw.Container(
              height: 1,
              color: PdfColors.grey300,
              margin: const pw.EdgeInsets.symmetric(horizontal: 1),
            ),
          ),
        ),
      ),
    );
  }
}
