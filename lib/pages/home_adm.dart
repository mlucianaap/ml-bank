// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mlbank/components/logo.dart';
import 'package:mlbank/controller/adm_controller.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/services/auth_service.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeAdm extends StatelessWidget {
  const HomeAdm({super.key});

  @override
  Widget build(BuildContext context) {
    final adm = Provider.of<AdmController>(context, listen: false);
    final client = Provider.of<ClientController>(context, listen: false);

    final firtName = adm.adm!.name!.split(' ')[0];

    Widget buttom(String text, IconData icon, Function onClick) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.ligthGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          padding: const EdgeInsets.all(15),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              icon,
              color: Constants.darkBlue,
              size: 60.0,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Constants.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
            ),
          ],
        ),
        onPressed: () => onClick(),
      );
    }

    logout() {
      AuthService().logout().then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login, (Route<dynamic> route) => false);
      });
    }

    void confirm() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Atenção!',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Você deseja realmente sair?"),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.ligthGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.all(15),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Não",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Constants.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.darkBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.all(15),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      onPressed: logout,
                      child: Text(
                        "Sim",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Logo(),
                    GestureDetector(
                      onTap: confirm,
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Constants.darkBlue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Olá, $firtName!',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Ações',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: GridView.count(
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    children: [
                      buttom('Cartões Criados', Icons.credit_card_rounded, () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.cardsCreate,
                        );
                      }),
                      buttom('Cartões Cadastrados', Icons.credit_card_rounded,
                          () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.cardsRegister,
                        );
                      }),
                      buttom(
                          'Cadastrar Administrador', Icons.person_add_alt_sharp,
                          () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.registerAdm,
                        );
                      }),
                      buttom('Visualizar Clientes', Icons.people_alt_outlined,
                          () {
                        client.setState('');
                        client.setSort(false);
                        Navigator.of(context).pushNamed(
                          AppRoutes.viewClients,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
