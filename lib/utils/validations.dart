mixin Validations {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.trim().isEmpty) return message ?? 'Este campo é obrigatório!';

    return null;
  }

  String? isDropdownNotEmpty(String? value, [String? message]) {
    if (value == null) return message ?? 'Este campo é obrigatório!';

    return null;
  }

  String? isNameCompleteValid(String? name) {
    if (!RegExp(
            r"^((\b[A-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ'\s']{2,40}\b)\s*){2,}$")
        .hasMatch(name!)) {
      return 'Nome inválido!';
    }
    return null;
  }

  String? isNumberCardValid(String? number) {
    if (number!.trim().length < 16) {
      return 'Número de cartão inválido!';
    }
    return null;
  }

  String? isCVCValid(String? number) {
    if (!RegExp(r"^[0-9]{3}$").hasMatch(number!)) {
      return 'CVC inválido!';
    }
    return null;
  }

  String? isCpfValid(String? cpf) {
    if (!RegExp("([0-9]{3}[.]?[0-9]{3}[.]?[0-9]{3}[-]?[0-9]{2})")
        .hasMatch(cpf!)) {
      return 'CPF inválido!';
    }
    return null;
  }

  String? isPhoneValid(String? phone) {
    if (!RegExp(
            r'^\((?:[14689][1-9]|2[12478]|3[1234578]|5[1345]|7[134579])\) (?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}')
        .hasMatch(phone!)) {
      return 'Telefone inválido!';
    }
    return null;
  }

  String? isEmailValid(String? email) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email!)) {
      return 'E-mail inválido!';
    }
    return null;
  }

  String? isPasswordValid(String? password) {
    if (password!.trim().length < 8) {
      return 'Senha inválida!';
    }
    return null;
  }

  String? isEqualsPassword(String? password, String? confirmPassord) {
    if (password != confirmPassord) {
      return 'Senhas não conferem';
    }

    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }

    return null;
  }
}
