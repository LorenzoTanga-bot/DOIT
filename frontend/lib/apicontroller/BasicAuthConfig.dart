class BasicAuthConfig {
  static final BasicAuthConfig _singleton = BasicAuthConfig._internal();

  factory BasicAuthConfig() {
    return _singleton;
  }

  BasicAuthConfig._internal();

  Future<Map<String, String>> getHeader() async {
    return {"content-type": "application/json", "accept": "application/json"};
  }
}
