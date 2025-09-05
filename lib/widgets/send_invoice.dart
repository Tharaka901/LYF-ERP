import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';

class SendInvoice extends StatefulWidget {
  const SendInvoice({Key? key}) : super(key: key);

  @override
  State<SendInvoice> createState() => _SendInvoiceState();
}

class _SendInvoiceState extends State<SendInvoice> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          image(
            'gmail',
            size: 50.0,
          ),
          const Chip(
            label: Text(
              'sugathenterprices@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
