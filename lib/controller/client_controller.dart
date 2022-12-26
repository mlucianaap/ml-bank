// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mlbank/models/client.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

part 'client_controller.g.dart';

class ClientController = _ClientController with _$ClientController;

abstract class _ClientController with Store {
  FirestoreService db = FirestoreService();

  @observable
  Client? client;

  @observable
  bool isSorted = false;

  @observable
  String? state;

  @observable
  List<Client> clients = [];

  @action
  Future<String> create(Client client) async {
    await db.createClient(client).catchError((_) => 'Erro ao criar conta.');
    this.client = client;
    return 'Conta criada com sucesso!';
  }

  @action
  Future read() async {
    await db.readClient().then((value) {
      if (value != null) {
        client = Client.fromJson(value.data() as Map<String, dynamic>);
      }
    });
  }

  @action
  Future delete() async {
    await db.deleteCardsClient();
    await db.deleteClient();
  }

  @action
  setImage(String image) {
    client!.imageUrl = image;
  }

  @action
  Stream<QuerySnapshot<Map<String, dynamic>>> getClients() {
    return FirestoreService().readClients();
  }

  @action
  setSort(bool value) {
    isSorted = value;
  }

  @action
  setState(String value) {
    state = value;
  }

  @action
  setClients(List<Client> value) {
    clients = value;
  }
}
