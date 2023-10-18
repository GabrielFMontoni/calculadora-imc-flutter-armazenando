class IMC {
  double _peso = 0;
  double _altura = 0;
  double imc = 0;

  String condicao = "";

  IMC(this._peso, this._altura);

  double get peso => _peso;
  double get altura => _altura;

  void set peso(double peso) {
    _peso = peso;
  }

  void set altura(double altura) {
    _altura = altura;
  }

  List cadastrarIMC() {
    imc = _peso / (_altura * _altura);
    if (imc < 16) {
      condicao = "Magreza Grave";
    } else if (imc < 17) {
      condicao = "Magreza moderada";
    } else if (imc < 18.5) {
      condicao = "Magreza Leve";
    } else if (imc < 25) {
      condicao = "Saudável";
    } else if (imc < 30) {
      condicao = "Sobrepeso";
    } else if (imc < 35) {
      condicao = "Obesidade grau I";
    } else if (imc < 40) {
      condicao = "Obesidade grau II";
    } else {
      condicao = "Obesidade grau III";
    }
    return [_peso, _altura, imc.toStringAsFixed(2), condicao];
  }
}
