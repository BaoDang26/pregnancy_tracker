class BuildServer {
  static Uri buildUrl(String endpoint) {
    const String host = "https://34.142.159.243:443/api/";
    // const String host = "https://10.0.2.2:443/api/";
    // const String host = "http://35.247.135.183:9090/api/";

    final apiPath = host + endpoint;
    return Uri.parse(apiPath);
  } 
//
// static final String createOrderUrl =
//     "https://sb-openapi.zalopay.vn/v2/create";
}

class Endpoints {
  static final String createOrderUrl =
      "https://sb-openapi.zalopay.vn/v2/create";
}
