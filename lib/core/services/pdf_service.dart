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

    // Load logo if available, otherwise use a placeholder
    pw.MemoryImage? logoImage;
    try {
      final logoData = await rootBundle.load('assets/logo/logo.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      // Fallback if logo is missing
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (logoImage != null)
                    pw.Image(logoImage, width: 60, height: 60)
                  else
                    pw.Container(
                      width: 60,
                      height: 60,
                      color: PdfColors.grey300,
                    ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Amritha Ayurveda Hospital',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#2E7D32'),
                        ),
                      ),
                      pw.Text('Kochi, Kerala, 685565'),
                      pw.Text('Phone: +91 9846123456'),
                    ],
                  ),
                ],
              ),
              pw.Divider(thickness: 2, color: PdfColors.grey300),
              pw.SizedBox(height: 20),

              // Patient Info
              pw.Text(
                'Registration Receipt',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _infoRow('Patient Name:', name),
                        _infoRow('Phone:', phone),
                        _infoRow('Address:', address),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _infoRow('Branch:', branch),
                        _infoRow('Location:', location),
                        _infoRow('Date & Time:', dateTime),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Treatments Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _tableHeader('Treatment Name'),
                      _tableHeader('Price'),
                      _tableHeader('Male'),
                      _tableHeader('Female'),
                      _tableHeader('Total'),
                    ],
                  ),
                  // Table Rows
                  ...treatments.map((t) {
                    final price =
                        double.tryParse(t.treatment.price ?? '0') ?? 0;
                    return pw.TableRow(
                      children: [
                        _tableCell(t.treatment.name ?? ''),
                        _tableCell(price.toStringAsFixed(2)),
                        _tableCell(t.male.toString()),
                        _tableCell(t.female.toString()),
                        _tableCell(price.toStringAsFixed(2)),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 30),

              // Financial Summary
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _summaryRow('Total Amount:', totalAmount),
                      _summaryRow('Discount Amount:', discountAmount),
                      _summaryRow('Advance Amount:', advanceAmount),
                      pw.Divider(color: PdfColors.grey),
                      _summaryRow(
                        'Balance Amount:',
                        balanceAmount,
                        isTotal: true,
                      ),
                    ],
                  ),
                ],
              ),

              pw.Spacer(),
              pw.Center(
                child: pw.Text(
                  'Thank you for choosing Amritha Ayurveda Hospital',
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                  ),
                  pw.Text('Authorized Signature'),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Save or Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Registration_Receipt_${name.replaceAll(' ', '_')}.pdf',
    );
  }

  pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$label ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    );
  }

  pw.Widget _tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text),
    );
  }

  pw.Widget _summaryRow(String label, double amount, {bool isTotal = false}) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontSize: isTotal ? 14 : 12,
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Text(
          'Rs. ${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontSize: isTotal ? 14 : 12,
          ),
        ),
      ],
    );
  }
}
