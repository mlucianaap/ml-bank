// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CardController on _CardController, Store {
  late final _$isCreateAtom =
      Atom(name: '_CardController.isCreate', context: context);

  @override
  bool get isCreate {
    _$isCreateAtom.reportRead();
    return super.isCreate;
  }

  @override
  set isCreate(bool value) {
    _$isCreateAtom.reportWrite(value, super.isCreate, () {
      super.isCreate = value;
    });
  }

  late final _$typeCardAtom =
      Atom(name: '_CardController.typeCard', context: context);

  @override
  String? get typeCard {
    _$typeCardAtom.reportRead();
    return super.typeCard;
  }

  @override
  set typeCard(String? value) {
    _$typeCardAtom.reportWrite(value, super.typeCard, () {
      super.typeCard = value;
    });
  }

  late final _$identificationCardAtom =
      Atom(name: '_CardController.identificationCard', context: context);

  @override
  String? get identificationCard {
    _$identificationCardAtom.reportRead();
    return super.identificationCard;
  }

  @override
  set identificationCard(String? value) {
    _$identificationCardAtom.reportWrite(value, super.identificationCard, () {
      super.identificationCard = value;
    });
  }

  late final _$validityCardAtom =
      Atom(name: '_CardController.validityCard', context: context);

  @override
  String? get validityCard {
    _$validityCardAtom.reportRead();
    return super.validityCard;
  }

  @override
  set validityCard(String? value) {
    _$validityCardAtom.reportWrite(value, super.validityCard, () {
      super.validityCard = value;
    });
  }

  late final _$urlImageAtom =
      Atom(name: '_CardController.urlImage', context: context);

  @override
  String? get urlImage {
    _$urlImageAtom.reportRead();
    return super.urlImage;
  }

  @override
  set urlImage(String? value) {
    _$urlImageAtom.reportWrite(value, super.urlImage, () {
      super.urlImage = value;
    });
  }

  late final _$qtdCardCreateAtom =
      Atom(name: '_CardController.qtdCardCreate', context: context);

  @override
  int get qtdCardCreate {
    _$qtdCardCreateAtom.reportRead();
    return super.qtdCardCreate;
  }

  @override
  set qtdCardCreate(int value) {
    _$qtdCardCreateAtom.reportWrite(value, super.qtdCardCreate, () {
      super.qtdCardCreate = value;
    });
  }

  late final _$qtdCardsAtom =
      Atom(name: '_CardController.qtdCards', context: context);

  @override
  String? get qtdCards {
    _$qtdCardsAtom.reportRead();
    return super.qtdCards;
  }

  @override
  set qtdCards(String? value) {
    _$qtdCardsAtom.reportWrite(value, super.qtdCards, () {
      super.qtdCards = value;
    });
  }

  late final _$statusAtom =
      Atom(name: '_CardController.status', context: context);

  @override
  String? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$justificationAtom =
      Atom(name: '_CardController.justification', context: context);

  @override
  String? get justification {
    _$justificationAtom.reportRead();
    return super.justification;
  }

  @override
  set justification(String? value) {
    _$justificationAtom.reportWrite(value, super.justification, () {
      super.justification = value;
    });
  }

  late final _$createAsyncAction =
      AsyncAction('_CardController.create', context: context);

  @override
  Future<dynamic> create(MyCard card) {
    return _$createAsyncAction.run(() => super.create(card));
  }

  late final _$setqtdCardCreateAsyncAction =
      AsyncAction('_CardController.setqtdCardCreate', context: context);

  @override
  Future setqtdCardCreate() {
    return _$setqtdCardCreateAsyncAction.run(() => super.setqtdCardCreate());
  }

  late final _$_CardControllerActionController =
      ActionController(name: '_CardController', context: context);

  @override
  dynamic setStatus(String value) {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.setStatus');
    try {
      return super.setStatus(value);
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setJustification(String value) {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.setJustification');
    try {
      return super.setJustification(value);
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTypeCard(String value) {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.setTypeCard');
    try {
      return super.setTypeCard(value);
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIdentificationCard(String value) {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.setIdentificationCard');
    try {
      return super.setIdentificationCard(value);
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setValidityCard(String value) {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.setValidityCard');
    try {
      return super.setValidityCard(value);
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getMyCards([String? id]) {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.getMyCards');
    try {
      return super.getMyCards(id);
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getCardsCreate() {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.getCardsCreate');
    try {
      return super.getCardsCreate();
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getCardsRegister() {
    final _$actionInfo = _$_CardControllerActionController.startAction(
        name: '_CardController.getCardsRegister');
    try {
      return super.getCardsRegister();
    } finally {
      _$_CardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isCreate: ${isCreate},
typeCard: ${typeCard},
identificationCard: ${identificationCard},
validityCard: ${validityCard},
urlImage: ${urlImage},
qtdCardCreate: ${qtdCardCreate},
qtdCards: ${qtdCards},
status: ${status},
justification: ${justification}
    ''';
  }
}
