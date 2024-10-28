class SdkException implements Exception {
  final String? msg;

  const SdkException({this.msg});

  @override
  String toString() {
    if (msg == null) {
      return super.toString();
    } else {
      var b = StringBuffer()
        ..write(msg);
      return b.toString();
    }
  }
}