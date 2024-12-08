
class UserResponse
{
  final String token;
  UserResponse(
  {
    required this.token
  });
  factory UserResponse.fromJson(Map<String, dynamic> json)
  {
    return UserResponse(token: json['token']);
  }
}
