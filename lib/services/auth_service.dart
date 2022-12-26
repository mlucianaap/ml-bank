import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mlbank/services/firestore_service.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> login({required String cpf, required String password}) async {
    String? typeUser;
    try {
      var resultClient = await FirestoreService().loadClient('cpf', cpf);
      var resultAdm = await FirestoreService().loadAdm('cpf', cpf);

      if (resultClient.docs.isNotEmpty) {
        String emailC = resultClient.docs[0].data()['email'];
        await auth.signInWithEmailAndPassword(
            email: emailC, password: password);
        typeUser = "Cliente";
      } else if (resultAdm.docs.isNotEmpty) {
        String emailA = resultAdm.docs[0].data()['email'];
        await auth.signInWithEmailAndPassword(
            email: emailA, password: password);
        typeUser = "Administrador";
      } else {
        return 'Nenhum usuário encontrado para este CPF.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'Senha incorreta.';
      } else if (e.code == 'user-not-found') {
        return 'Usuário não encontrado. O usuário pode ter sido excluído';
      } else if (e.code == 'too-many-requests') {
        return 'Bloqueamos todas as solicitações deste dispositivo devido a atividade incomum. Tente mais tarde.';
      } else {
        return 'Ocorreu um erro inesperado!';
      }
    }

    return '$typeUser logado com sucesso!';
  }

  Future signup(String email, String password, String name) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (credential.user == null) return;

    credential.user?.updateDisplayName(name);
  }

  Future<void> logout() async {
    auth.signOut();
  }

  Future<void> passwordReset(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // print(e);
    }
  }
}
