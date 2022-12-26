// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/components/logo.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/models/client.dart';
import 'package:mlbank/services/auth_service.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class RegisterClient extends StatefulWidget {
  const RegisterClient({super.key});

  @override
  State<RegisterClient> createState() => _RegisterClientState();
}

class _RegisterClientState extends State<RegisterClient> with Validations {
  final _formKey = GlobalKey<FormState>();
  UserCredential? currentUser;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmePasswordController = TextEditingController();

  String _state = Constants.listStates.first;
  String _accountType = Constants.accountTypes.first;
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

  registerClient(BuildContext context, ClientController providerClient) async {
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
      var phone = await FirestoreService()
          .loadClient('phone', _phoneController.text.trim());

      if (cpf.docs.isNotEmpty) {
        _showMsg('O CPF fornecido já está associado à um cliente.', Colors.red);
        return;
      }

      if (email.docs.isNotEmpty) {
        _showMsg(
            'O E-mail fornecido já está associado à um cliente.', Colors.red);
        return;
      }

      if (phone.docs.isNotEmpty) {
        _showMsg(
            'O telefone fornecido já está associado à um cliente.', Colors.red);
        return;
      }

      try {
        await AuthService().signup(_emailController.text.trim(),
            _passwordController.text.trim(), _nameController.text.trim());

        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null) {
            providerClient
                .create(
              Client(
                id: user.uid,
                cpf: _cpfController.text.trim(),
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                phone: _phoneController.text.trim(),
                state: _state,
                address: _addressController.text.trim(),
                accountType: _accountType,
                isAdm: false,
              ),
            )
                .then((value) {
              if (value == 'Conta criada com sucesso!') {
                Navigator.of(context).pushNamed(
                  AppRoutes.addCard,
                );
                _showMsg(value, Colors.green);
              } else {
                _showMsg(value, Colors.red);
              }
            });
          }
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
        isLoading = false;
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
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var providerClient = Provider.of<ClientController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Logo(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Criar Conta',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              fontFamily: 'Inter',
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8.0),
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
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          Constants.maskPhone
                        ],
                        validator: (phone) => combine([
                          () => isNotEmpty(phone, "Telefone é obrigatório"),
                          () => isPhoneValid(phone),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DropdownButtonFormField<String>(
                        hint: const Text('Estado'),
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
                      child: DropdownButtonFormField<String>(
                        hint: const Text('Tipo de Conta'),
                        onChanged: (String? typeSelected) {
                          setState(() {
                            _accountType = typeSelected!;
                          });
                        },
                        items: Constants.accountTypes.map((String accountType) {
                          return DropdownMenuItem(
                            value: accountType,
                            child: Text(accountType),
                          );
                        }).toList(),
                        validator: (accountType) => isDropdownNotEmpty(
                            accountType, 'Tipo de conta é obrigatório'),
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
                            texto: 'Criar Conta',
                            submitForm: (_) {
                              registerClient(context, providerClient);
                            },
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.login,
                        );
                      },
                      child: const Text('Já tenho Conta'),
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
