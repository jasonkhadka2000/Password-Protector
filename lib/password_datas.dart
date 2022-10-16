final String tablepasswords="accountdetails";

class PasswordFields{


  static final String columnid="_id";
  static final String columnaccountof="account";
  static final String columnpassword="password";
  static final String columnusername="username";
}


class PasswordDetails{

  int? id;
  String account;
  String username;
  String password;

  PasswordDetails({
    this.id,
    required this.account,
    required this.username,
    required this.password,
  });
}