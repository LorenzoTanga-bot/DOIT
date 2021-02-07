enum UserRole { PROJECT_PROPOSER, EXPERT, DESIGNER, NOT_COMPLETED }

class AuthCredential {
  String _mail;
  String _password;
  List<UserRole> _roles = [];
  String _id;

  AuthCredential(String mail, String password) {
    _mail = mail;
    _password = password;
    _id = "";
  }
  AuthCredential.complete(String mail, String password, List<UserRole> roles) {
    this._mail = mail;
    this._roles = roles;
    this._password = password;
  }

  String getMail() {
    return _mail;
  }

  String getPassword() {
    return _password;
  }

  void setPassword(String pass) {
    this._password = pass;
  }

  void setRoles(List<UserRole> roles) {
    this._roles = roles;
  }

  List<UserRole> getRoles() {
    return _roles;
  }

  List<String> getRolesToString() {
    List<String> roles = [];
    for (UserRole item in _roles) {
      roles.add(item.toString().substring(item.toString().indexOf('.') + 1));
    }
    return roles;
  }

  String getId() {
    return _id;
  }
}
