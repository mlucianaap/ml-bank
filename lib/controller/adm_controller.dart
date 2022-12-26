// ignore_for_file: library_private_types_in_public_api

import 'package:mlbank/models/adm.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

part 'adm_controller.g.dart';

class AdmController = _AdmController with _$AdmController;

abstract class _AdmController with Store {
  FirestoreService db = FirestoreService();

  @observable
  Adm? adm;

  @observable
  String? cpf;

  @observable
  String? password;

  @action
  Future<String> create(Adm adm) async {
    await db.createAdm(adm).catchError((_) => 'Erro ao criar Administrador.');
    this.adm = adm;
    return 'Admnistrador criado com sucesso!';
  }

  @action
  Future read() async {
    await db.readAdm().then((value) {
      if (value != null) {
        adm = Adm.fromJson(value.data() as Map<String, dynamic>);
      }
    });
  }

  @action
  setCPF(String cpf) {
    this.cpf = cpf;
  }

  @action
  setPassword(String password) {
    this.password = password;
  }
}
