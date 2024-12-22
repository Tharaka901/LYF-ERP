import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

//const baseUrl = 'https://stageerp.jayawardenaenterprises.lk/api';
const baseUrl = 'https://api.ravonbakers.lk/api';
// const baseUrl = "http://localhost:8080/api";
// const baseUrl = "http://0.0.0.0:8080/api";

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

class MessageConstants {
  //!Print
  static pw.Text signatureNotRequired = pw.Text(
      'This is a system generated invoice and signature isn\'t required',
      style: pw.TextStyle(fontSize: 20));
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
  static const address =
      'Distributor of Litro Gas Lanka Limited\nNo 142, Colombo Road, Biyagama';
  static const phoneNumber = 'Tel: 011 248 8003';
  static const email = 'Email: jayaentlitro@gmail.com';
  static const vatNumber = 'Our Vat No - 104648479-7000';

  static final companyDetails = [
    pw.Text(
      CompanyConstants.name,
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

class HiveBox {
  static const data = 'Data';
  static const employee = 'Employee';
  static const routeCard = 'RouteCard';
  static const customers = 'Customers';
  static const routeCardBasicItems = 'RouteCardBasicItems';
  static const routeCardNewItems = 'RouteCardNewItems';
  static const routeCardOtherItems = 'RouteCardOtherItems';
  static const invoice = "Invoicess";
  static const customerDeposite = "CustomerDeposites";
  static const customerCredit = "CustomerCredit";
  static const paymentBox = "PaymentsBox";
  static const creditInvoicePayFromDepositesDataBox = "CreditInvoicePayFromDepositesDataBox";
}
