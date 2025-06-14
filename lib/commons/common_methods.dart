import 'package:badges/badges.dart' as b;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/models/response.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

badge(
  String badgeText, {
  Color? badgeColor,
}) =>
    b.Badge(
      badgeColor: badgeColor ?? Colors.red,
      badgeContent: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          badgeText,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
      animationType: b.BadgeAnimationType.scale,
    );

Future<Respo> respo(
  String endPoint, {
  Map<String, dynamic>? data,
  Method method = Method.get,
}) async {
  final response = method == Method.post
      ? await Dio().post(
          '$baseUrl/$endPoint',
          data: data,
          options: Options(
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        )
      : method == Method.get
          ? await Dio().get(
              '$baseUrl/$endPoint',
              queryParameters: data,
              options: Options(
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            )
          : await Dio().put(
              '$baseUrl/$endPoint',
              data: data,
              options: Options(
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );
  return Respo.fromJson(response.data);
}

enum Method { get, post, put }

toast(String msg, {TS toastState = TS.regular}) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: toastState == TS.error
          ? Colors.red
          : toastState == TS.success
              ? Colors.green
              : Colors.black,
      textColor: Colors.white,
      fontSize: 20.0,
    );

enum TS { error, success, regular }

Future confirm(
  BuildContext context, {
  required String title,
  required dynamic body,
  required Function() onConfirm,
  String? confirmText,
  String? cancelText,
  List<Widget>? moreActions,
}) {
  const style = TextStyle(fontSize: 20.0);
  return showDialog(
    useSafeArea: true,
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title),
      content: body != null
          ? body is Widget
              ? Card(
                  elevation: 0.0,
                  child: body,
                )
              : Text(
                  body,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                )
          : null,
      actions: [
        ...(moreActions ?? []),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmText ?? 'Confirm',
            style: style,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelText ?? 'Cancel',
            style: const TextStyle(color: Colors.red, fontSize: 20.0),
          ),
        ),
      ],
    ),
  );
}

waiting(
  BuildContext context, {
  String? body,
  List<Widget>? actions,
}) =>
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Center(child: CircularProgressIndicator()),
        content: Text(
          body ?? 'Please wait...',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15.0,
          ),
        ),
        actions: actions,
      ),
    );

String date(DateTime date, {String? format}) =>
    DateFormat(format ?? 'dd MMM yyyy').format(date);

Image image(
  String image, {
  double? size,
  double? height,
  double? width,
  String? ext,
}) =>
    Image.asset(
      'assets/images/$image.${ext ?? 'png'}',
      width: size ?? width,
      height: size ?? height,
    );

doub(dynamic value) {
  return value is String
      ? double.parse(value.trim())
      : value is int
          ? value.toDouble()
          : double.tryParse(value);
}

Widget get dummy => const SizedBox();

num(double number) =>
    number == number.toInt() ? number.toInt().toString() : number.toString();

numUnit(double number) =>
    number != 1 ? '${num(number)} Qty' : '${num(number)} Qty';

pop(BuildContext context) {
  Navigator.pop(context);
}

popValue(BuildContext context, {required dynamic value}) {
  Navigator.of(context).pop(value);
}

String formatPrice(double price) {
  final bool negative = price < 0;
  return MoneyFormatter(
    amount: negative ? -price : price,
    settings: MoneyFormatterSettings(
      symbol: negative ? '-Rs' : 'Rs',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolAndNumberSeparator: '.',
      fractionDigits: 2,
      compactFormatType: CompactFormatType.short,
    ),
  ).output.symbolOnLeft;
}

pwcell(String value, {pw.TextAlign? align}) => pw.Padding(
      padding: const pw.EdgeInsets.all(1),
      child: pw.Text(
        value,
        textAlign: align ?? pw.TextAlign.center,
        style: const pw.TextStyle(
          fontSize: 22.0,
        ),
      ),
    );
pwtitleCell(String value,
        {pw.TextAlign? align,
        pw.MainAxisAlignment? mainAxisAlignment = pw.MainAxisAlignment.start,
        PdfColor? color}) =>
    pw.Padding(
        padding: const pw.EdgeInsets.all(1),
        child: pw.Row(mainAxisAlignment: mainAxisAlignment!, children: [
          pw.Text(
            value,
            textAlign: align ?? pw.TextAlign.center,
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 22.0,
                color: color ?? PdfColor.fromInt(0xFF000000)),
          ),
        ]));

TableCell cell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
        ),
      ),
    );
TableCell titleCell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
Widget text(String value, {TextAlign? align}) => Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        value,
        textAlign: align ?? TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
