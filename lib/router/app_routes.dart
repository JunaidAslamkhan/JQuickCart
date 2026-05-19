class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String emailSent = '/email-sent';
  static const String verifyEmail = '/verify-email';
  static const String accountCreated = '/account-created';

  // Main Shell (Bottom Nav)
  static const String home = '/home';
  static const String store = '/store';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';

  // Products
  static const String productDetail = '/product/:id';
  static const String categoryProducts = '/category/:id';
  static const String brandProducts = '/brand/:id';

  // Cart & Checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String paymentSuccess = '/payment-success';

  // Profile Sub-screens
  static const String editProfile = '/edit-profile';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String myOrders = '/my-orders';
  static const String changeName = '/change-name';

  // Helper: Product detail with id
  static String productDetailPath(String id) => '/product/$id';
  static String categoryProductsPath(String id) => '/category/$id';
  static String brandProductsPath(String id) => '/brand/$id';
}
