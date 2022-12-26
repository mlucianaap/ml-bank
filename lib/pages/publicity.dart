import 'package:flutter/material.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/components/logo.dart';
import 'package:mlbank/utils/app_routes.dart';

class Publicity extends StatelessWidget {
  const Publicity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Logo(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/mobile-cartao.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    Text(
                      'Vamos começar!',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Este é o melhor momento para você começar a pensar em como gerenciar todas as suas finanças.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Buttom(
                  texto: 'Criar Conta',
                  submitForm: (p0) {
                    Navigator.of(context).pushNamed(
                      AppRoutes.registerClient,
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.login,
                  );
                },
                child: Text(
                  'Já tenho Conta',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
