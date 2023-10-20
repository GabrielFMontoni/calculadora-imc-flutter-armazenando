import 'package:hive/hive.dart';
part 'imc_hive.g.dart';

@HiveType(typeId: 0)
class ImcHive extends HiveObject {
  @HiveField(0)
  double peso = 0;
  @HiveField(1)
  double altura = 0;
  @HiveField(2)
  double imc = 0;
  @HiveField(3)
  String condicao = "";

  ImcHive();
  ImcHive.criar(this.peso, this.altura);
}
