import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Constants {
  static const List<String> listStates = [
    'Acre',
    'Alagoas',
    'Amapá',
    'Amazonas',
    'Bahia',
    'Ceará',
    'Distrito Federal',
    'Espírito Santo',
    'Goiás',
    'Maranhão',
    'Mato Grosso',
    'Mato Grosso do Sul',
    'Minas Gerais',
    'Pará',
    'Paraíba',
    'Paraná',
    'Pernambuco',
    'Piauí',
    'Rio de Janeiro',
    'Rio Grande do Norte',
    'Rio Grande do Sul',
    'Rondônia',
    'Roraima',
    'Santa Catarina',
    'São Paulo',
    'Sergipe',
    'Tocantins',
  ];

  static const List<String> accountTypes = [
    'Poupança',
    'Corrente',
  ];

  static const List<String> listTypeCards = [
    'Crédito',
    'Débito',
    'Poupança',
    'Crédito e Débito',
    'Poupança e Débito',
  ];

  static const List<String> listIdentificationCards = [
    'Visa',
    'MasterCard',
    'Elo',
    'Hipercard',
    'American Express',
  ];

  static const List<String> listValidityCards = [
    '2 anos',
    '4 anos',
    '5 anos',
    '6 anos',
  ];

  static final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});

  static final maskPhone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  static final maskCard = MaskTextInputFormatter(
      mask: "#### #### #### ####", filter: {"#": RegExp(r'[0-9]')});

  static final maskCvc =
      MaskTextInputFormatter(mask: "###", filter: {"#": RegExp(r'[0-9]')});

  static const Color ligthBlue = Color.fromRGBO(0, 105, 145, 1);
  static const Color darkBlue = Color.fromRGBO(42, 47, 71, 1);
  static const Color grey = Color.fromRGBO(138, 138, 142, 1);
  static const Color midleGrey = Color.fromRGBO(162, 166, 168, 1);
  static const Color ligthGrey = Color.fromRGBO(239, 240, 241, 1);
  static const Color yellow = Color.fromRGBO(240, 173, 2, 1);
  static const Color green = Color.fromRGBO(139, 195, 74, 1);
  static const Color red = Color.fromRGBO(234, 96, 85, 1);

  static const MaterialColor mycolor = MaterialColor(
    0xFF006992,
    <int, Color>{
      50: Color(0xFF006992),
      100: Color(0xFF006992),
      200: Color(0xFF006992),
      300: Color(0xFF006992),
      400: Color(0xFF006992),
      500: Color(0xFF006992),
      600: Color(0xFF006992),
      700: Color(0xFF006992),
      800: Color(0xFF006992),
      900: Color(0xFF006992),
    },
  );

  static const String imageDefault =
      'https://firebasestorage.googleapis.com/v0/b/mlbank-41602.appspot.com/o/profile.png?alt=media&token=0b204c32-258a-458f-b83e-bd531eb1a36e';
}
