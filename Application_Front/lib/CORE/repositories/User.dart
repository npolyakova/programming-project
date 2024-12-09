
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

class ProtectedResponse {
  final String message;
  final int userId;

  ProtectedResponse({
    required this.message,
    required this.userId,
  });

  factory ProtectedResponse.fromJson(Map<String, dynamic> json) {
    return ProtectedResponse(
      message: json['message'],
      userId: json['user_id'],
    );
  }
}

