import 'package:flutter/material.dart';
import 'package:gsr/models/item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

//const baseUrl = 'https://stageerp.jayawardenaenterprises.lk/api';
// const baseUrl = 'https://api.hjenterprises.lk/api';
// const baseUrl = 'https://api.cjtradingcompany.lk/api';
// const baseUrl = 'https://erpapi.hjtradingcompany.lk/api';
// const baseUrl = 'https://erpapi.hjtradingcompanymannar.lk/api';
// const baseUrl = 'https://api.hjtradingcompanymannar.lk/api';
// const baseUrl = 'https://api.jebiyagama.lk/api';
// const baseUrl = "http://localhost:8080/api";
// const baseUrl = "http://0.0.0.0:8080/api";
const baseUrl = 'https://api.ravonbakers.lk/api';
// const baseUrl = 'https://stageerpapi.jayawardenaagencies.lk/api';
// const baseUrl = 'https://api.jayawardenaagencies.lk/api';

const defaultAcceptColor = Colors.green;

final defaultBackgroundColor = Colors.grey[300];

final defaultBorderRadius = BorderRadius.circular(10.0);

const defaultElevation = 1.0;

const defaultErrorColor = Colors.redAccent;

const defaultPadding = EdgeInsets.all(10.0);

const defaultTextFieldStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
);

final defaultShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(
    10.0,
  ),
);

const defaultSpacing = 10.0;

// TEMP
final dummyItem = Item(
  id: 0,
  itemRegNo: 'Dymmy',
  itemName: 'Dummy',
  costPrice: 0,
  salePrice: 0,
  openingQty: 0,
  vendorId: 0,
  priceLevelId: 0,
  itemTypeId: 0,
  stockId: 0,
  costAccId: 0,
  incomeAccId: 0,
  isNew: 0,
  status: 0,
);

class MessageConstants {
  //!Print
  static pw.Text signatureNotRequired = pw.Text(
      'This is a system generated invoice and signature isn\'t required',
      style: const pw.TextStyle(fontSize: 20));
}

class ThemeConstants {
//! Print Invoice
  static pw.TextStyle boldStyleForPdf =
      pw.TextStyle(fontSize: 22.0, fontWeight: pw.FontWeight.bold);

//! Print Receipt
  static final pageFormat = PdfPageFormat.a4.copyWith(
      marginBottom: 0.0 * PdfPageFormat.cm,
      marginLeft: 0.5 * PdfPageFormat.cm,
      marginRight: 0.5 * PdfPageFormat.cm,
      marginTop: 0.0 * PdfPageFormat.cm);
}

class CompanyConstants {
  static const name = 'Jayawardena Enterprises (Pvt) Ltd';
  static const distribute = 'Distributor of Litro Gas Lanka Limited';
  static const address = 'No 142, Colombo Road, Biyagama';
  static const phoneNumber = 'Tel: 011 2488003';
  static const email = 'Email: jayaentlitro@gmail.com';
  static const vatNumber = 'Our Vat No - 104648479-7000';

  // static const name = 'Jayawardena Agencies (Pvt) Ltd';
  // static const distribute = 'Distributor of Litro Gas Lanka Limited';
  // static const address = '294,Mihinthala Road,Mathale Junction,Anuradhapura';
  // static const phoneNumber = 'Tel: 025 2223895';
  // static const email = 'Email: jayawardenaagencies@gmail.com';
  // static const vatNumber = 'Our Vat No - 114315877-7000';

  // static const name = 'H.J. Enterprises (Pvt) Ltd';
  // static const distribute = 'Distributor of Litro Gas Lanka Limited';
  // static const address = 'Polonnaruwa Road, Minneriya';
  // static const phoneNumber = 'Tel: 027-2055808';
  // static const email = 'Email: hjenterprises.polonnaruwa@gmail.com';
  // static const vatNumber = 'Our Vat No - 102899113-7000';

  // static const name = 'C J  Trading Company (Pvt) Ltd';
  // static const distribute = 'Distributor of Litro Gas Lanka Limited';
  // static const address = 'No : 135, Katuwewa, padeniya';
  // static const phoneNumber = 'Tel: 037 2041113';
  // static const email = 'Email: cjtradingcompany99@gmail.com';
  // static const vatNumber = 'Our Vat No - 109812617-7000';

  // static const name = 'H.J. Trading Company (Pvt) Ltd';
  // static const distribute = 'Distributor of Litro Gas Lanka Limited';
  // static const address = 'Pahala Galkandegama, Poonewa, Medawachchiya';
  // static const phoneNumber = 'Tel: 024-2054830';
  // static const email = 'Email: hjtrading.vavuniya@gmail.com';
  // static const vatNumber = 'Our Vat No - 102899156-7000';

  static companyDetails(bool hasOurVatNumber) => [
        pw.Text(
          CompanyConstants.name,
          style: ThemeConstants.boldStyleForPdf,
        ),
        pw.Text(
          CompanyConstants.distribute,
          style: ThemeConstants.boldStyleForPdf,
        ),
        pw.Text(
          CompanyConstants.address,
          style: ThemeConstants.boldStyleForPdf,
        ),
        pw.Text(
          CompanyConstants.phoneNumber,
          style: ThemeConstants.boldStyleForPdf,
        ),
        pw.Text(
          CompanyConstants.email,
          style: ThemeConstants.boldStyleForPdf,
        ),
        pw.SizedBox(height: 5.0),
        if (hasOurVatNumber)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                CompanyConstants.vatNumber,
                style: const pw.TextStyle(fontSize: 22.0),
              ),
            ],
          ),
      ];
}
