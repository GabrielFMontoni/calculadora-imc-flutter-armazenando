import 'package:calculadora_imc/models/imc_hive.dart';
import 'package:calculadora_imc/myapp.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var diretorioDocumentos =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(diretorioDocumentos.path);
  Hive.registerAdapter(ImcHiveAdapter());
  runApp(const MyApp());
}
