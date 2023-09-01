class  InvalidToken implements Exception { }
class  WrongCredentials implements Exception { }
class  ConnectionTimeout implements Exception { }
class  CustomError implements Exception {
  // final int errorCode;
  final String message;
  CustomError( this.message );
}