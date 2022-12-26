// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/controller/adm_controller.dart';
import 'package:mlbank/models/adm.dart';
import 'package:mlbank/services/auth_service.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class RegisterAdm extends StatefulWidget {
  const RegisterAdm({super.key});

  @override
  State<RegisterAdm> createState() => _RegisterAdmState();
}

class _RegisterAdmState extends State<RegisterAdm> with Validations {
  final _formKey = GlobalKey<FormState>();
  UserCredential? currentUser;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmePasswordController = TextEditingController();

  String _state = "";
  bool obscurePassword = true;
  bool obscurePasswordConfirmation = true;
  bool isLoading = false;

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _submitForm(
      BuildContext context, AdmController providerAdm) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      isLoading = true;
    });

    try {
      var cpf = await FirestoreService()
          .loadClient('cpf', _cpfController.text.trim());
      var email = await FirestoreService()
          .loadClient('email', _emailController.text.trim());

      if (cpf.docs.isNotEmpty) {
        _showMsg('O CPF fornecido já está associado à um cliente.', Colors.red);
        return;
      }

      if (email.docs.isNotEmpty) {
        _showMsg(
            'O E-mail fornecido já está associado à um cliente.', Colors.red);
        return;
      }

      try {
        await AuthService()
            .signup(_emailController.text.trim(),
                _passwordController.text.trim(), _nameController.text.trim())
            .then((value) {
          Provider.of<AdmController>(context, listen: false)
              .create(
            Adm(
              id: FirebaseAuth.instance.currentUser!.uid,
              cpf: _cpfController.text.trim(),
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              state: _state,
              address: _addressController.text.trim(),
              isAdm: true,
            ),
          )
              .then((value) async {
            if (value == 'Admnistrador criado com sucesso!') {
              Navigator.of(context).pushNamed(
                AppRoutes.homeAdm,
              );
              _showMsg(value, Colors.green);

              await AuthService().login(
                  cpf: providerAdm.cpf!, password: providerAdm.password!);
            } else {
              _showMsg(value, Colors.red);
            }
          });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _showMsg('E-mail já associado à uma conta.', Colors.red);
        } else {
          _showMsg(e.code, Colors.red);
        }
      }
    } finally {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _confirmePasswordController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var providerAdm = Provider.of<AdmController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Cadastrar Administrador',
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
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo',
                        ),
                        validator: (name) => combine([
                          () => isNotEmpty(name, "O nome é obrigatório"),
                          () => isNameCompleteValid(name),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DropdownButtonFormField<String>(
                        hint:
                            _state != "" ? Text(_state) : const Text('Estado'),
                        onChanged: (String? stateSelected) {
                          setState(() {
                            _state = stateSelected!;
                          });
                        },
                        items: Constants.listStates.map((String state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        validator: (state) =>
                            isDropdownNotEmpty(state, 'Estado é obrigatório'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Endereço',
                        ),
                        validator: (address) =>
                            isNotEmpty(address, 'Endereço é obrigatório!'),
                      ),
                    ),
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
                    isLoading
                        ? const CircularProgressIndicator()
                        : Buttom(
                            texto: 'Criar Administrador',
                            submitForm: (_) =>
                                _submitForm(context, providerAdm),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
