// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adm_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdmController on _AdmController, Store {
  late final _$admAtom = Atom(name: '_AdmController.adm', context: context);

  @override
  Adm? get adm {
    _$admAtom.reportRead();
    return super.adm;
  }

  @override
  set adm(Adm? value) {
    _$admAtom.reportWrite(value, super.adm, () {
      super.adm = value;
    });
  }

  late final _$cpfAtom = Atom(name: '_AdmController.cpf', context: context);

  @override
  String? get cpf {
    _$cpfAtom.reportRead();
    return super.cpf;
  }

  @override
  set cpf(String? value) {
    _$cpfAtom.reportWrite(value, super.cpf, () {
      super.cpf = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_AdmController.password', context: context);

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$createAsyncAction =
      AsyncAction('_AdmController.create', context: context);

  @override
  Future<String> create(Adm adm) {
    return _$createAsyncAction.run(() => super.create(adm));
  }

  late final _$readAsyncAction =
      AsyncAction('_AdmController.read', context: context);

  @override
  Future<dynamic> read() {
    return _$readAsyncAction.run(() => super.read());
  }

  late final _$_AdmControllerActionController =
      ActionController(name: '_AdmController', context: context);

  @override
  dynamic setCPF(String cpf) {
    final _$actionInfo = _$_AdmControllerActionController.startAction(
        name: '_AdmController.setCPF');
    try {
      return super.setCPF(cpf);
    } finally {
      _$_AdmControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPassword(String password) {
    final _$actionInfo = _$_AdmControllerActionController.startAction(
        name: '_AdmController.setPassword');
    try {
      return super.setPassword(password);
    } finally {
      _$_AdmControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
adm: ${adm},
cpf: ${cpf},
password: ${password}
    ''';
  }
}
