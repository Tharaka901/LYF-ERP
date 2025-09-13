import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/credit_invoice_pay_from_diposites/credit_invoice_pay_from_diposites_data_model.dart';
import '../models/credit_payment/credit_payment_model.dart';
import '../models/payment/payment_model.dart';
import '../models/payment_data/payment_data_model.dart';
import '../models/payments.dart';
import '../modules/invoice/invoice_provider.dart';
import '../providers/data_provider.dart';

class PaymentService {
  Future<int> getReceiptCount(BuildContext context) async {
    final routeCard = context.read<DataProvider>().currentRouteCard!;
    final response = await respo('payment/count/?id=${routeCard.routeCardId}');
    final int count = response.data;
    return count;
  }

  Future<String> getReceiptNumber(BuildContext context) async {
    final routeCard = context.read<DataProvider>().currentRouteCard!;
    final response = await respo('payment/count/?id=${routeCard.routeCardId}');
    final int count = response.data;
    return 'R/${routeCard.routeCardNo}/${count + 1}';
  }

  Future<List<CreditPaymentModel>> getCreditPayments({
    required String receiptNo,
  }) async {
    final response = await respo('credit-payment/get?receiptNo=$receiptNo');
    List<dynamic> list = response.data;
    return list.map((element) => CreditPaymentModel.fromJson(element)).toList();
  }

  Future<void> createCreditPayment(Map<String, dynamic> data) async {
    respo('credit-payment/create', method: Method.post, data: data);
  }

  Future<void> createOverPayment(
      {required double overPayment,
      required int paymentInvoiceId,
      required int routecardId,
      required String receiptNo,
      required int customerId}) async {
    await respo(
      'over-payment/create',
      method: Method.post,
      data: {
        "value": overPayment,
        "status": 2,
        "paymentInvoiceId": paymentInvoiceId,
        "routecardId": routecardId,
        "receiptNo": receiptNo,
        "customerId": customerId
      },
    );
  }

  Future<void> payWithCreditInvoice({
    required BuildContext context,
    required PaymentDataModel paymentDataModel,
    bool? isOnlySave,
  }) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    try {
//! Update over payment
      if (paymentDataModel.issuedDepositePaidList.isNotEmpty) {
        await respo(
          'over-payment/update',
          method: Method.put,
          data: {
            "overPaymentsPayList": [
              ...paymentDataModel.issuedDepositePaidList.map((e) => {
                    "value": (e.depositeValue! - e.paymentAmount).toInt(),
                    "customerId": paymentDataModel.selectedCustomer.customerId,
                    "paymentInvoiceId": e.issuedDeposite.paymentInvoiceId
                  })
            ]
          },
        );
      }

      //! Update return cylinder invoice balance
      for (var rci in paymentDataModel.issuedDepositePaidList) {
        if (rci.issuedDeposite.status == 2) {
          await respo('return-cylinder-invoice/update',
              method: Method.put,
              data: {
                "invoiceNo": rci.issuedDeposite.receiptNo,
                "balance": rci.issuedDeposite.value! - rci.paymentAmount,
                "status":
                    rci.issuedDeposite.value! - rci.paymentAmount == 0 ? 2 : 1
              });
        }
      }

      if (isOnlySave ?? false) {
        dataProvider.issuedDepositePaidList.clear();
      }

      // //! Create invoice
      await respo(
        'invoice/update',
        method: Method.put,
        data: {
          "invoiceId": paymentDataModel.invoiceId,
          "status": 2,
          "creditValue": 0
        },
      );
      if (isOnlySave ?? false) {
        dataProvider.itemList.clear();
      }
      //! Create receipt number

      final rn = paymentDataModel.receiptNo;

      final invoiceId = paymentDataModel.invoiceId;

      for (var invoice in paymentDataModel.issuedInvoicePaidList ?? []) {
        final data = {
          "value": invoice.paymentAmount,
          "paymentInvoiceId": invoiceId,
          "routecardId": paymentDataModel.currentRouteCard.routeCardId,
          "creditInvoiceId":
              invoice.chequeId ?? invoice.issuedInvoice.invoiceId,
          "receiptNo": rn,
          "status": invoice.chequeId != null ? 3 : 2,
          "type": invoice.chequeId != null ? "return-cheque" : 'default'
        };
        await respo('credit-payment/create', method: Method.post, data: data);
        if (invoice.creditAmount! <= invoice.paymentAmount &&
            invoice.chequeId == null) {
          await respo('invoice/update', method: Method.put, data: {
            "invoiceId": invoice.issuedInvoice.invoiceId,
            "status": 2
          });
        }

        if (invoice.chequeId != null) {
          if (invoice.creditAmount! <= invoice.paymentAmount) {
            await respo('cheque/update',
                method: Method.put,
                data: {"id": invoice.chequeId, "isActive": 2, "balance": 0});
          } else {
            await respo('cheque/update', method: Method.put, data: {
              "id": invoice.chequeId,
              "balance": invoice.creditAmount! - invoice.paymentAmount
            });
          }
        }
      }

      //! Create payment
      await respo(
        'payment/create',
        data: Payments(
          payments: [
            if (paymentDataModel.cash > 0)
              PaymentModel(
                customerTypeId:
                    paymentDataModel.selectedCustomer.customerTypeId,
                invoiceId: invoiceId,
                amount: paymentDataModel.cash,
                receiptNo: rn,
                paymentMethod: 1,
                chequeNo: null,
                routecardId: paymentDataModel.currentRouteCard.routeCardId,
                routeId: paymentDataModel.currentRouteCard.routeId,
                customerId: paymentDataModel.selectedCustomer.customerId,
                priceLevelId: paymentDataModel.selectedCustomer.priceLevelId,
                employeeId: paymentDataModel.currentEmployee.employeeId,
                status: 1,
              ).toJson(),
            ...paymentDataModel.chequeList.map(
              (cheque) => PaymentModel(
                customerTypeId:
                    paymentDataModel.selectedCustomer.customerTypeId,
                invoiceId: invoiceId,
                amount: cheque.chequeAmount,
                chequeNo: cheque.chequeNumber,
                receiptNo: rn,
                paymentMethod: 2,
                routecardId: paymentDataModel.currentRouteCard.routeCardId,
                routeId: paymentDataModel.currentRouteCard.routeId,
                customerId: paymentDataModel.selectedCustomer.customerId,
                priceLevelId: paymentDataModel.selectedCustomer.priceLevelId,
                employeeId: paymentDataModel.currentEmployee.employeeId,
                status: 1,
              ).toJson(),
            ),
          ],
        ).toJson(),
        method: Method.post,
      );
      if (paymentDataModel.balance > 0) {
        await respo(
          'customers/update',
          method: Method.put,
          data: {
            "customerId": paymentDataModel.selectedCustomer.customerId,
            "depositBalance":
                paymentDataModel.selectedCustomer.depositBalance! +
                    paymentDataModel.balance,
          },
        );
        await respo(
          'over-payment/create',
          method: Method.post,
          data: {
            "value": paymentDataModel.balance,
            "status": 1,
            "paymentInvoiceId": invoiceId,
            "routecardId": paymentDataModel.currentRouteCard.routeCardId,
            "receiptNo": rn,
            "customerId": paymentDataModel.selectedCustomer.customerId
          },
        );
      }
      if (isOnlySave ?? false) {
        dataProvider.chequeList.clear();
        dataProvider.issuedInvoicePaidList.clear();
      }
      //! Create voucher payment
      if (paymentDataModel.selectedVoucher != null) {
        await respo(
          'payment/create',
          method: Method.post,
          data: Payments(
            payments: [
              PaymentModel(
                customerTypeId:
                    paymentDataModel.selectedCustomer.customerTypeId,
                invoiceId: invoiceId,
                amount: paymentDataModel.selectedVoucher != null
                    ? paymentDataModel.selectedVoucher!.value
                    : 0.0,
                chequeNo: paymentDataModel.selectedVoucher?.code,
                receiptNo: rn,
                paymentMethod: 3,
                routecardId: paymentDataModel.currentRouteCard.routeCardId,
                routeId: paymentDataModel.currentRouteCard.routeId,
                customerId: paymentDataModel.selectedCustomer.customerId,
                priceLevelId: paymentDataModel.selectedCustomer.priceLevelId,
                employeeId: paymentDataModel.currentEmployee.employeeId,
                status: 1,
              ).toJson(),
            ],
          ).toJson(),
        );
      }

      final invoiceProvider =
          Provider.of<InvoiceProvider>(context, listen: false);
      invoiceProvider.invoiceNu = null;
      invoiceProvider.invoiceRes = null;
    } catch (e) {
      rethrow;
    }
  }

  //!
  Future<void> sendCreditPayment(
    BuildContext context,
    PaymentDataModel paymentDataModel,
  ) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = paymentDataModel.selectedCustomer;

    await respo('invoice/create-single', method: Method.post, data: {
      "invoice": {
        "invoiceNo": paymentDataModel.invoiceNo,
        "routecardId": paymentDataModel.currentRouteCard.routeCardId,
        "amount": paymentDataModel.totalPayment,
        "customerId": selectedCustomer.customerId,
        "creditValue": 0,
        "vat": 0,
        "subTotal": 0,
        "employeeId": paymentDataModel.currentEmployee.employeeId,
        "nonVatItemTotal": 0,
        "status": !paymentDataModel.isDirectPrevoius! ? 3 : 4,
      },
    }).then((invoiceResponse) async {
      final invoiceId = invoiceResponse.data['invoiceId'] as int;
      final rn = paymentDataModel.receiptNo;
      if ((paymentDataModel.issuedInvoicePaidList ?? []).isNotEmpty) {
        for (var invoice in paymentDataModel.issuedInvoicePaidList!) {
          final data = {
            "value": invoice.paymentAmount,
            "paymentInvoiceId": invoiceId,
            "routecardId": paymentDataModel.currentRouteCard.routeCardId,
            "creditInvoiceId":
                invoice.chequeId ?? invoice.invoiceId,
            "receiptNo": rn,
            "status": invoice.chequeId != null ? 3 : 1,
            "type": invoice.chequeId != null ? "return-cheque" : 'default'
          };
          await respo('credit-payment/create', method: Method.post, data: data);
          if (invoice.creditAmount! <= invoice.paymentAmount &&
              invoice.chequeId == null) {
            await respo('invoice/update', method: Method.put, data: {
              "invoiceId": invoice.issuedInvoice.invoiceId,
              "status": 2
            });
          } else {
            try {
              if (kDebugMode) {
                print(invoice.issuedInvoice.toJsonWithId());
              }
              await respo('invoice/update', method: Method.put, data: {
                "invoiceId": invoice.issuedInvoice.invoiceId,
                "creditValue": invoice.creditAmount! - invoice.paymentAmount
              });
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          }
          if (invoice.chequeId != null) {
            if (invoice.creditAmount! <= invoice.paymentAmount) {
              await respo('cheque/update',
                  method: Method.put,
                  data: {"id": invoice.chequeId, "isActive": 2, "balance": 0});
            } else {
              await respo('cheque/update', method: Method.put, data: {
                "id": invoice.chequeId,
                "balance": invoice.creditAmount! - invoice.paymentAmount
              });
            }
          }
        }
      }

      await respo('payment/create',
          method: Method.post,
          data: Payments(
            payments: [
              if (paymentDataModel.cash > 0)
                PaymentModel(
                  customerTypeId: selectedCustomer.customerTypeId,
                  invoiceId: invoiceId,
                  amount: paymentDataModel.cash,
                  receiptNo: rn,
                  paymentMethod: 1,
                  chequeNo: null,
                  routecardId: paymentDataModel.currentRouteCard.routeCardId,
                  routeId: paymentDataModel.currentRouteCard.routeId,
                  customerId: selectedCustomer.customerId,
                  priceLevelId: selectedCustomer.priceLevelId,
                  employeeId: paymentDataModel.currentEmployee.employeeId,
                  status: 1,
                ).toJson(),
              ...paymentDataModel.chequeList.map(
                (cheque) => PaymentModel(
                  customerTypeId: selectedCustomer.customerTypeId,
                  invoiceId: invoiceId,
                  amount: cheque.chequeAmount,
                  chequeNo: cheque.chequeNumber,
                  receiptNo: rn,
                  paymentMethod: 2,
                  routecardId: paymentDataModel.currentRouteCard.routeCardId,
                  routeId: paymentDataModel.currentRouteCard.routeId,
                  customerId: selectedCustomer.customerId,
                  priceLevelId: selectedCustomer.priceLevelId,
                  employeeId: paymentDataModel.currentEmployee.employeeId,
                  status: 1,
                ).toJson(),
              ),
            ],
          ).toJson());
      if (paymentDataModel.totalPayment! >
          (paymentDataModel.issuedInvoicePaidList!
              .map((e) => e.paymentAmount)
              .toList()
              .reduce((value, element) => value + element))) {
        await respo(
          'customers/update',
          method: Method.put,
          data: {
            "customerId": selectedCustomer.customerId,
            "depositBalance": selectedCustomer.depositBalance! +
                (paymentDataModel.totalPayment! -
                    (paymentDataModel.issuedInvoicePaidList!
                        .map((e) => e.paymentAmount)
                        .toList()
                        .reduce((value, element) => value + element))),
          },
        );
        await respo(
          'over-payment/create',
          method: Method.post,
          data: {
            "value": (paymentDataModel.totalPayment! -
                (paymentDataModel.issuedInvoicePaidList!
                    .map((e) => e.paymentAmount)
                    .toList()
                    .reduce((value, element) => value + element))),
            "status": 1,
            "paymentInvoiceId": invoiceId,
            "routecardId": paymentDataModel.currentRouteCard.routeCardId,
            "receiptNo": rn,
            "customerId": selectedCustomer.customerId
          },
        );
      }
      //});
      dataProvider.chequeList.clear();
      //! Update over payment
      if (paymentDataModel.issuedDepositePaidList.isNotEmpty) {
        await respo(
          'over-payment/update',
          method: Method.put,
          data: {
            "overPaymentsPayList": [
              ...paymentDataModel.issuedDepositePaidList.map((e) => {
                    "value": (e.depositeValue! - e.paymentAmount).toInt(),
                    "customerId": paymentDataModel.selectedCustomer.customerId,
                    "paymentInvoiceId": e.issuedDeposite.paymentInvoiceId
                  })
            ]
          },
        );
      }
    });
    if (context.mounted) {
      final invoiceProvider =
          Provider.of<InvoiceProvider>(context, listen: false);
      invoiceProvider.invoiceNu = null;
      invoiceProvider.invoiceRes = null;
    }
  }

  Future<void> pay({
    required PaymentDataModel paymentDataModel,
    required BuildContext context,
    bool? isOnlySave,
  }) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    try {
      //! Update over payment
      if (paymentDataModel.issuedDepositePaidList.isNotEmpty) {
        await respo(
          'over-payment/update',
          method: Method.put,
          data: {
            "overPaymentsPayList": [
              ...paymentDataModel.issuedDepositePaidList.map((e) => {
                    "value": (e.depositeValue! - e.paymentAmount).toInt(),
                    "customerId": paymentDataModel.selectedCustomer.customerId,
                    "paymentInvoiceId": e.issuedDeposite.paymentInvoiceId
                  })
            ]
          },
        );
        paymentDataModel.issuedDepositePaidList.forEach((element) async {
          final data = {
            "value": element.paymentAmount,
            "paymentInvoiceId": element.issuedDeposite.paymentInvoiceId,
            "routecardId": paymentDataModel.currentRouteCard.routeCardId,
            "creditInvoiceId": paymentDataModel.invoiceId,
            "receiptNo": element.issuedDeposite.receiptNo,
            "status": 1
          };
          await respo('credit-payment/create', method: Method.post, data: data);
        });
        await respo(
          'customers/update',
          method: Method.put,
          data: {
            "customerId": paymentDataModel.selectedCustomer.customerId,
            "depositBalance":
                paymentDataModel.selectedCustomer.depositBalance! -
                    paymentDataModel.issuedDepositePaidList
                        .map((e) => e.paymentAmount)
                        .reduce((value, element) => value + element),
          },
        );
      }

      if (isOnlySave ?? false) {
        dataProvider.issuedDepositePaidList.clear();
      }

      //! Update invoice
      await respo(
        'invoice/update',
        method: Method.put,
        data: {
          "invoiceId": paymentDataModel.invoiceId,
          "status": paymentDataModel.balance < 0 ? 1 : 2,
          "creditValue":
              paymentDataModel.balance < 0 ? -paymentDataModel.balance : 0.0
        },
      );
      if (isOnlySave ?? false) {
        dataProvider.itemList.clear();
      }

      //! Create receipt number
      final rn = paymentDataModel.receiptNo;

      if (paymentDataModel.totalPayment != 0.0) {
        //! Create payment
        await respo(
          'payment/create',
          data: Payments(
            payments: [
              if (paymentDataModel.cash > 0)
                PaymentModel(
                  customerTypeId:
                      paymentDataModel.selectedCustomer.customerTypeId,
                  invoiceId: paymentDataModel.invoiceId,
                  amount: paymentDataModel.cash,
                  receiptNo: rn,
                  paymentMethod: 1,
                  chequeNo: null,
                  routecardId: paymentDataModel.currentRouteCard.routeCardId,
                  routeId: paymentDataModel.currentRouteCard.routeId,
                  customerId: paymentDataModel.selectedCustomer.customerId,
                  priceLevelId: paymentDataModel.selectedCustomer.priceLevelId,
                  employeeId: paymentDataModel.currentEmployee.employeeId,
                  status: 1,
                ).toJson(),
              ...paymentDataModel.chequeList.map(
                (cheque) => PaymentModel(
                  customerTypeId:
                      paymentDataModel.selectedCustomer.customerTypeId,
                  invoiceId: paymentDataModel.invoiceId,
                  amount: cheque.chequeAmount,
                  chequeNo: cheque.chequeNumber,
                  receiptNo: rn,
                  paymentMethod: 2,
                  routecardId: paymentDataModel.currentRouteCard.routeCardId,
                  routeId: paymentDataModel.currentRouteCard.routeId,
                  customerId: paymentDataModel.selectedCustomer.customerId,
                  priceLevelId: paymentDataModel.selectedCustomer.priceLevelId,
                  employeeId: paymentDataModel.currentEmployee.employeeId,
                  status: 1,
                ).toJson(),
              ),
            ],
          ).toJson(),
          method: Method.post,
        );
        dataProvider.chequeList.clear();
        //! Create voucher payment
        if (paymentDataModel.selectedVoucher != null) {
          await respo(
            'payment/create',
            method: Method.post,
            data: Payments(
              payments: [
                if (paymentDataModel.cash > 0)
                  PaymentModel(
                    customerTypeId:
                        paymentDataModel.selectedCustomer.customerTypeId,
                    invoiceId: paymentDataModel.invoiceId,
                    amount: paymentDataModel.selectedVoucher != null
                        ? paymentDataModel.selectedVoucher!.value
                        : 0.0,
                    chequeNo: paymentDataModel.selectedVoucher?.code,
                    receiptNo: rn,
                    paymentMethod: 3,
                    routecardId: paymentDataModel.currentRouteCard.routeCardId,
                    routeId: paymentDataModel.currentRouteCard.routeId,
                    customerId: paymentDataModel.selectedCustomer.customerId,
                    priceLevelId:
                        paymentDataModel.selectedCustomer.priceLevelId,
                    employeeId: paymentDataModel.currentEmployee.employeeId,
                    status: 1,
                  ).toJson(),
              ],
            ).toJson(),
          );
        }

        //! Add credit bill
        if (paymentDataModel.balance < 0) {
          await respo(
            'customer-credit/create',
            method: Method.post,
            data: {
              "value": paymentDataModel.balance * -1,
              "invoiceId": paymentDataModel.invoiceId,
              "customerId": paymentDataModel.selectedCustomer.customerId,
              "status": 1,
            },
          );
        }
      }
      if (paymentDataModel.balance > 0) {
        await respo(
          'customers/update',
          method: Method.put,
          data: {
            "customerId": paymentDataModel.selectedCustomer.customerId,
            "depositBalance":
                paymentDataModel.selectedCustomer.depositBalance! +
                    paymentDataModel.balance,
          },
        );
        await respo(
          'over-payment/create',
          method: Method.post,
          data: {
            "value": paymentDataModel.balance,
            "status": 1,
            "paymentInvoiceId": paymentDataModel.invoiceId,
            "routecardId": paymentDataModel.currentRouteCard.routeCardId,
            "receiptNo": rn,
            "customerId": paymentDataModel.selectedCustomer.customerId
          },
        );
      }
      if (context.mounted) {
        final invoiceProvider =
            Provider.of<InvoiceProvider>(context, listen: false);
        invoiceProvider.invoiceNu = null;
        invoiceProvider.invoiceRes = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  //! Pay credit invoice from customer deposites
  Future<void> payFromDeposite(
      CreditInvoicePayFromDipositesDataModel
          creditInvoicePayFromDipositesDataModel) async {
    try {
      await respo(
        'over-payment/update',
        method: Method.put,
        data: {
          "overPaymentsPayList": [
            {
              "value": creditInvoicePayFromDipositesDataModel.depositeValue -
                  creditInvoicePayFromDipositesDataModel.payValue,
              "customerId": creditInvoicePayFromDipositesDataModel.customerId,
              "paymentInvoiceId":
                  creditInvoicePayFromDipositesDataModel.paymentInvoiceId,
              "receiptNo":
                  creditInvoicePayFromDipositesDataModel.depositeReceiptNo
            }
          ]
        },
      );

      await respo(
        'customers/update',
        method: Method.put,
        data: {
          "customerId": creditInvoicePayFromDipositesDataModel.customerId,
          "depositBalance":
              creditInvoicePayFromDipositesDataModel.customerDepositeValue -
                  creditInvoicePayFromDipositesDataModel.payValue,
        },
      );

      final data = {
        "value": creditInvoicePayFromDipositesDataModel.payValue,
        "paymentInvoiceId":
            creditInvoicePayFromDipositesDataModel.depositeStatus == 2
                ? creditInvoicePayFromDipositesDataModel.paymentInvoiceId
                : creditInvoicePayFromDipositesDataModel.depositeId,
        "routecardId": creditInvoicePayFromDipositesDataModel.routeCardId,
        "creditInvoiceId": creditInvoicePayFromDipositesDataModel.chequeId ??
            creditInvoicePayFromDipositesDataModel.creditInvoiceId,
        "receiptNo": creditInvoicePayFromDipositesDataModel.depositeReceiptNo,
        "status": creditInvoicePayFromDipositesDataModel.chequeId != null
            ? creditInvoicePayFromDipositesDataModel.depositeStatus == 1 ? 5 : 8
            : creditInvoicePayFromDipositesDataModel.depositeStatus == 2
                ? 6
                : 1,
        "createdAt": creditInvoicePayFromDipositesDataModel.depositeCreatedDate,
        "type": creditInvoicePayFromDipositesDataModel.chequeId != null
            ? "return-cheque"
            : 'default'
      };
      try {
       final response = await respo('credit-payment/create', method: Method.post, data: data);
       if (kDebugMode) {
          print(response.data);
          print(response.error);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      

      if (creditInvoicePayFromDipositesDataModel.crediteInvoiceValue <=
              creditInvoicePayFromDipositesDataModel.payValue &&
          creditInvoicePayFromDipositesDataModel.chequeId == null) {
        await respo('invoice/update', method: Method.put, data: {
          "invoiceId": creditInvoicePayFromDipositesDataModel.creditInvoiceId,
          "status": 2
        });
      }

      if (creditInvoicePayFromDipositesDataModel.chequeId != null) {
        if (creditInvoicePayFromDipositesDataModel.crediteInvoiceValue <=
            creditInvoicePayFromDipositesDataModel.payValue) {
          await respo('cheque/update', method: Method.put, data: {
            "id": creditInvoicePayFromDipositesDataModel.chequeId,
            "isActive": 2,
            "balance": 0
          });
        } else {
          await respo('cheque/update', method: Method.put, data: {
            "id": creditInvoicePayFromDipositesDataModel.chequeId,
            "balance":
                creditInvoicePayFromDipositesDataModel.crediteInvoiceValue -
                    creditInvoicePayFromDipositesDataModel.payValue
          });
        }
      }

      //! Update return cylinder invoice balance
      if (creditInvoicePayFromDipositesDataModel.depositeStatus == 2) {
        await respo('return-cylinder-invoice/update',
            method: Method.put,
            data: {
              "invoiceNo":
                  creditInvoicePayFromDipositesDataModel.depositeReceiptNo,
              "balance":
                  creditInvoicePayFromDipositesDataModel.crediteInvoiceValue -
                      creditInvoicePayFromDipositesDataModel.payValue,
              "status": creditInvoicePayFromDipositesDataModel.depositeValue -
                          creditInvoicePayFromDipositesDataModel.payValue ==
                      0
                  ? 2
                  : 1
            });
      }
    } catch (e) {
      rethrow;
    }
  }
}
