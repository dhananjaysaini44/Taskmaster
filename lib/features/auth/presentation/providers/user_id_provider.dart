import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_provider.dart';

part 'user_id_provider.g.dart';

@riverpod
String? userId(UserIdRef ref) {
  final authState = ref.watch(authProvider);
  return authState.value?.maybeMap(
    authenticated: (a) => a.user.uid,
    orElse: () => null,
  );
}
