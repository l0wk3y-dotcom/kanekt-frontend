class JwtToken {
  final String accessToken;
  final String refreshToken;
  JwtToken({required this.accessToken, required this.refreshToken});

  factory JwtToken.fromjson(Map<String, dynamic> json) {
    return JwtToken(accessToken: json["access"], refreshToken: json["refresh"]);
  }
}
