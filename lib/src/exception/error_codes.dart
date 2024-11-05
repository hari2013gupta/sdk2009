class ErrorCodes {
  // remote error codes
  static const String authenticationError = 'authentication_error';
  static const String emailAlreadyExist = 'email_already_exist';

  // local error codes
  static const String userMappingError = "001";
  static const String productMappingError = "002";

  // get Translated message from language file
  static String? getTranslatedErrorMessage(String? errorCode) {
    switch (errorCode) {
      case ErrorCodes.authenticationError:
        return 'authenticationError';
      case ErrorCodes.emailAlreadyExist:
        return 'emailAlreadyExist';
      default:
        return null;
    }
  }
}