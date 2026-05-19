class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code,
  });
}

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
  });
}

class FirestoreException extends AppException {
  const FirestoreException({
    required super.message,
    super.code,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.code,
  });
}

// Firebase Auth error code mapper
class FirebaseAuthExceptionMapper {
  static String getMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'This sign-in method is not allowed.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
