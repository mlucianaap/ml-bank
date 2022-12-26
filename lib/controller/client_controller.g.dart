// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClientController on _ClientController, Store {
  late final _$clientAtom =
      Atom(name: '_ClientController.client', context: context);

  @override
  Client? get client {
    _$clientAtom.reportRead();
    return super.client;
  }

  @override
  set client(Client? value) {
    _$clientAtom.reportWrite(value, super.client, () {
      super.client = value;
    });
  }

  late final _$isSortedAtom =
      Atom(name: '_ClientController.isSorted', context: context);

  @override
  bool get isSorted {
    _$isSortedAtom.reportRead();
    return super.isSorted;
  }

  @override
  set isSorted(bool value) {
    _$isSortedAtom.reportWrite(value, super.isSorted, () {
      super.isSorted = value;
    });
  }

  late final _$stateAtom =
      Atom(name: '_ClientController.state', context: context);

  @override
  String? get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(String? value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$clientsAtom =
      Atom(name: '_ClientController.clients', context: context);

  @override
  List<Client> get clients {
    _$clientsAtom.reportRead();
    return super.clients;
  }

  @override
  set clients(List<Client> value) {
    _$clientsAtom.reportWrite(value, super.clients, () {
      super.clients = value;
    });
  }

  late final _$createAsyncAction =
      AsyncAction('_ClientController.create', context: context);

  @override
  Future<String> create(Client client) {
    return _$createAsyncAction.run(() => super.create(client));
  }

  late final _$readAsyncAction =
      AsyncAction('_ClientController.read', context: context);

  @override
  Future<dynamic> read() {
    return _$readAsyncAction.run(() => super.read());
  }

  late final _$deleteAsyncAction =
      AsyncAction('_ClientController.delete', context: context);

  @override
  Future<dynamic> delete() {
    return _$deleteAsyncAction.run(() => super.delete());
  }

  late final _$_ClientControllerActionController =
      ActionController(name: '_ClientController', context: context);

  @override
  dynamic setImage(String image) {
    final _$actionInfo = _$_ClientControllerActionController.startAction(
        name: '_ClientController.setImage');
    try {
      return super.setImage(image);
    } finally {
      _$_ClientControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getClients() {
    final _$actionInfo = _$_ClientControllerActionController.startAction(
        name: '_ClientController.getClients');
    try {
      return super.getClients();
    } finally {
      _$_ClientControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSort(bool value) {
    final _$actionInfo = _$_ClientControllerActionController.startAction(
        name: '_ClientController.setSort');
    try {
      return super.setSort(value);
    } finally {
      _$_ClientControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setState(String value) {
    final _$actionInfo = _$_ClientControllerActionController.startAction(
        name: '_ClientController.setState');
    try {
      return super.setState(value);
    } finally {
      _$_ClientControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setClients(List<Client> value) {
    final _$actionInfo = _$_ClientControllerActionController.startAction(
        name: '_ClientController.setClients');
    try {
      return super.setClients(value);
    } finally {
      _$_ClientControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
client: ${client},
isSorted: ${isSorted},
state: ${state},
clients: ${clients}
    ''';
  }
}
