class Validation {
  String? emailValidation(String? value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);
    if (value!.trim().isEmpty) {
      return ('enter mail');
    } else if (!regExp.hasMatch(value.trim())) {
      return ('enter valid mail');
    } else {
      return null;
    }
  }

  String? passwordValidation(value) {
    if (value!.isEmpty || value.length < 8) {
      return ('password lenght');
    } else {
      return null;
    }
  }

  String? confirmPasswordValidation(value, String password) {
    if (value!.isEmpty || value.length < 6) {
      return ('password lenght');
    } else if (password != value) {
      return ('password dosent match');
    } else {
      return null;
    }
  }

  String? defaultValidation(value) {
    if (value!.isEmpty) {
      return ("emptyfield");
    } else {
      return null;
    }
  }
}
