import 'package:flutter_animate/flutter_animate.dart';

class HenryGlobal {
  HenryGlobal._();

  //timeout
  static const int receiveTimeOut = 20;
  static const int connectionTimeOut = 20;
  static const int sendTimeOut = 20;

  // LOCAL STORAGE
  static const jwtToken = 'accessToken';
  static const jwtExpire = 'tokenExpire';

  // ANIMATION SPEED
  static Duration animationSpeed = 200.ms;

  static const weatherURL = 'http://api.weatherapi.com';
  static const weatherEndpoint = '/v1/current.json?key=48954ba0e91f4dc6bfd12110223105&';
  static const weatherParams = 'q=Angeles City';

  //HEADERS
  static var defaultHttpHeaders = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive',
  };

  // HTTP AVAILABLE ROOMS
  static const availableRoomsURL = "http://msdb1.ad.circuitmindz.com/_json/getAvailableRoomsForce";

  // GRAPHQL HEADERS
  static var graphQlHeaders = {'Content-Type': 'application/json', 'x-hasura-admin-secret': 'iph2020agorah!'};

  static var loginBody = {"Username": "immarketplace", "Password": "uw2zkyIlUQJ73LlmaGXz176meEYWo8i7bHa5oWg3H3U="};
  static var userLogin = {'username': 'admin', 'password': 'admin1'};

  // GRAPHQL HOST AND QUERY
  // static const hostURL = "https://gql.circuitmindz.com/v1/graphql";
  // static const hostURL = "https://gql.circuitmindz.com/v1/graphql";

  static const hostREST = "http://sandbox.ad.circuitmindz.com:5000";
  static const sandboxGQL = 'https://quickie-gw.ad.circuitmindz.com/graphql';

  // IOTEL HARDWARE API
  static const iotelURI = 'http://qckkiosk1.ad.circuitmindz.com:6969';
  static const iotelEndPoint = '/processcommand';
  static var serviceHeaders = {"API_KEY": "#CMRJG\$@05062023!"};

  static const userEP = '/api/users/login';

  static const qryLanguage = """
      query GetLanguages {
      Languages(sortby: {by: "asc"}) {
        Id
        description
        code
        disclaimer 
        flag
      }
    }
    """;

  static var longText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ac odio finibus, pharetra odio in, ornare lectus. Pellentesque eu faucibus justo. Aliquam lobortis nisl vitae ex interdum, ac aliquet quam ultricies. Praesent fringilla tortor et lectus sodales tempus. Nam id hendrerit orci. Etiam eget libero et mi placerat interdum. Sed tempor erat vel mattis gravida. Nunc tempor, massa id volutpat accumsan, purus erat accumsan urna, eu fermentum metus lacus vel odio.";
}

String qryLenguwahe = r'''
query getLanguage {
  lenguwahe: Languages {
    Id
    code
    description
    flag
    lenguwahe_details: Translation {
      LanguageId
      code
      type
      translationText
      description
      images
    }
  }
}
''';

// variable query
String qryTranslation = r"""
query getTranslation {
  Conversion: Translations(where: {isActive: true}, sortby: {by: "asc"}) {
    LanguageId
    translationText
    description
    code
    images
    type
  }
}
""";

String qrySettings = r"""
query getSettings {
  Settings(sortby: {by: "asc"}) {
    code
    value
    description
  }
}
""";

String qryAccomodationType = r"""
  query getAccomType($limit: Int!) {
    AccommodationTypes(sortby: {by: "asc", sort: "seq"}, where: {limit: $limit, isActive: true}) {
      Id
      valueMin
      valueMax
      description
      code
      seq
    }
  }
  """;

String qryGetRooms = """query GetRooms {
  rooms: Rooms(
    where: {
      bed: {_gte: 1}, 
      isActive: {_eq: true},
      RoomTypeId: {_eq: 1},
      RoomRates: { isActive: {_eq: true}, AgentId: {_eq: 1}, AccommodationTypeId: {_eq: 1}}, 
      RoomStatus: {isHidden: {_eq: false}}, 
      _and:{
        _not: {
          Rooms_Bookings:{
            BookingStatusId: {_eq: 1}, 
            _and: {endDate: {_lt: "2023-03-31"}},
            _or: [
              {startDate:{_gte: "2023-03-31"}},
              {endDate: {_lte: "2023-03-31"}},
            ],
            cancelDate:{_is_null: true}
          }
        }
      }
    }
  ) {
    Id
    description
  }
}""";

String qrySeriesDetails = r"""
query getSeriesDetails($moduleID: Int!) {
  SeriesDetails(
    where: {ModuleId: $moduleID, isActive: true, limit: 1}
    sortby: {by: "asc", sort: "Id"}
  ) {
    Id
    SeriesId
    docNo
    description
    LocationId
    ModuleId
    isActive
    tranDate
  }
}
""";

String qryAvaiableRooms = r'''
query getAvailableRooms($agentID: Int!, $roomTypeID: Int!, 
  $accommodationTypeID: Int!, $startDate: DateTime!, $endDate: DateTime!) {
  AvailableRooms(
    where: {
      agentId: $agentID, 
      roomTypeId: $roomTypeID, 
      accommodationTypeId: $accommodationTypeID, 
      startDate: $startDate, 
      endDate: $endDate}
  ) {
    description
    rate
    serviceCharge
    photo
    id
    code
  }
} 
''';

String qryRoomTypes = r'''
query getRoomTypes($limit: Int!) {
  RoomTypes(
    where: {limit: $limit, isActive: true, LocationId: 1}
    sortby: {by: "asc", sort: "Id"}
  ) {
    Id
    isActive
    code
    description
  }
}
''';

String qryRooms = r'''
query getRooms($isInclude: Boolean!, $includeFragments: Boolean!) {
  Rooms {
    Id
    isActive @include(if: $isInclude)
    bed
    code
    description
    ...roomFragments @include(if: $includeFragments)
  }
}

fragment roomFragments on Rooms {
  LocationId
  isFunctionRoom
  RoomTypeId
  RoomCategoryId
  isWithBreakfast
  RoomStatusId
}
''';

String qryNationalities = r'''
query getNationalities($code: String!) {
  Nationalities(where: {code: {_eq: $code}}) {
    Id
    code
    description
    isActive
  }
}
''';

String qryPaymentType = r'''
query getPaymentType {
  PaymentTypes(sortby: {by: "asc", sort: "Id"}) {
    Id
    isActive
    description
    code
    isWithDetail
  }
}
''';

String qryTerms = r'''
query getTerms($languageID: Int!) {
  TranslationTerms(where: {LanguageId: $languageID}) {
    LanguageId
    translationText
  }
}''';

String qryTerminals = r'''
query getTerminals($ipa: String!) {
  Terminals(where: {ipAddress: $ipa}) {
    Id
    description
    code
    isActive
    macAddress
    ipAddress
  }
} 
''';

String qryDenomination = r'''
query denominationData($terminalID: Int!) {
  TerminalDenominations(where: {TerminalId: $terminalID}) {
    Id
    p20
    p50
    p100
    p200
    p500
    p1000
    total
    TerminalId
  }
}
''';

String qryCutOffs = r'''
query getCutOffs($isActive: Boolean!) {
  CutOffs(where: {isActive: $isActive}) {
    Id
    LocationId
    isActive
    startDate
    endDate
  }
}
''';

String getCharges = r'''
query getCharges($isDefault: Boolean!, $isActive: Boolean) {
  Charges(
    where: {isDefault: $isDefault, isActive: $isActive}
    sortby: {by: "asc", sort: "seq"}
  ) {
    Id
    locationID
    seq
    isActive
    isAllowEdit
    rate
    isDefault
    useFormula
    description
    isAllowEditQty
    isForCheckOut
    isForDebit
    code
  }
}
''';

String qryChargesV2 = r'''
query getChargesV2($code: String!) {
  Charges(sortby: {by: "asc", sort: "seq"}, where: {code: $code}) {
    Id
    locationID
    seq
    isActive
    isAllowEdit
    rate
    isDefault
    useFormula
    description
    isAllowEditQty
    isForCheckOut
    isForDebit
    code
  }
}
''';

String qryCashPositions = r'''
query getCashPosition($userName: String!) {
  CashPositions(where: {username: $userName}) {
    Id
    startDate
    endDate
    begBalance
    endBalance
    username
    CutOffId
  }
}
''';

String updateDenomination = r'''
mutation updateDenomination($bente: Int!, $tapwe: Int!, $isangdaan: Int!, $dalawangdaan: Int!, $limangdaan: Int!, $isanglibo: Int!, $total: Int!, $terminalID: Int!) {
  TerminalDenominations(
    mutate: {
      p20: $bente, 
      p50: $tapwe,
      p100: $isangdaan,
      p200: $dalawangdaan,
      p500: $limangdaan,
      p1000: $isanglibo,
      total: $total}
    where: {TerminalId: $terminalID}
  ) {
    Ids
    response
  }
}
''';

String searchBookedRooms = r'''
query searchBooking($bookingReference: String!, $bookingDate: DateTime!) {
  ViewBookings(where: {agentDocNo: $bookingReference, 
    endDate: $bookingDate, 
    startDate: $bookingDate}) {
    Id
    isWithBreakfast
    isDoNotDesturb
    wakeUpTime
    isActive
    docNo
    room
    startDate
    endDate
    RoomTypeId
    RoomType
    BookingStatusId
    BookingStatus
    roomRate
    AgentDocNo
    ContactId
    Contact
    AgentId
    description
    AccommodationType
    bed
  }
}
''';

String searchPayment = r''' 
query searchPayments($bookingNo:String!) {
  Payments(where: {bookingNo: $bookingNo}) {
    Id
    invoiceNo
    bookingNo
    tranDate
    totalQuantity
    totalAmount
    discount
    discountAmount
    vat
    vatAmount
    dueDate
    totalPaid
    balance
    cashPositionID
    chargeID
    CutOffId
  }
}
''';

// MUTATION AREA (INSERT, UPDATE, DELETE)
// ----------------------------------------------------------------------------------------------------

String login = r'''
mutation hayupsimaster {
  Login(password: "admin1", username: "admin") {
    accessToken
    creationTime
    expirationTime
    expiresIn
  }
}
''';

String updateSeries = r''' 
mutation updateSeriesDetails($bActive: Boolean!, $ID: Int!, $docNo: String!) {
  SeriesDetails(mutate: {isActive: $bActive}, where: {Id: $ID, docNo: $docNo}) {
    Ids
    response
  }
}
''';

// String updateSeries = r'''
// mutation updateSeriesDetails($ID: Int!, $DocNo: String!,
//     $isActive: Boolean!, $modifiedBy: String!,
//     $modifiedDate: datetime!, $tranDate: datetime!, $reservationDate: datetime!) {
//   update_SeriesDetails(where: {Id: {_eq: $ID}, _and: {docNo: {_eq: $DocNo}}},
//   _set: {isActive: $isActive, modifiedBy: $modifiedBy,
//     modifiedDate: $modifiedDate, tranDate: $tranDate, reservationDate: $reservationDate}) {
//     returning {
//       Id
//       docNo
//       isActive
//       modifiedBy
//       LocationId
//       ModuleId
//       SeriesId
//     }
//     affected_rows
//   }
// }
// ''';

String insertBooking = r'''
  mutation insertBookings(
    $isActive: Boolean!, 
    $RoomID: Int!, 
    $startDate: datetime!, 
    $endDate: datetime!, 
    $actualStartDate: datetime!, 
    $ContactID: Int!, 
    $AgentID: Int!, 
    $AccommodationTypeId: Int!,
    $RoomTypeID: Int!, 
    $roomRate: Float!,
    $discountAmount: Float!,
    $KeyCardID: Int!,
    $numPAX: Int!,
    $isWithBreakfast: Boolean!,
    $bed: Int!,
    $isDoNotDisturb: Boolean!,
    $wakeUpTime: datetime!
    $serviceCharge: Float!,
    $BookingStatusID: Int!,
    $docNo: String!
  ) {
    insert_Bookings(
      objects: {
        isActive: $isActive, 
        RoomId: $RoomID, 
        startDate: $startDate, 
        endDate: $endDate, 
        actualStartDate: $actualStartDate, 
        ContactId: $ContactID, 
        AgentId: $AgentID, 
        AccommodationTypeId: $AccommodationTypeId, 
        RoomTypeId: $RoomTypeID, 
        roomRate: $roomRate, 
        discountAmount: $discountAmount, 
        KeyCardId: $KeyCardID, 
        numPAX: $numPAX, 
        isWithBreakfast: $isWithBreakfast, 
        bed: $bed, 
        isDoNotDesturb: $isDoNotDisturb, 
        wakeUpTime: $wakeUpTime,  
        serviceCharge: $serviceCharge, 
        BookingStatusId: $BookingStatusID, 
        docNo: $docNo}) {
      returning {
        Id
        isActive
      }
      affected_rows
    }
  }
''';

String insertContacts = r'''
mutation addContact($code: String!, $firstName: String!, $lastName: String!, $middleName: String!, $prefixID: Int!, $suffixID: Int!, $nationalityID: Int!, $genderID: Int!, $discriminator: String!) {
  People(
    mutate: {code: $code, fName: $firstName, lName: $lastName, mName: $middleName, PrefixId: $prefixID, SuffixId: $suffixID, NationalityId: $nationalityID, GenderId: $genderID, Discriminator: $discriminator}
  ) {
    Ids
    response
  }
}
''';

// String insertContacts = r'''
// mutation addContact($code: String!, $firstName: String!, $lastName: String!, $middleName: String!, $prefixID: Int!, $suffixID: Int!, $nationalityID: Int!, $createdDate: datetime!, $createdBy: String!, $genderID: Int!, $discriminator: String!) {
//   insert_People(objects: {
//     code: $code,
//     fName: $firstName,
//     lName: $lastName,
//     mName: $middleName,
//     PrefixId: $prefixID,
//     SuffixId: $suffixID,
//     NationalityId: $nationalityID,
//     createdDate: $createdDate,
//     createdBy: $createdBy,
//     GenderId: $genderID,
//     Discriminator: $discriminator}
//   ) {
//     returning {
//       Id
//       code
//       Name
//     }
//     affected_rows
//   }
// }
// ''';

String addPhotos = r''' 
mutation addPhoto($ContactID: Int!, $isActive: Boolean!, $Photo: String!) {
  ContactPhotoes(
    mutate: {ContactId: $ContactID, isActive: $isActive, photo: $Photo}
  ) {
    Ids
    response
  }
}
''';

// MUTATION - TERMINAL DATA
String updateTerminalDataGraphQL = r''' 
mutation mutationTerminalData($STATUS: String!, $ID: Int!, $TerminalID: Int!) {
  TerminalData(
    mutate: {status: $STATUS}
    where: {Id: $ID, TerminalId: $TerminalID}
  ) {
    response
    Ids
  }
}
''';

// SUBSCRIPTION AREA
String terminalData = r''' 
subscription terminalData($terminalID: Int!, $status: String!, $delay: Int!, $iteration: Int!) {
  TerminalData(
    delay: $delay
    iteration: $iteration
    where: {status: $status, TerminalId: $terminalID}
  ) {
    meta
    status
    code
    value
    modifiedDate
    Id
    TerminalId
  }
}
''';

String addBooking = r'''
mutation addBookings($isWithBreakFast: Boolean!, $isActive: Boolean!, $isDoNotDesturb: Boolean!,
  $accommodationTypeID: Int!, $bookingStatusID: Int!, $agentID: Int!, $contactID: Int!, $cuttOffID: Int!,
  $roomTypeID: Int!, $roomID: Int!, $bed: Int!, $deposit: Float!, $discountAmount: Float!, 
  $docNo: String!, $numPax: Int!, $roomRate: Float!, $serviceCharge: Float!, 
  $actualStartDate: DateTime!, $endDate: DateTime!, $startDate: DateTime!
) {
  Bookings(
    mutate: {
      isWithBreakfast: $isWithBreakFast, isActive: $isActive, isDoNotDesturb: $isDoNotDesturb, 
      AccommodationTypeId: $accommodationTypeID, BookingStatusId: $bookingStatusID, AgentId: $agentID, 
      ContactId: $contactID, CutOffId: $cuttOffID, RoomTypeId: $roomTypeID, RoomId: $roomID, 
      bed: $bed, deposit: $deposit, discountAmount: $discountAmount, docNo: $docNo, numPAX: $numPax, 
      roomRate: $roomRate, serviceCharge: $serviceCharge, 
			actualStartDate: $actualStartDate, 
      endDate: $endDate, startDate: $startDate
    }
  ) {
    Ids
    response
  }
}
''';

String addBookingCharges = r'''
mutation addBookingCharges(
  $iBookingID: Int!,
  $iChargeID: Int!,
  $isForDebit: Boolean!,
  $quantity: Int!,
  $rate: Float!,
  $tranDate: DateTime!
) {
  BookingCharges(
    mutate: {
      BookingId: $iBookingID, 
      ChargeId: $iChargeID, 
      isForDebit: $isForDebit, 
      quantity: $quantity, 
      rate: $rate, 
      tranDate: $tranDate}
  ) {
    Ids
    response
  }
}
''';

String addPayments = r'''
mutation addPayments($cutOffID: Int!, $balance: Float!, $bookingNo: String!, 
  $discount: Int!, $discountAmount: Float!, $dueDate: DateTime!, $totalAmount: Float,
  $totalPaid: Float!, $totalQuantity: Int!, $tranDate: DateTime!, $vat: Int!, 
  $vatAmount: Float!, $invoiceNo: String!, $cashPosition: Int!, $chargeID: Int!
) {
  Payments(
    mutate: {
      CutOffId: $cutOffID, 
      balance: $balance, 
      bookingNo: $bookingNo, 
      discount: $discount, 
      discountAmount: $discountAmount, 
      dueDate: $dueDate, 
      totalAmount: $totalAmount, 
      totalPaid: $totalPaid, 
      totalQuantity: $totalQuantity, 
      tranDate: $tranDate, 
      vat: $vat, 
      vatAmount: $vatAmount, 
      invoiceNo: $invoiceNo,
      cashPositionID: $cashPosition,
      chargeID: $chargeID
      }
  ) {
    Ids
    response
  }
}
''';

String addPaymentDetails = r'''
mutation addPaymentDetails($amount: Float!, $paymentID: Int!, $paymentTypeID: Int!) {
  PaymentDetails(
    mutate: {amount: $amount, paymentID: $paymentID, paymentTypeID: $paymentTypeID}
  ) {
    Ids
    response
  }
}
''';

String updateBookingTable = r'''
mutation updateBooking($bookingNumber: Int!, $invoiceNo: String!, $cardNo:String!) {
  Bookings(mutate: {invoiceNo: $invoiceNo, cardNo: $cardNo}, 
    where: {Id: $bookingNumber}) {
    Ids
    response
  }
}
''';

String searchBooking = r'''
query searchBooking($cardno: String!) {
  Bookings(where: {cardNo: $cardno}) {
    Id
    isWithBreakfast
    isDoNotDesturb
    wakeUpTime
    BookingGroupId
    isActive
    docNo
    RoomId
    startDate
    endDate
    actualStartDate
    actualEndDate
    ContactId
    AgentId
    AccommodationTypeId
    RoomTypeId
    BookingStatusId
    remarks
    roomRate
    serviceCharge
    discountAmount
    cancelDate
    numPAX
    bed
    invoiceNo
    extensionDay
    extensionHr
    transferDate
    transferRoomId
    agentDocNo
    deposit
    cardNo
    extensionDayRate
    extensionHrRate
    CutOffId
  }
}
''';

String searchSettings = r'''
query searchSettings($code: String!) {
  Settings(where: {code: $code}) {
    Id
    isActive
    value
    description
    code
  }
}
''';

String searchKuwarto = r'''
query searchROOMS($roomName:String!) {
  Rooms(where: {description: $roomName}) {
    Id
    isActive
    description
    code
    isFunctionRoom
    minPAX
    maxPAX
    isWithBreakfast
    isLockset
    bed
  }
}
''';
