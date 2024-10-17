class ResponseSuccessResponse {
  String? paymentId;
  String? orderId;
  String? signature;

  ResponseSuccessResponse(this.paymentId, this.orderId, this.signature);

  static ResponseSuccessResponse fromMap(Map<dynamic, dynamic> map) {
    String? paymentId = map["razorpay_payment_id"];
    String? signature = map["razorpay_signature"];
    String? orderId = map["razorpay_order_id"];

    return ResponseSuccessResponse(paymentId, orderId, signature);
  }
}
