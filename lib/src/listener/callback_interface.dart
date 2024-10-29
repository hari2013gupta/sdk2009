import 'package:sdk2009/src/model/response_failure_model.dart';
import 'package:sdk2009/src/model/response_success_model.dart';

abstract class PluginCallback {
  void onSuccess(ResponseSuccessResponse eventSuccessMessage);
  void onFailed(ResponseFailureResponse eventFailedMessage);
}