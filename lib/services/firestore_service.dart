// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mlbank/models/adm.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/models/client.dart';

class FirestoreService {
  late FirebaseAuth auth = FirebaseAuth.instance;
  late FirebaseStorage storage = FirebaseStorage.instance;
  final collectionClient = FirebaseFirestore.instance.collection('clients');
  final collectionCard = FirebaseFirestore.instance.collection('cards');
  final collectionAdm = FirebaseFirestore.instance.collection('adms');

  DocumentSnapshot<Map<String, dynamic>?>? client;
  DocumentSnapshot<Map<String, dynamic>?>? adm;

  Future<void> createClient(Client client) async {
    await collectionClient.doc(client.id).set(client.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> loadClient(
      String key, String valor) async {
    return await collectionClient.where(key, isEqualTo: valor).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> loadAdm(
      String key, String valor) async {
    return await collectionAdm.where(key, isEqualTo: valor).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>?>?> readClient() async {
    await collectionClient.doc(auth.currentUser?.uid).get().then((doc) {
      client = doc;
    });
    return client;
  }

  Future deleteClient() async {
    await collectionClient.doc(auth.currentUser?.uid).delete().then(
      (doc) async {
        await auth.currentUser?.delete();
      },
    );
  }

  Future deleteCardsClient() async {
    await collectionCard
        .where('idClient', isEqualTo: auth.currentUser?.uid)
        .get()
        .then((value) {
      for (var card in value.docs) {
        deletePhotoProfile();
        deleteCard(card.data()['id']);
      }
    });
  }

  Future deletePhotoProfile() async {
    String image = '/clients/${auth.currentUser!.uid}/client.jpg';
    final desertRef = storage.ref().child(image);
    try {
      await desertRef.delete();
    } catch (e) {
      return;
    }
  }

  Future createCard(MyCard card) async {
    var id = collectionCard.doc().id;
    await collectionCard.doc(id).set(card.toJson(id)).then((value) => null);
  }

  Future qtdCards() async {
    collectionCard
        .where('idClient', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((snapshot) async {
      await collectionClient
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"qtdCards": snapshot.docs.length.toString()});
    });
  }

  readCard([String? id]) {
    return collectionCard
        .where('idClient', isEqualTo: id ?? auth.currentUser?.uid)
        .snapshots();
  }

  readCardCreate() {
    return collectionCard
        .where('status', isEqualTo: "Esperando Avaliação")
        .where('create', isEqualTo: true)
        .snapshots();
  }

  readCardRegister() {
    return collectionCard
        .where('status', isEqualTo: "Esperando Avaliação")
        .where('create', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readClients() {
    return collectionClient.snapshots();
  }

  Future deleteCard(String id) async {
    await collectionCard.doc(id).delete();
  }

  Future upload(String path) async {
    File file = File(path);

    String ref = '/clients/${auth.currentUser!.uid}/client.jpg';
    await storage.ref(ref).putFile(file).then(
          (_) => storage.ref(ref).getDownloadURL().then(
            (url) async {
              collectionClient
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({'imageUrl': url});
            },
          ),
        );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> loadCard(
      String key, String valor) async {
    return await collectionCard.where(key, isEqualTo: valor).get();
  }

  Future<void> createAdm(Adm adm) async {
    await collectionAdm.doc(adm.id).set(adm.toJson());
  }

  Future<DocumentSnapshot<Map<String, dynamic>?>?> readAdm() async {
    await collectionAdm.doc(auth.currentUser?.uid).get().then((doc) {
      adm = doc;
    });
    return adm;
  }

  Future failCard(String justification, String id) async {
    collectionCard
        .doc(id)
        .update({"justification": justification, "status": "Reprovado"});
  }

  Future approveCard(String id) async {
    collectionCard.doc(id).update({"status": "Aprovado"});
  }
}
