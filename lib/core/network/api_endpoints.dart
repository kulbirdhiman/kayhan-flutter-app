/// Every backend path in one place.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const signIn = '/v1/auth/sign_in';
  static const signUp = '/v1/auth/sign_up';
  static const myProfile = '/v1/auth/my_profile';
  static const sendOtp = '/v1/auth/send_otp/';
  static const verifyOtp = '/v1/auth/verify_otp/';
  static const setPassword = '/v1/auth/set_password/';
  static const changePassword = '/v1/auth/change_password';

  // Home
  static const weeklyHighlights = '/v1/home/weekly_highlights';
  static const hotDeals = '/v1/home/hot_deals';
  static const audioProducts = '/v1/home/audio_product';
  static const accessoryProducts = '/v1/home/acessory_product';
  static const comboDeals = '/v1/combodeals';

  // Catalog
  static const departments = '/v1/department/list';
  static const categories = '/v1/category/list';
  static String categoryDetail(String slug) => '/v1/category/detail/$slug';
  static const shopProducts = '/v1/product/list/shop';
  static String productDetail(String slug) => '/v1/product/list/$slug';

  // Vehicles
  static String carModelYears(int modelId) => '/v1/car_model/detail/$modelId';
}
