import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.authenticated(AppUser user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
}
