import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildTableCell(String value, {pw.TextAlign? align, double? ph}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: ph ?? 2, vertical: 2),
    child: pw.Text(
      value,
      textAlign: align ?? pw.TextAlign.center,
      style: const pw.TextStyle(fontSize: 22),
    ),
  );
}

pw.Widget buildTableHeaderCell(String value,
    {pw.TextAlign? align, PdfColor? color, double? ph}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: ph ?? 1, vertical: 1),
    child: pw.Text(
      value,
      textAlign: align ?? pw.TextAlign.center,
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 22.0,
        color: color ?? const PdfColor.fromInt(0xFF000000),
      ),
    ),
  );
}
