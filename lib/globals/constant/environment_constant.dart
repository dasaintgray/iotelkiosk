import 'package:flutter_animate/flutter_animate.dart';

class HenryGlobal {
  HenryGlobal._();

  //timeout
  static const int receiveTimeOut = 20;
  static const int connectionTimeOut = 20;
  static const int sendTimeOut = 20;

  // ANIMATION SPEED
  static Duration animationSpeed = 200.ms;

  static const weatherURL = 'http://api.weatherapi.com';
  static const weatherEndpoint = '/v1/current.json?key=48954ba0e91f4dc6bfd12110223105&';
  static const weatherParams = 'q=Angeles City';

  // GRAPHQL HOST AND QUERY
  static const hostURL = 'https://gql.circuitmindz.com/v1/graphql';
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

  //HEADERS
  static var defaultHttpHeaders = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive',
  };

  // GRAPHQL HEADERS
  static var graphQlHeaders = {'Content-Type': 'application/json', 'x-hasura-admin-secret': 'iph2020agorah!'};

  static var loginBody = {"Username": "immarketplace", "Password": "uw2zkyIlUQJ73LlmaGXz176meEYWo8i7bHa5oWg3H3U="};

  static var longText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ac odio finibus, pharetra odio in, ornare lectus. Pellentesque eu faucibus justo. Aliquam lobortis nisl vitae ex interdum, ac aliquet quam ultricies. Praesent fringilla tortor et lectus sodales tempus. Nam id hendrerit orci. Etiam eget libero et mi placerat interdum. Sed tempor erat vel mattis gravida. Nunc tempor, massa id volutpat accumsan, purus erat accumsan urna, eu fermentum metus lacus vel odio.";
}

// variable query
String qryTranslation = """query getTranslation {
    Translations {
      LanguageId
      translationText
      description
      code
      images
      type
    }
  }""";

String qrySettings = """query getSettings {
    Settings {
      code
      value
      description
    }
  }""";

String qryAccomodationType = """query getAccomType {
    AccommodationTypes(order_by: {seq: asc}) {
      Id
      valueMin
      valueMax
      description
      code
      seq
    }
  }
  """;


// String qryTransaction = """query getTranslation(\$title: String!) {
//     Translations(where: {type: {_eq: \$title}}){
//       LanguageId
//       translationText
//       description
//       code
//       images
//       type
//     }
//   }""";
