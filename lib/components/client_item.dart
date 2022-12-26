import 'package:flutter/material.dart';
import 'package:mlbank/models/client.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';

class ClientItem extends StatelessWidget {
  final Client client;

  const ClientItem(
    this.client, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(client.imageUrl!),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        client.name!,
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${client.state!} | ${client.qtdCards} cartões",
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: Constants.midleGrey),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.clientView,
          arguments: client,
        );
      },
    );
  }
}
