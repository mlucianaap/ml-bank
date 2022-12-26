// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mobx/mobx.dart';

part 'card_controller.g.dart';

class CardController = _CardController with _$CardController;

abstract class _CardController with Store {
  _CardController() {
    getMyCards();
  }
  @observable
  bool isCreate = true;

  @observable
  String? typeCard;

  @observable
  String? identificationCard;

  @observable
  String? validityCard;

  @observable
  String? urlImage;

  @observable
  int qtdCardCreate = 0;

  @observable
  String? qtdCards;

  @observable
  String? status;

  @observable
  String? justification;

  @action
  setStatus(String value) {
    status = value;
  }

  @action
  setJustification(String value) {
    justification = value;
  }

  @action
  setTypeCard(String value) {
    typeCard = value;
  }

  @action
  setIdentificationCard(String value) {
    identificationCard = value;
  }

  @action
  setValidityCard(String value) {
    validityCard = value;
  }

  @action
  Future create(MyCard card) async {
    await FirestoreService().createCard(card).then((value) async {
      await FirestoreService().qtdCards();
    });
  }

  @action
  getMyCards([String? id]) {
    return FirestoreService().readCard(id);
  }

  @action
  setqtdCardCreate() async {
    FirebaseFirestore.instance
        .collection('cards')
        .where('idClient', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('create', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      qtdCardCreate = snapshot.docs.length;
    });
  }

  setqtdCards(String value) {
    qtdCards = value;
  }

  delete(String id) {
    return FirestoreService().deleteCard(id);
  }

  getFlag(String flag) {
    if (flag == 'MasterCard') {
      urlImage = 'assets/images/mastercard-logo.png';
    } else if (flag == 'Visa') {
      urlImage = 'assets/images/visa-logo.png';
    } else if (flag == 'Elo') {
      urlImage = 'assets/images/elo-logo.png';
    } else if (flag == 'Hipercard') {
      urlImage = 'assets/images/hipercard-logo.png';
    } else if (flag == 'American Express') {
      urlImage = 'assets/images/american-express-logo.png';
    }
  }

  Color getColor(String status) {
    Color? cor;

    if (status == 'Esperando Avaliação') {
      cor = Constants.yellow;
    } else if (status == "Aprovado") {
      cor = Constants.green;
    } else {
      cor = Constants.red;
    }
    return cor;
  }

  String setValidity(String validity) {
    DateTime data = DateTime.now();
    dynamic year;
    if (validity == "2 anos") {
      year = data.year + 2;
    } else if (validity == "4 anos") {
      year = data.year + 4;
    } else if (validity == "5 anos") {
      year = data.year + 5;
    } else if (validity == "6 anos") {
      year = data.year + 6;
    }

    return "${data.month}/${year.toString().substring(2, 4)}";
  }

  @action
  getCardsCreate() {
    return FirestoreService().readCardCreate();
  }

  @action
  getCardsRegister() {
    return FirestoreService().readCardRegister();
  }
}
