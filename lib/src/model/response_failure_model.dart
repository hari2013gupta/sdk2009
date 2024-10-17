class ResponseFailureResponse {
  int? code;
  String? message;
  Map<dynamic, dynamic>? error;

  ResponseFailureResponse({this.code, this.message, this.error});

  static ResponseFailureResponse fromMap(Map<dynamic, dynamic> map) {
    var code = map["code"] as int?;
    var message = map["message"] as String?;
    var responseBody;

    if (responseBody is Map<dynamic, dynamic>) {
      return ResponseFailureResponse(
          code: code, message: message, error: responseBody);
    } else {
      Map<dynamic, dynamic> errorMap = <dynamic, dynamic>{};
      errorMap["reason"] = responseBody;
      return ResponseFailureResponse(
          code: code, message: message, error: responseBody);
    }
  }
}
