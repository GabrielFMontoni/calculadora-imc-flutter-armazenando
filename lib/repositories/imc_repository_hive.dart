import 'package:calculadora_imc/models/imc_hive.dart';
import 'package:hive/hive.dart';

class ImcRepositoryHive {
  static late Box _box;

  ImcRepositoryHive._load();
  static Future<ImcRepositoryHive> load() async {
    if (Hive.isBoxOpen("imc")) {
      _box = Hive.box("imc");
    } else {
      _box = await Hive.openBox("imc");
    }
    return ImcRepositoryHive._load();
  }

  void obterIMC(ImcHive imcDados) {
    imcDados.imc = imcDados.peso / (imcDados.altura * imcDados.altura);
    if (imcDados.imc < 16) {
      imcDados.condicao = "Magreza Grave";
    } else if (imcDados.imc < 17) {
      imcDados.condicao = "Magreza moderada";
    } else if (imcDados.imc < 18.5) {
      imcDados.condicao = "Magreza Leve";
    } else if (imcDados.imc < 25) {
      imcDados.condicao = "Saudável";
    } else if (imcDados.imc < 30) {
      imcDados.condicao = "Sobrepeso";
    } else if (imcDados.imc < 35) {
      imcDados.condicao = "Obesidade grau I";
    } else if (imcDados.imc < 40) {
      imcDados.condicao = "Obesidade grau II";
    } else {
      imcDados.condicao = "Obesidade grau III";
    }
  }

  void salvar(ImcHive imcDados) {
    obterIMC(imcDados);
    _box.add(imcDados);
  }

  void deletar(ImcHive imcDados) {
    imcDados.delete();
  }

  void alterar(ImcHive imcDados) {
    obterIMC(imcDados);
    imcDados.save();
  }

  List<ImcHive> obterDados() {
    print(_box.values);
    return _box.values.cast<ImcHive>().toList();
  }
}
