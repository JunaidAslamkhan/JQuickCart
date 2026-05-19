import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/app_user_model.dart';
import 'auth_provider.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final authService = ref.read(firebaseAuthServiceProvider);
      final userFirestoreService = ref.read(userFirestoreServiceProvider);

      final userCredential = await authService.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('User account was not created. Please try again.');
      }

      final now = DateTime.now();

      final appUser = AppUserModel(
        uid: firebaseUser.uid,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: 'customer',
        createdAt: now,
        updatedAt: now,
      );

      await userFirestoreService.createUserProfile(appUser);

      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final authService = ref.read(firebaseAuthServiceProvider);

      await authService.login(
        email: email.trim(),
        password: password.trim(),
      );

      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({
    required String email,
  }) async {
    state = const AsyncLoading();

    try {
      final authService = ref.read(firebaseAuthServiceProvider);

      await authService.sendPasswordResetEmail(
        email: email.trim(),
      );

      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<void> logout() async {
    final authService = ref.read(firebaseAuthServiceProvider);
    await authService.logout();
  }
}
