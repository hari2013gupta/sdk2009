class ResultModel {
  int status;
  String message;
  Data? data;

  ResultModel(this.status, this.message, this.data);

  static ResultModel fromMap(Map<dynamic, dynamic> map) {
    int status = map["status"];
    String message = map["message"];
    Data? data = map["data"];

    return ResultModel(status, message, data);
  }
}

class Data {
  String refNo;

  Data({required this.refNo});
}
