import 'package:first/services/auth/auth_exceptions.dart';
import 'package:first/services/auth/auth_provider.dart';
import 'package:first/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();
      test('Should not be initialized to begin with', () {
        expect(provider.initialize(), false);
      });
      test('Cannot logout if not initialized', () {
        expect(provider.logout(), throwsA(const TypeMatcher<NotInitializedException>()));
      });
      test('Should be able to initialized', () async {
        await provider.initialize();
        expect(provider.initialize(), true);
      });
      test('User should be null after initialization', () {
        expect(provider.currentUser, null);
      });
      test('should be able to initialize in less than 2 second', () async {
        await provider.initialize();
        expect(provider.initialize(), true);
      }, timeout: const Timeout(Duration(seconds: 2)));
      test('create user should delegate to login function', () async {
        final badEmailUser = provider.createUser(
          email: 'saxena.mann@gmail.com',
          password: 'anypassword',
        );
        expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));
        final badPasswordUser=provider.createUser(email: 'hbfhew@gmail.com', password: '12345678');
        expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));
        final user=await provider.createUser(email: "email", password: "password") ;
        expect(provider.currentUser, user);
        expect(user?.isEmailVerified, false);
      });
      test('logged in user should be able to verify', (){
        final user=provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      });
      test('should be able to log out and login again', () async {
        await provider.logout();
        await provider.login(email: 'email', password: 'password',);
        final user=provider.currentUser;
        expect(user, isNotNull);
      });
    },
  );
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser?> createUser({required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    // TODO: implement initialize
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
    throw UnimplementedError();
  }

  @override
  Future<AuthUser?> login({required String email, required String password}) {
    // TODO: implement login
    // await Future.delayed(const Duration(seconds: 1));
    if (!isInitialized) throw NotInitializedException();
    if (email == 'saxena@gmail.com') throw UserNotFoundAuthException();
    if (password == '12345678') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    // TODO: implement logout

    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    // TODO: implement sendEmailVerification
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
