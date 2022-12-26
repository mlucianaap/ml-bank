// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/components/logo.dart';
import 'package:mlbank/controller/adm_controller.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/services/auth_service.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validations {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  void _showMsg(String msg) {
    msg == 'Administrador logado com sucesso!' ||
            msg == 'Cliente logado com sucesso!'
        ? const SizedBox()
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: Colors.red,
            ),
          );
  }

  void _login(
      BuildContext context, ClientController client, AdmController adm) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService()
          .login(
        cpf: _cpfController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((msg) {
        _showMsg(msg);
        if (FirebaseAuth.instance.currentUser != null) {
          if (msg == "Administrador logado com sucesso!") {
            adm.read().then((value) {
              adm.setPassword(_passwordController.text);
              adm.setCPF(_cpfController.text);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.homeAdm, (Route<dynamic> route) => false);
            });
          } else if (msg == "Cliente logado com sucesso!") {
            client.read().then((value) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home, (Route<dynamic> route) => false);
            });
          }
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var providerClient = Provider.of<ClientController>(context, listen: false);
    var providerAdm = Provider.of<AdmController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Logo(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Entrar',
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    fontFamily: 'Inter',
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
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
                      ),
                      TextFormField(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Buttom(
                                texto: 'Entrar',
                                submitForm: (p0) => _login(
                                    context, providerClient, providerAdm),
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.forgotPassword,
                          );
                        },
                        child: Text(
                          'Esqueceu a Senha?',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem uma conta? ',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.registerClient,
                      );
                    },
                    child: Text(
                      'Criar Conta',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
