class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'UP Store';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String brandsCollection = 'brands';
  static const String ordersCollection = 'orders';
  static const String cartCollection = 'cart';
  static const String wishlistCollection = 'wishlist';
  static const String addressesCollection = 'addresses';

  // SharedPreferences Keys
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';

  // Pagination
  static const int productsPerPage = 10;

  // Image Placeholders
  static const String placeholderImage =
      'https://via.placeholder.com/300x300.png?text=No+Image';

  // Supported Locales
  static const String localeEn = 'en';
  static const String localeAr = 'ar';

  // Order Status
  static const String orderStatusProcessing = 'Processing';
  static const String orderStatusShipped = 'Shipped';
  static const String orderStatusDelivered = 'Delivered';
  static const String orderStatusCancelled = 'Cancelled';

  // Payment Methods
  static const String paymentCash = 'Cash on Delivery';
  static const String paymentVisa = 'Visa';
  static const String paymentMasterCard = 'Master Card';
  static const String paymentPaypal = 'Paypal';
  static const String paymentEasypay = 'Easypay';
}
