import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class PasswordForgot extends StatefulWidget {
  const PasswordForgot({super.key});

  @override
  State<PasswordForgot> createState() => _PasswordForgotState();
}

class _PasswordForgotState extends State<PasswordForgot> with Validations {
  final _passwordController = TextEditingController();
  final _confirmePasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscurePasswordConfirmation = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _confirmePasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    var provider = Provider.of<ClientController>(context, listen: false);

    String senha = _passwordController.text;
    AuthCredential credential = EmailAuthProvider.credential(
        email: provider.client!.email!, password: senha);
    User user = FirebaseAuth.instance.currentUser!;

    try {
      await user.updatePassword(senha).then((value) {
        user.reauthenticateWithCredential(credential);
      });
    } catch (e) {
      return;
    }
    _showMsg('Senha atualizada com sucesso!', Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Alterar Senha',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.width / 6,
        iconTheme: const IconThemeData(color: Constants.darkBlue),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: obscurePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          splashRadius: Material.defaultSplashRadius / 2,
                          onPressed: () => setState(
                              () => obscurePassword = !obscurePassword),
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (password) => combine([
                        () => isNotEmpty(password, "A senha é obrigatória"),
                        () => isPasswordValid(password),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: obscurePasswordConfirmation,
                      controller: _confirmePasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        suffixIcon: IconButton(
                          splashRadius: Material.defaultSplashRadius / 2,
                          onPressed: () => setState(() =>
                              obscurePasswordConfirmation =
                                  !obscurePasswordConfirmation),
                          icon: Icon(
                            obscurePasswordConfirmation
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (confirmPassword) => combine([
                        () => isNotEmpty(
                            confirmPassword, "A senha é obrigatória"),
                        () => isPasswordValid(confirmPassword),
                        () => isEqualsPassword(
                            confirmPassword, _passwordController.text.trim()),
                      ]),
                    ),
                  ),
                  Buttom(
                    texto: 'Alterar Senha',
                    submitForm: _submitForm,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
