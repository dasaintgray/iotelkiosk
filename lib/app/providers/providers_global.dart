import 'dart:convert';

import 'package:hasura_connect/hasura_connect.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/app/data/models_rest/weather_model.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/services/base/base_client_service.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';

class GlobalProvider extends BaseController {
  // GET
  Future<WeatherModel?> fetchWeather({String? queryParam}) async {
    final String searchParams = 'q=$queryParam';
    final weatherResponse = await HenryBaseClient()
        .getRequest(HenryGlobal.weatherURL, HenryGlobal.weatherEndpoint, HenryGlobal.defaultHttpHeaders,
            queryParam: searchParams)
        .catchError(handleError);
    if (weatherResponse != null) {
      return weatherModelFromJson(weatherResponse);
    }
    return null;
  }

  // POST

  // GRAPHQL
  Future<LanguageModel?> fetchLanguages() async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(HenryGlobal.qryLanguage).catchError(handleError);

    if (response != null) {
      return languageModelFromJson(jsonEncode(response));
    }
    return null;
  }

  // Future<TransactionModel?> fetchTransaction(String? title) async {
  //   final qryVariable = {'title': title};

  //   HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

  //   final response = await hasuraConnect.query(qryTransaction, variables: qryVariable).catchError(handleError);

  //   if (response != null) {
  //     return transactionModelFromJson(jsonEncode(response));
  //   }
  //   return null;
  // }

  Future<TransactionModel?> getTranslation() async {
    // final qryVariable = {'title': title};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(qryTranslation).catchError(handleError);

    if (response != null) {
      return transactionModelFromJson(jsonEncode(response));
    }
    return null;
  }
}
