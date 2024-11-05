class Failure {
  final String message;
  final String? errorCode;

  Failure({required this.message, this.errorCode});

  factory Failure.getDefaultError() {
    return Failure(message: 'defaultError');
  }

  factory Failure.getNetworkError() {
    return Failure(message: 'networkError');
  }

  factory Failure.fromLocalErrorCode(String errorCode) {
    return Failure(
      errorCode: errorCode,
      message: '${'defaultError'}, $errorCode',
    );
  }
}
