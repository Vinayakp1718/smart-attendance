import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/Pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExportService {
  /// Exports attendance logs to Excel format.
  /// Returns the file path where it was saved, or a mock path on web.
  Future<String> exportAttendanceToExcel({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    // 1. Create a workbook with one sheet
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    sheet.getRangeByIndex(1, 1).columnWidth = 25;
    final Range titleRange = sheet.getRangeByIndex(1, 1, 1, headers.length);
    titleRange.merge();
    titleRange.setText(title);
    titleRange.cellStyle.fontSize = 16;
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.hAlign = HAlignType.center;

    // 3. Set headers
    for (int col = 0; col < headers.length; col++) {
      final Range headerCell = sheet.getRangeByIndex(3, col + 1);
      headerCell.setText(headers[col]);
      headerCell.cellStyle.bold = true;
      headerCell.cellStyle.backColor = '#4A90E2';
      headerCell.cellStyle.fontColor = '#FFFFFF';
      sheet.getRangeByIndex(3, col + 1).columnWidth = 20;
    }

    // 4. Fill rows
    for (int r = 0; r < rows.length; r++) {
      final List<String> rowData = rows[r];
      for (int c = 0; c < rowData.length; c++) {
        sheet.getRangeByIndex(r + 4, c + 1).setText(rowData[c]);
      }
    }

    // 5. Save document bytes
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // 6. Save to disk if not web
    if (kIsWeb) {
      // Simulate download time
      await Future.delayed(const Duration(milliseconds: 500));
      return 'downloads/${title.toLowerCase().replaceAll(' ', '_')}.xlsx';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final String path =
          '${directory.path}/${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final File file = File(path);
      await file.writeAsBytes(bytes);
      return path;
    }
  }

  /// Exports attendance logs to PDF format.
  /// Returns the file path where it was saved, or a mock path on web.
  Future<String> exportAttendanceToPdf({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    DateTime.now().toLocal().toString().substring(0, 10),
                    style: const pw.TextStyle(color: PdfColors.grey),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: rows,
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xff4A90E2),
              ),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
            ),
          ];
        },
      ),
    );

    final List<int> bytes = await pdf.save();

    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 500));
      return 'downloads/${title.toLowerCase().replaceAll(' ', '_')}.pdf';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final String path =
          '${directory.path}/${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final File file = File(path);
      await file.writeAsBytes(bytes);
      return path;
    }
  }
}
