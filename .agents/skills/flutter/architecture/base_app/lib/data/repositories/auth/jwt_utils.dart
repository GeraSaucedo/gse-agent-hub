import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtUtils {
  static Future<bool> isTokenValid(String token) async {
    try {
      // Decode the JWT to access its payload without verifying the signature
      final jwt = JWT.decode(token);

      // Extract 'exp' claim and convert Unix
      // timestamp (seconds) to DateTime (milliseconds)
      final payload = jwt.payload as Map<String, dynamic>;
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(
        (payload['exp'] as int) * 1000,
      );

      // Safety margin to account for clock skew and network latency
      const threshold = Duration(minutes: 10);

      // Check if current time is still within the safe operational window
      return DateTime.now().isBefore(expirationDate.subtract(threshold));
    } catch (e) {
      // If decoding fails or 'exp' is missing, treat the token as invalid
      return false;
    }
  }

}
