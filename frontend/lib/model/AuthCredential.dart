enum UserRole {
  PROJECT_PROPOSER,
  EXPERT,
  DESIGNER_ENTITY,
  DESIGNER_PERSON,
  NOT_COMPLETED
}

class AuthCredential {
  String _mail;
  String _password;
  List<UserRole> _roles = [];

  AuthCredential(this._mail, this._password);

  AuthCredential.complete(this._mail, this._password, this._roles);

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
}
