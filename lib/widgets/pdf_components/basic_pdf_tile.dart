import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../commons/common_methods.dart';

class PdfTile {
  static pw.Row basic({required String label, required String value}) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          pwtitleCell(value,
              align: pw.TextAlign.left,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              color: PdfColor.fromInt(0xFF000000)),
        ],
      );
}
