import 'package:bloc/bloc.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';

class AuthCubit extends Cubit<void> {
  AuthCubit(this._authRepository) : super(null);

  final AuthRepository _authRepository;

  Future<void> checkAuthStatus() => _authRepository.isUserLogged();

  Future<void> logout() => _authRepository.logout();
}
