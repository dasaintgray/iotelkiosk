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
  static const hostURL = "http://sandbox.ad.circuitmindz.com:5000/graphql";
  static const hostREST = "http://sandbox.ad.circuitmindz.com:5000";
  static const sandboxGQL = 'http://sandbox.ad.circuitmindz.com:5000/graphql';

  static const userEP = '/api/users/login';

  static const qryLanguage = """
      query GetLanguages {
      Languages {
        Id
        description
        code
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
    lenguwahe_details: Languages_Translations {
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
String qryTranslation = r"""query getTranslation {
  Conversion: Translations(where: {isActive: {_eq: true}}) {
    LanguageId
    translationText
    description
    code
    images
    type
  }
}
""";

String qrySettings = """query getSettings {
    Settings {
      code
      value
      description
    }
  }""";

String qryAccomodationType = r"""
  query getAccomType($limit: Int!) {
    AccommodationTypes(order_by: {seq: asc}, limit: $limit) {
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
query getSeriesDetails {
  SeriesDetails(where: {ModuleId: {_eq: 5}, _and: {isActive: {_eq: true}}}, limit: 1, order_by: {Id: asc}) {
    Id
    SeriesId
    docNo
    description
    LocationId
    ModuleId
    isActive
    tranDate
    createdBy
    modifiedBy
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
  }
} 
''';

String qryRoomTypes = r'''query getRoomTypes {
  RoomTypes {
    Id
    LocationId
    isActive
    code
    description
  }
}''';

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

String qryTerminals = r'''query getTerminal {
  Terminals {
    isActive
    code
    description
    LocationId
    macAddress
    terminalDetails: Terminals_TerminalDetails {
      value
      description
    } 
  }
}''';

String qryPaymentType = r'''
query getPayment {
  payment: PaymentTypes {
    description
    code
  }
}''';

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
mutation updateSeriesDetails($ID: Int!, $DocNo: String!, 
    $isActive: Boolean!, $modifiedBy: String!, 
    $modifiedDate: datetime!, $tranDate: datetime!, $reservationDate: datetime!) {
  update_SeriesDetails(where: {Id: {_eq: $ID}, _and: {docNo: {_eq: $DocNo}}}, 
  _set: {isActive: $isActive, modifiedBy: $modifiedBy, 
    modifiedDate: $modifiedDate, tranDate: $tranDate, reservationDate: $reservationDate}) {
    returning {
      Id
      docNo
      isActive
      modifiedBy
      LocationId
      ModuleId
      SeriesId
    }
    affected_rows
  }
}
''';

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
mutation addContact($code: String!, $firstName: String!, $lastName: String!, $middleName: String!, $prefixID: Int!, $suffixID: Int!, $nationalityID: Int!, $createdDate: datetime!, $createdBy: String!, $genderID: Int!, $discriminator: String!) {
  insert_People(objects: {
    code: $code, 
    fName: $firstName, 
    lName: $lastName, 
    mName: $middleName, 
    PrefixId: $prefixID, 
    SuffixId: $suffixID, 
    NationalityId: $nationalityID, 
    createdDate: $createdDate, 
    createdBy: $createdBy, 
    GenderId: $genderID, 
    Discriminator: $discriminator}
  ) {
    returning {
      Id
      code
      Name
    }
    affected_rows
  }
}
''';

String addPhotos = r''' 
  mutation addPhoto($ContactID: Int!, $isActive: Boolean!, $Photo: String!, $createdDate: datetime!, $createdBy: String!) {
  insert_ContactPhotoes(objects: {
    ContactId: $ContactID, 
    isActive: $isActive, 
    photo: $Photo,
    createdDate: $createdDate,
    createdBy: $createdBy}) {
    returning {
      Id
      createdBy
    }
    affected_rows
  }
}
''';
