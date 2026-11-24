// Eroarea pe care Domain o expune către UI. Stratul Data transformă erorile tehnice (Dio, JSON) în AppException,
// așa că Presentation nu știe nimic despre HTTP: doar afișează mesajul.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
