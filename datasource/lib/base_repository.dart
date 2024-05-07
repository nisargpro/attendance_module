import 'package:core/custom_exception.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/network/api.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:datasource/network/api_response_type.dart';

abstract class BaseRepository {
  final Api _api = Api();

  Future<dynamic> fetchData(
      {required final ApiCallType apiCallType,
      required final String apiUrl,
      final dynamic requestModel,
      final ApiResponseType? apiResponseType,
      final String? accessToken}) async {
    final internetConnected = await isInternetConnected();

    if (!internetConnected) {
      throw NoInternetException();
    }

    return _fetchApiData(apiCallType, apiUrl, requestModel, apiResponseType, accessToken);
  }

  Future<dynamic> _fetchApiData(
      final ApiCallType apiCallType,
      final String apiUrl,
      final dynamic requestModel,
      final ApiResponseType? apiResponseType,
      final String? accessToken) async {
    final apiResponse = apiCallType == ApiCallType.get
        ? await _api.get(
            apiUrl,
            requestModel,
            apiResponseType ?? ApiResponseType.json,
            accessToken,
          )
        : apiCallType == ApiCallType.put
            ? await _api.put(apiUrl, requestModel,
                apiResponseType ?? ApiResponseType.json, accessToken)
            : await _api.post(apiUrl, requestModel,
                apiResponseType ?? ApiResponseType.json, accessToken);
    return apiResponse;
  }
}
