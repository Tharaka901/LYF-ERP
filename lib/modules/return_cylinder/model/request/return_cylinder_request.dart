class ReturnCylinderInvoiceRequest {
  final ReturnCylinderInvoice invoice;
  final List<ReturnCylinderInvoiceItem> invoiceItems;

  ReturnCylinderInvoiceRequest({
    required this.invoice,
    required this.invoiceItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoice': invoice.toJson(),
      'invoiceItems': invoiceItems.map((item) => item.toJson()).toList(),
    };
  }
}

class ReturnCylinderInvoice {
  final String invoiceNo;
  final int routecardId;
  final int customerId;
  final int employeeId;
  final int status;
  final double total;
  final double vatAmount;
  final double withoutVat;
  final double nonRefundableAmount;
  final String balance;

  ReturnCylinderInvoice({
    required this.invoiceNo,
    required this.routecardId,
    required this.customerId,
    required this.employeeId,
    required this.status,
    required this.total,
    required this.vatAmount,
    required this.withoutVat,
    required this.nonRefundableAmount,
    required this.balance,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoiceNo': invoiceNo,
      'routecardId': routecardId,
      'customerId': customerId,
      'employeeId': employeeId,
      'status': status,
      'total': total,
      'vatAmount': vatAmount,
      'withoutVat': withoutVat,
      'nonRefundableAmount': nonRefundableAmount,
      'balance': balance,
    };
  }
}

class ReturnCylinderInvoiceItem {
  final int itemId;
  final int itemQty;
  final int routecardId;
  final int customerId1;
  final double price;
  final double nonVatAmount;

  ReturnCylinderInvoiceItem({
    required this.itemId,
    required this.itemQty,
    required this.routecardId,
    required this.customerId1,
    required this.price,
    required this.nonVatAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemQty': itemQty,
      'routecardId': routecardId,
      'customerId1': customerId1,
      'price': price,
      'nonVatAmount': nonVatAmount,
    };
  }
}
