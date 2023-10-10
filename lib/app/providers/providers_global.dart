import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:iotelkiosk/app/data/models_graphql/accomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/availablerooms_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/bookinginfo_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/cashpositions_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/charges_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/cutoff_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/denomination_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/payment_type_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/roomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/seriesdetails_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/settings_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/terminals_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/translation_terms_model.dart';
import 'package:iotelkiosk/app/data/models_rest/apiresponse_model.dart';
import 'package:iotelkiosk/app/data/models_rest/cardissueresponse_model.dart';
import 'package:iotelkiosk/app/data/models_rest/cardresponse_model.dart';
import 'package:iotelkiosk/app/data/models_rest/roomavailable_model.dart';
import 'package:iotelkiosk/app/data/models_rest/userlogin_model.dart';
import 'package:iotelkiosk/app/data/models_rest/weather_model.dart';
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/services/base/base_client_service.dart';
import 'package:iotelkiosk/globals/services/controller/base_controller.dart';

class GlobalProvider extends BaseController {
  // REST API
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

  // ------------------------------------------------------------------------------------------------------------------------
  Future<List<RoomAvailableModel>?> fetchAvailableRooms(int? agentID, int? roomType, int? accommodationtypeid,
      DateTime? startDate, DateTime? endDate, bool? isWithBreakfast, int? bed, int? numPAX) async {
    final String queryParams =
        "?agentId=$agentID&roomTypeId=$roomType&accommodationTypeId=$accommodationtypeid&startDate=$startDate&endDate=$endDate&isWithBreakfast=$isWithBreakfast&bed=$bed&numPAX=$numPAX";

    final availRoomResponse = await HenryBaseClient()
        .getRequest(HenryGlobal.availableRoomsURL, queryParams, HenryGlobal.defaultHttpHeaders)
        .catchError(handleError);
    if (availRoomResponse != null) {
      return roomAvailableModelFromJson(availRoomResponse);
    } else {
      return null;
    }
  }

  Future<ApiResponseModel?> cashDispenserCommand({required String? cashCommand, required int? iTerminalID}) async {
    final sCommand = '?command=${cashCommand!.toUpperCase()}&Terminal=$iTerminalID';
    final sendpoint = HenryGlobal.iotelEndPoint + sCommand;
    final response = await HenryBaseClient()
        .getRequest(HenryGlobal.iotelURI, sendpoint, HenryGlobal.serviceHeaders)
        .catchError(handleError);

    if (response != null) {
      var resdata = jsonDecode(response);
      if (resdata["statuscode"] == 200) {
        // return apiResponseModelFromJson(jsonDecode(response));
        return apiResponseModelFromJson(response);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<CardIssueResponseModel?> issueRoomCard(
      {required String? cardCommand, required int? iTerminalID, Map<String, dynamic>? bodyPayload}) async {
    final sCommand = '?command=${cardCommand!.toUpperCase()}&Terminal=$iTerminalID';
    final sendpoint = HenryGlobal.iotelEndPoint + sCommand;

    final request = await HenryBaseClient()
        .postRequest(HenryGlobal.iotelURI, sendpoint, bodyPayload!, httpHeaders: HenryGlobal.serviceHeaders)
        .catchError(handleError);

    if (request != null) {
      return cardIssueResponseModelFromJson(request);
    } else {
      return null;
    }
  }

  Future<bool> printReceipt(
      {required String? url,
      required String? cardCommand,
      required int? iTerminalID,
      Map<String, dynamic>? bodyPayload}) async {
    final sCommand = '?command=${cardCommand!.toUpperCase()}&Terminal=$iTerminalID';
    final endpoint = '/processcommand$sCommand';

    final printRequest = await HenryBaseClient()
        .postRequest(url!, endpoint, bodyPayload!, httpHeaders: HenryGlobal.serviceHeaders)
        .catchError(handleError);

    if (printRequest != null) {
      return true;
    }
    return false;
  }

  Future<CardResponseModel?> readCardInfo(
      {required String? url, required String? cardCommand, required int? terminalID}) async {
    final sCommand = '?command=${cardCommand!.toUpperCase()}&Terminal=$terminalID';
    final endpoint = '/processcommand$sCommand';

    final request =
        await HenryBaseClient().getRequest(url!, endpoint, HenryGlobal.serviceHeaders).catchError(handleError);

    if (request != null) {
      return cardResponseModelFromJson(request);
    }
    return null;
  }

  // --------------------------------------------------------------------------------------------------------------------------------------

  Future<UserLoginModel?> userLogin() async {
    final response = await HenryBaseClient()
        .makeFormRequest('POST', HenryGlobal.hostREST, HenryGlobal.userEP, HenryGlobal.userLogin)
        .catchError(handleError);
    if (response != null) {
      return userLoginModelFromJson(response);
    } else {
      return null;
    }
  }
  // POST

  // GRAPHQL

  Future<SettingsModel?> fetchSettings({required Map<String, String> headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);
    final response = await hasuraConnect.query(qrySettings).catchError(handleError);
    if (response != null) {
      return settingsModelFromJson(jsonEncode(response));
    }
    return null;

    // final payload = '''{"query":"$qrySettings"}''';

    // final response = await HenryBaseClient()
    //     .requestMethod('POST', HenryGlobal.hostURL, bodyPayload: payload, headers: headers)
    //     .catchError(handleError);
    // if (response != null) {
    //   return settingsModelFromJson(response);
    // }
    // return null;
  }

  Future<LanguageModel?> fetchLanguages({int? agentID, required Map<String, String> headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final response = await hasuraConnect.query(HenryGlobal.qryLanguage).catchError(handleError);

    if (response != null) {
      // hasuraConnect.disconnect();
      return languageModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<AvailableRoomsModel?> fetchAvailableRoomsGraphQL(
      {int? agentID,
      int? roomTypeID,
      int? accommodationTypeID,
      DateTime? startDate,
      DateTime? endDate,
      required Map<String, String> headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    // String sDate = startDate?.toIso8601String().substring(0, startDate.toIso8601String().length - 3),

    final params = {
      "agentID": agentID,
      "roomTypeID": roomTypeID,
      "accommodationTypeID": accommodationTypeID,
      "startDate": startDate?.toIso8601String().substring(0, startDate.toIso8601String().length - 3),
      "endDate": endDate?.toIso8601String().substring(0, endDate.toIso8601String().length - 3)
    };

    final response =
        await hasuraConnect.query(qryAvaiableRooms, variables: params, headers: headers).catchError(handleError);

    if (response != null) {
      return availableRoomsModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<TransactionModel?> getTranslation({required Map<String, String> headers}) async {
    // final qryVariable = {'title': title};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final response = await hasuraConnect.query(qryTranslation).catchError(handleError);

    if (response != null) {
      hasuraConnect.disconnect();
      return transactionModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<AccomTypeModel?> fetchAccommodationType(int? topRecords, {required Map<String, String> headers}) async {
    // for declartion of passing parameters
    final params = {'limit': topRecords};
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final response = await hasuraConnect.query(qryAccomodationType, variables: params).catchError(handleError);

    if (response != null) {
      return accomTypeModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<SeriesDetailsModel?> fetchSeriesDetails(
      {required Map<String, String> headers, Map<String, dynamic>? params}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);
    final response = await hasuraConnect.query(qrySeriesDetails, variables: params).catchError(handleError);
    if (response != null) {
      return seriesDetailsModelFromJson(jsonEncode(response));
      // return SeriesDetailsModel.fromJson(response);
    }
    return null;
  }

  Future<RoomTypesModel?> fetchRoomTypes({required Map<String, String> headers, required int? limit}) async {
    final params = {'limit': limit};
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);
    final response = await hasuraConnect.query(qryRoomTypes, variables: params).catchError(handleError);
    if (response != null) {
      return roomTypesModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<dynamic> fetchRooms(
      {bool? isInclude = false, bool? includeFragments = false, required Map<String, String> headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final params = {"isInclude": isInclude, "includeFragments": includeFragments};

    final response = await hasuraConnect.query(qryRooms, variables: params).catchError(handleError);

    if (response != null) {
      return response;
    }
    return null;
  }

  Future<int?> fetchNationalities({String? code, required Map<String, String> headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final params = {"code": code};

    final response = await hasuraConnect.query(qryNationalities, variables: params).catchError(handleError);
    if (response["data"]["Nationalities"] != "[]") {
      var resultList = (response['data']['Nationalities'] as List);
      int? output = resultList[0]['Id'];
      return output!;
    } else {
      return 0;
    }
  }

  Future<PaymentTypeModel?> fetchPaymentType({required Map<String, String> headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);
    final response = await hasuraConnect.query(qryPaymentType).catchError(handleError);

    // print(response["data"]["PaymentTypes"] == "[]");

    if (response["data"]["PaymentTypes"] == "[]") {
      return null;
    } else {
      return paymentTypeModelFromJson(jsonEncode(response));
    }
  }

  Future<TranslationTermsModel?> fetchTerms({required Map<String, String> headers, required int? langID}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final params = {'languageID': langID};

    final response = await hasuraConnect.query(qryTerms, variables: params).catchError(handleError);
    if (response != null) {
      return translationTermsModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<TerminalsModel?> fetchTerminals({required Map<String, String> headers, required String? ipAddress}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final params = {"ipa": ipAddress};
    final response = await hasuraConnect.query(qryTerminals, variables: params).catchError(handleError);

    var terminalResponse = response["data"]["Terminals"];
    if (terminalResponse.toString() != '[]') {
      return terminalsModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<DenominationModel?> fetchDenominationData(
      {required Map<String, String> headers, required int terminalID}) async {
    final params = {"terminalID": terminalID};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final response = await hasuraConnect.query(qryDenomination, variables: params).catchError(handleError);
    // print(response["data"]["TerminalDenominations"]);

    if (response["data"]["TerminalDenominations"].toString() != "[]") {
      return denominationModelFromJson(jsonEncode(response['data']));
    } else {
      return null;
    }
  }

  Future<ChargesModel?> fetchChargesData(
      {required Map<String, String> headers, required bool? isActive, required bool? isDefault}) async {
    final params = {"isDefault": isActive, "isActive": isDefault};
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final response = await hasuraConnect.query(getCharges, variables: params).catchError(handleError);
    if (response['data']['Charges'].toString() != "[]") {
      return chargesModelFromJson(jsonEncode(response));
    } else {
      return null;
    }
  }

  // CUT OFF
  Future<CutOffModel?> fetchCutOffData({required Map<String, String> headers, required bool isActive}) async {
    final params = {"isActive": isActive};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final cutOffResponse = await hasuraConnect.query(qryCutOffs, variables: params).catchError(handleError);

    if (cutOffResponse["data"]["CutOffs"].toString() != "[]") {
      return cutOffModelFromJson(jsonEncode(cutOffResponse));
    } else {
      return null;
    }
  }

  // CASH POSITIONS
  Future<CashPositionModel?> fetchCashPositions(
      {required Map<String, String> headers, required String? username}) async {
    final params = {"userName": username!};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    final response = await hasuraConnect.query(qryCashPositions, variables: params).catchError(handleError);
    if (response["data"]["CashPositions"].toString() != "[]") {
      return cashPositionModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<ChargesModel?> fetchChargesV2({required Map<String, String> headers, required String? code}) async {
    final params = {"code": code};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);
    final response = await hasuraConnect.query(qryChargesV2, variables: params).catchError(handleError);

    if (response["data"]["Charges"].toString() != "[]") {
      return chargesModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<BookingInfoModel?> fetchBookingInfo(
      {required String? bookingNumber, required Map<String, String>? accessHeader}) async {
    final searchParams = {'bookingReference': bookingNumber};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: accessHeader);
    final response = await hasuraConnect.query(searchBookedRooms, variables: searchParams).catchError(handleError);

    if (response["data"]["ViewBookings"].toString() != "[]") {
      return bookingInfoModelFromJson(jsonEncode(response));
    }
    return null;
  }

  // DYNAMIC AND GLOBAL FETCH ON ALL QUERY
  //  -----------------------------------------------------------------------------------------------------
  Future<dynamic> executeGraphQLData(
      {String? documents, Map<String, dynamic>? params, Map<String, String>? headers, bool? isConvert}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(documents!, variables: params, headers: headers).catchError(handleError);
    if (response != null) {
      if (isConvert!) {
        return jsonEncode(response);
      } else {
        return response;
      }
    } else {
      return null;
    }
  }
  //  -----------------------------------------------------------------------------------------------------

  // SUBSCRIPTION AREA -----------------------------------------------------------------------------------------------------
  // Future<dynamic> terminalDataSubscription({required Map<String, String> headers}) async {
  //   HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

  //   Map<String, dynamic> variables = {"terminalID": 3, "status": "New", "delay": 5, "iteration": 5};

  //   Snapshot snapshot = await hasuraConnect.subscription(terminalData, headers: headers, variables: variables);
  //   // snapshot.listen(
  //   //   (event) {
  //   //     print(event);
  //   //   },
  //   // ).onError(handleError);
  //   // snapshot.listen((event) => print('event: $event')).onData((data) => print('DATA: $data'));
  //   // snapshot.listen((event) => print('EVENT: $event')).onError(handleError);
  //   return null;
  // }

  Future<Snapshot<dynamic>> eventDataSubscription(
      {required Map<String, String> headers, required Map<String, dynamic> variables}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);
    return await hasuraConnect.subscription(terminalData, variables: variables);
  }

  // SUBSCRIPTION AREA -----------------------------------------------------------------------------------------------------

  //MUTATION GLOBAL
  Future<dynamic> mutateGraphQLData(
      {required String? documents, Map<String, dynamic>? variables, Map<String, String>? accessHeaders}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: accessHeaders);

    var response = await hasuraConnect.mutation(documents!, variables: variables).catchError(handleError);
    if (response != null) {
      // return jsonEncode(response);
      return response;
    } else {
      return null;
    }
  }

  // MUTATION AREA (INSERT, UPDATE, DELETE)
  Future<int>? addContacts(
      {String? code,
      String? firstName,
      String? lastName,
      String? middleName,
      int? prefixID = 1,
      int? suffixID = 1,
      int? nationalityID = 77,
      int? genderID = 1,
      String? discriminitor,
      required Map<String, String> headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: headers);

    // final dtNow = DateTime.now();
    // var ngayon = createdDate?.toIso8601String();
    // if (ngayon != null && ngayon.length >= 5) {
    //   ngayon = ngayon.substring(0, ngayon.length - 3);
    // }

    final addParams = {
      "code": code!,
      "firstName": firstName!.toString(),
      "lastName": lastName!.toString(),
      "middleName": middleName!.toString(),
      "prefixID": prefixID!,
      "suffixID": suffixID!,
      "nationalityID": nationalityID!,
      "genderID": genderID!,
      "discriminator": discriminitor!
    };

    // var json = jsonEncode(addParams);
    // if (kDebugMode) print(json);

    var addResponse = await hasuraConnect.mutation(insertContacts, variables: addParams).catchError(handleError);
    if (addResponse['data']['People']["response"] == "Success") {
      var resultList = addResponse['data']['People']["Ids"] as List;
      if (kDebugMode) print(resultList[0]);
      return resultList[0];
    } else {
      return 0;
    }
  }

  Future<bool> addContactPhotoes(
      {int? contactID,
      bool? isActive = true,
      String? photo,
      // DateTime? createdDate,
      // String? createdBy,
      required Map<String, String>? accessHeader}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: accessHeader);

    // var ngayon = createdDate?.toIso8601String();
    // if (ngayon != null && ngayon.length >= 5) {
    //   ngayon = ngayon.substring(0, ngayon.length - 3);
    // }

    final addParams = {
      "ContactID": contactID,
      "isActive": isActive,
      "Photo": photo,
      // "createdDate": ngayon,
      // "createdBy": createdBy
    };

    // var result = jsonEncode(addParams);
    // if (kDebugMode) print(result);

    var response = await hasuraConnect.mutation(addPhotos, variables: addParams).catchError(handleError);
    if (response != null) {
      // var resultList = (response['data']['insert_ContactPhotoes']['returning'] as List);
      // int? output = resultList.first['Id'];
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> updateSeriesDetails(
      {required int? idNo,
      required String? docNo,
      required bool? isActive,
      required String? tranDate,
      required Map<String, String>? accessHeader}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: accessHeader);

    // var ngayon = modifiedDate?.toIso8601String();
    // if (ngayon != null && ngayon.length >= 5) {
    //   ngayon = ngayon.substring(0, ngayon.length - 3);
    // }

    final updateParams = {"ID": idNo, "docNo": docNo, "bActive": isActive, "tranDate": tranDate};

    var jsondata = jsonEncode(updateParams);
    if (kDebugMode) print(jsondata);

    var response = await hasuraConnect.mutation(updateSeries, variables: updateParams).catchError(handleError);
    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future addBookings(
      {bool? isActive,
      int? roomID,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? actualStartDate,
      int? contactID,
      int? agentID,
      int? accommodationTypeID,
      int? roomTypeID,
      double? roomRate,
      double? discountAmount,
      int? keycardID,
      int? numPAX,
      bool? isWithBreakfast,
      int? bed,
      bool? isDoNotDesturb,
      DateTime? wakeUpTime,
      double? serviceCharge,
      int? bookingStatusId,
      String? docNo}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL, headers: HenryGlobal.graphQlHeaders);

    final addParams = {
      "isActive": isActive,
      "roomID": roomID,
      "startDate": startDate,
      "endDate": endDate,
      "actualDate": actualStartDate,
      "contactID": contactID,
      "agentID": agentID,
      "accommodationTypeID": accommodationTypeID,
      "roomTypeID": roomTypeID,
      "roomRate": roomRate,
      "discountAmount": discountAmount,
      "keycardID": keycardID,
      "numPAX": numPAX,
      "isWithBreakfast": isWithBreakfast,
      "bed": bed,
      "isDoNotDesturb": isDoNotDesturb,
      "wakeUpTime": wakeUpTime,
      "serviceCharge": serviceCharge,
      "bookingStatusId": bookingStatusId,
      "docNo": docNo
    };

    final response = await hasuraConnect
        .mutation(insertBooking, variables: addParams, headers: HenryGlobal.graphQlHeaders)
        .catchError(handleError);

    if (response != null) {
      return response;
    }
  }
}
