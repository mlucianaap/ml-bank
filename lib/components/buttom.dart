import 'package:flutter/material.dart';

class Buttom extends StatelessWidget {
  final String texto;
  final void Function(BuildContext) submitForm;
  final Color? color;
  final Color? colorFont;
  const Buttom({
    required this.texto,
    required this.submitForm,
    this.color,
    this.colorFont,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          padding: const EdgeInsets.all(15),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
        onPressed: () => submitForm(context),
        child: Text(
          texto,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: colorFont ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
        ),
      ),
    );
  }
}
