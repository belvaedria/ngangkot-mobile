import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  User? _currentUser;

  // Dummy users untuk testing
  final List<User> _dummyUsers = [
    User(
      id: '1',
      name: 'Sabil',
      email: 'sabil@ngangkot.com',
      password: 'sabil123',
      avatar: null,
    ),
    User(
      id: '2',
      name: 'Arkan',
      email: 'arkan@ngangkot.com',
      password: 'arkan123',
      avatar: null,
    ),
    User(
      id: '3',
      name: 'Belva',
      email: 'belva@ngangkot.com',
      password: 'belva123',
      avatar: null,
    ),
  ];

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());

      // Simulasi delay network
      await Future.delayed(const Duration(milliseconds: 1000));

      // Validasi email dan password dari dummy list
      final user = _dummyUsers.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Email atau password salah'),
      );

      // Simpan current user
      _currentUser = user;

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void logout() {
    _currentUser = null;
    emit(AuthInitial());
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  bool isAuthenticated() {
    return _currentUser != null;
  }

  String? getCurrentUserName() {
    return _currentUser?.name;
  }

  String? getCurrentUserEmail() {
    return _currentUser?.email;
  }
}
