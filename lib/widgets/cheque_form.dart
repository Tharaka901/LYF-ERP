import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:provider/provider.dart';

class ChequeForm extends StatefulWidget {
  final TextEditingController chequeNumberController;
  final TextEditingController chequeAmountController;
  final GlobalKey<FormState> formKey;
  const ChequeForm(
      {Key? key,
      required this.chequeNumberController,
      required this.chequeAmountController,
      required this.formKey})
      : super(key: key);

  @override
  State<ChequeForm> createState() => _ChequeFormState();
}

class _ChequeFormState extends State<ChequeForm> {
  final _chequeAmountFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: widget.chequeNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                  ),
                  labelText: 'Cheque number',
                ),
                validator: (chequeNumber) {
                  if (chequeNumber == null || chequeNumber.trim().isEmpty) {
                    return 'Cheque number required!';
                  } else if (chequeNumber.trim().length != 6) {
                    return 'Exactly 6 characters required!';
                  } else if (context
                      .read<DataProvider>()
                      .chequeList
                      .where((cheque) => cheque.chequeNumber == chequeNumber)
                      .isNotEmpty) {
                    return 'Already added!';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                // inputFormatters: [
                //   ThousandsFormatter(
                //     allowFraction: true,
                //   ),
                // ],
                controller: widget.chequeAmountController,
                focusNode: _chequeAmountFocus,
                validator: (text) {
                  final chequeAmount = text!.trim().replaceAll(',', '');
                  if (chequeAmount.isEmpty) {
                    return 'Cheque amount required!';
                  } else if (double.parse(chequeAmount) <= 0) {
                    return 'Invalid cheque amount!';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                  ),
                  labelText: 'Cheque amount',
                  prefixText: 'Rs. ',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
