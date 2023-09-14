sealed class Util {
  static bool validateRegistration(String username, String email, String password, String prePassword) {
    return username.isNotEmpty && email.length >= 6 && password.isNotEmpty && password == prePassword;
  }
}