import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/services/auth_service.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  _logout(BuildContext context) {
    AuthService().logout().then((value) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login, (Route<dynamic> route) => false);
    });
  }

  Future<XFile?> getImageGallery() async {
    setState(() {
      isLoading = true;
    });
    try {
      final ImagePicker picker = ImagePicker();
      XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        await FirestoreService().upload(file.path);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ClientController>(context, listen: false);

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
            child: Text(
                "Você deseja realmente apagar a conta? Ao confirmar todos os seus dados serão apagados."),
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
                      onPressed: () async {
                        provider.delete().then((value) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.login, (Route<dynamic> route) => false);
                        });
                      },
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Perfil',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.width / 6,
        iconTheme: const IconThemeData(color: Constants.darkBlue),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Observer(
                      builder: (ctx) => isLoading
                          ? Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(35),
                              child: const CircularProgressIndicator(
                                color: Constants.midleGrey,
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(provider.client!.imageUrl!),
                              backgroundColor: Colors.transparent,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          onPressed: () {
                            getImageGallery().then((value) {
                              provider.read();
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '${provider.client!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${provider.client!.email}',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Divider(),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.key,
                    color: Constants.darkBlue,
                  ),
                  title: Text(
                    'Alterar Senha',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.passwordForgot,
                    );
                  },
                ),
                const Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Apagar Conta',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  onTap: confirm,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Buttom(
                texto: 'Sair',
                submitForm: _logout,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
