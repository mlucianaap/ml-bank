// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/components/logo.dart';
import 'package:mlbank/services/auth_service.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with Validations {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  void _showMsg(String msg, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: cor,
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    var cpfClient =
        await FirestoreService().loadClient('cpf', _cpfController.text.trim());
    var cpfAdm =
        await FirestoreService().loadAdm('cpf', _cpfController.text.trim());

    if (cpfClient.docs.isNotEmpty) {
      if (cpfClient.docs[0].data()['email'] != _emailController.text.trim()) {
        _showMsg(
            'O email fornecido não está associado ao cliente.', Colors.red);
        return;
      }

      if (cpfClient.docs[0].data()['name'] != _nameController.text.trim()) {
        _showMsg('Informe o nome completo.', Colors.red);
        return;
      }
    } else if (cpfAdm.docs.isEmpty) {
      _showMsg(
          'O cpf fornecido não está associado a nenhum cliente.', Colors.red);
      return;
    } else if (cpfAdm.docs.isNotEmpty) {
      if (cpfAdm.docs[0].data()['email'] != _emailController.text.trim()) {
        _showMsg('O email fornecido não está associado ao administrador.',
            Colors.red);
        return;
      }

      if (cpfAdm.docs[0].data()['name'] != _nameController.text.trim()) {
        _showMsg('Informe o nome completo.', Colors.red);
        return;
      }
    } else if (cpfAdm.docs.isEmpty) {
      _showMsg('O cpf fornecido não está associado a nenhum administrador.',
          Colors.red);
      return;
    }

    AuthService()
        .passwordReset(_emailController.text.trim())
        .then((value) => _showMsg('E-mail enviado com sucesso!', Colors.green))
        .catchError((e) => _showMsg('Ocorreu um erro!', Colors.red));

    Navigator.of(context).pushNamed(
      AppRoutes.login,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Logo(),
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Esqueceu a senha?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      fontFamily: 'Inter',
                                    ),
                              ),
                              Text(
                                textAlign: TextAlign.start,
                                'Informe os dados abaixo para alterá-la.',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (email) => combine([
                            () => isNotEmpty(email, "E-mail é obrigatório"),
                            () => isEmailValid(email),
                          ]),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome Completo',
                          ),
                          validator: (name) =>
                              isNotEmpty(name, 'Nome é obrigatório!'),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _cpfController,
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            Constants.maskCpf
                          ],
                          validator: (cpf) => combine([
                            () => isNotEmpty(cpf, "CPF é obrigatório"),
                            () => isCpfValid(cpf),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Buttom(
                            texto: 'Enviar email',
                            submitForm: _submit,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.login,
                            );
                          },
                          child: Text(
                            'Entrar',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  textAlign: TextAlign.justify,
                  'Será enviado para o email fornecido, um link de recuperação de senha.',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )

              // MediaQuery.of(context).viewInsets.bottom == 0
              //     ? Text(
              //         textAlign: TextAlign.justify,
              //         'Será enviado para o email fornecido, um link de recuperação de senha.',
              //         style: Theme.of(context).textTheme.headline6,
              //       )
              //     : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
