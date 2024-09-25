/// Base Result class
/// [S] represents the type of the success value
/// [E] should be [Exception] or a subclass of it
sealed class Result<S, E extends Exception> {
  const Result();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}

///example to use exception
///The E extends Exception constraint is useful if we want to only represent exceptions of type Exception or a subclass of it (which is the convention followed by all Flutter core libraries).
///// 1. change the return type
// Future<Result<Location, Exception>> getLocationFromIP(String ipAddress) async {
//   try {
//     final uri = Uri.parse('http://ip-api.com/json/$ipAddress');
//     final response = await http.get(uri);
//     switch (response.statusCode) {
//       case 200:
//         final data = json.decode(response.body);
//         // 2. return Success with the desired value
//         return Success(Location.fromMap(data));
//       default:
//         // 3. return Failure with the desired exception
//         return Failure(Exception(response.reasonPhrase));
//     }
//   } on Exception catch (e) {
//     // 4. return Failure here too
//     return Failure(e);
//   }
// }
/// result of call
// final value = switch (result) {
//   Success(value: final location) => location.toString(),
//   Failure(exception: final exception) => 'Something went wrong: $exception',
// };
// print(value);
// In simple terms: we must handle all cases inside the switch statement.
// The Result type: Benefits
// Here's what we have learned so far:
//
// The Result type lets us explicitly declare success and failure types in the signature of a function or method in Dart
// We can use pattern matching in the calling code to ensure we handle both cases explicitly