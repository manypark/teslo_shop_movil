import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    
    try {
      final response = await dio.get('/auth/check-status', 
        options: Options(
          headers: {
            'Authorization' : 'Bearer $token'
          }
        )
      );

      final user = UserMapper.userJsonToEntity( response.data );
      return user;

    } on DioException catch (e) {

      if( e.response?.statusCode == 401 ) throw CustomError( 'Token incorrecto' );
      if( e.type == DioExceptionType.connectionTimeout ) throw CustomError( 'Revisar conexión a internet' );
      throw Exception();

    } catch (e) {
      throw Exception();
    }
  }

  /// The above function is a login function in Dart that sends a POST request to a login endpoint with
  /// the provided email and password, and returns a User object if successful.
  /// 
  /// Args:
  ///   email (String): The email parameter is a string that represents the user's email address. It is
  /// used as a credential for authentication during the login process.
  ///   password (String): The "password" parameter is a string that represents the user's password. It
  /// is used as a credential for authentication during the login process.
  /// 
  /// Returns:
  ///   The method is returning a Future<User>.
  @override
  Future<User> login(String email, String password) async {

    try {

      final response = await dio.post('/auth/login', data: {
        'email'    : email,
        'password' : password
      });

      final user = UserMapper.userJsonToEntity( response.data );

      return user;
      
    } on DioException catch (e) {

      if( e.response?.statusCode == 401 ) throw CustomError( e.response?.data['message'] ?? 'Credenciales no validas' );
      if( e.type == DioExceptionType.connectionTimeout ) throw CustomError( 'Revisar conexión a internet' );
      throw Exception();

    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }
  
}
