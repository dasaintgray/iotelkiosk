import 'dart:convert';

import 'package:hasura_connect/hasura_connect.dart';
import 'package:iotelkiosk/app/data/models_graphql/accomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/availablerooms_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/languages_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/paymentType_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/roomtype_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/seriesdetails_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/settings_model.dart';
import 'package:iotelkiosk/app/data/models_graphql/transaction_model.dart';
import 'package:iotelkiosk/app/data/models_rest/roomavailable_model.dart';
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

  // POST

  // GRAPHQL
  Future<LanguageModel?> fetchLanguages({int? agentID}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(HenryGlobal.qryLanguage).catchError(handleError);

    if (response != null) {
      return languageModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<AvailableRoomsModel?> fetchAvailableRoomsGraphQL(
      {int? agentID, int? roomTypeID, int? accommodationTypeID, DateTime? startDate, DateTime? endDate}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.sandboxGQL);

    final params = {
      "agentID": agentID,
      "roomTypeID": roomTypeID,
      "accommodationTypeID": accommodationTypeID,
      "startDate": startDate?.toIso8601String().substring(0, startDate.toIso8601String().length - 3),
      "endDate": endDate?.toIso8601String().substring(0, endDate.toIso8601String().length - 3)
    };

    final response = await hasuraConnect.query(qryAvaiableRooms, variables: params).catchError(handleError);

    if (response != null) {
      return availableRoomsModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<TransactionModel?> getTranslation() async {
    // final qryVariable = {'title': title};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(qryTranslation).catchError(handleError);

    if (response != null) {
      return transactionModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<SettingsModel?> fetchSettings() async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(qrySettings).catchError(handleError);

    if (response != null) {
      return settingsModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<AccomTypeModel?> fetchAccommodationType(int? topRecords) async {
    // for declartion of passing parameters
    final params = {'limit': topRecords};

    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(qryAccomodationType, variables: params).catchError(handleError);

    if (response != null) {
      return accomTypeModelFromJson(jsonEncode(response));
    }
    return null;
  }

  Future<SeriesDetailsModel?> fetchSeriesDetails() async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(qrySeriesDetails).catchError(handleError);

    if (response != null) {
      // return seriesDetailsModelFromJson(response);
      return SeriesDetailsModel.fromJson(response);
    }

    return null;
  }

  Future<RoomTypesModel?> fetchRoomTypes() async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(qryRoomTypes).catchError(handleError);

    if (response != null) {
      return roomTypesModelFromJson(jsonEncode(response));
    }

    return null;
  }

  Future<dynamic> fetchRooms({bool? isInclude = false, bool? includeFragments = false}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final params = {"isInclude": isInclude, "includeFragments": includeFragments};

    final response = await hasuraConnect.query(qryRooms, variables: params).catchError(handleError);

    if (response != null) {
      return response;
    }

    return null;
  }

  Future<int?> fetchNationalities({String? code}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final params = {"code": code};

    final response = await hasuraConnect.query(qryNationalities, variables: params).catchError(handleError);
    if (response != null) {
      var resultList = (response['data']['Nationalities'] as List);
      int? output = resultList[0]['Id'];
      return output!;
    } else {
      return 0;
    }
  }

  Future<PaymentTypeModel?> fetchPaymentType() async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(qryPaymentType).catchError(handleError);
    if (response != null) {
      return paymentTypeModelFromJson(jsonEncode(response));
    }
    return null;
  }

  // DYNAMIC AND GLOBAL FETCH ON ALL QUERY
  //  -----------------------------------------------------------------------------------------------------
  Future<dynamic> fetchGraphQLData(
      {String? documents, Map<String, dynamic>? params, Map<String, String>? headers}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    final response = await hasuraConnect.query(documents!, variables: params, headers: headers).catchError(handleError);
    if (response != null) {
      return jsonEncode(response);
    } else {
      return null;
    }
  }
  //  -----------------------------------------------------------------------------------------------------

  // MUTATION AREA (INSERT, UPDATE, DELETE)
  Future<int>? addContacts(
      {String? code,
      String? firstName,
      String? lastName,
      String? middleName,
      int? prefixID = 1,
      int? suffixID = 1,
      int? nationalityID = 77,
      DateTime? createdDate,
      String? createdBy,
      int? genderID = 1,
      String? discriminitor}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    // final dtNow = DateTime.now();
    var ngayon = createdDate?.toIso8601String();
    if (ngayon != null && ngayon.length >= 5) {
      ngayon = ngayon.substring(0, ngayon.length - 3);
    }

    final addParams = {
      "code": code!,
      "firstName": firstName!.toString(),
      "lastName": lastName!.toString(),
      "middleName": middleName!.toString(),
      "prefixID": prefixID!,
      "suffixID": suffixID!,
      "nationalityID": nationalityID!,
      "createdDate": ngayon,
      "createdBy": createdBy!,
      "genderID": genderID!,
      "discriminator": discriminitor!
    };

    // var json = jsonEncode(addParams);
    // print(json);

    var response = await hasuraConnect.mutation(insertContacts, variables: addParams).catchError(handleError);
    if (response != null) {
      var resultList = (response['data']['insert_People']['returning'] as List);

      int? output = resultList.first['Id'];
      return output!;
    } else {
      return 0;
    }
  }

  Future<bool> addContactPhotoes(
      {int? contactID, bool? isActive = true, String? photo, DateTime? createdDate, String? createdBy}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    var ngayon = createdDate?.toIso8601String();
    if (ngayon != null && ngayon.length >= 5) {
      ngayon = ngayon.substring(0, ngayon.length - 3);
    }

    final addParams = {
      "ContactID": contactID,
      "isActive": isActive,
      "Photo": photo,
      "createdDate": ngayon,
      "createdBy": createdBy
    };

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
      {int? idNo, String? docNo, bool? isActive, String? modifiedBy, DateTime? modifiedDate}) async {
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

    var ngayon = modifiedDate?.toIso8601String();
    if (ngayon != null && ngayon.length >= 5) {
      ngayon = ngayon.substring(0, ngayon.length - 3);
    }

    final updateParams = {
      "ID": idNo,
      "DocNo": docNo,
      "isActive": isActive,
      "modifiedBy": modifiedBy,
      "modifiedDate": ngayon,
      "tranDate": ngayon,
      "reservationDate": ngayon
    };

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
    HasuraConnect hasuraConnect = HasuraConnect(HenryGlobal.hostURL, headers: HenryGlobal.graphQlHeaders);

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
