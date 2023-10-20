import 'package:calculadora_imc/models/imc_hive.dart';
import 'package:calculadora_imc/repositories/imc_repository_hive.dart';
import 'package:flutter/material.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({
    super.key,
  });

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  late ImcRepositoryHive instanciaHive;

  TextEditingController controllerPeso = TextEditingController();
  TextEditingController controllerAltura = TextEditingController();

  var listasIMC = const <ImcHive>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obterIMCs();
  }

  void obterIMCs() async {
    instanciaHive = await ImcRepositoryHive.load();
    listasIMC = instanciaHive.obterDados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calculadora IMC"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: listasIMC.length,
                    itemBuilder: (BuildContext bc, int index) {
                      var imcItem = listasIMC[index];
                      print(imcItem.imc);
                      return Dismissible(
                        key: GlobalKey(),
                        onDismissed: (direction) => {
                          listasIMC.removeAt(index),
                          instanciaHive.deletar(imcItem),
                        },
                        child: ListTile(
                          onTap: () {
                            controllerPeso.text = imcItem.peso.toString();
                            controllerAltura.text = imcItem.altura.toString();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Alterando os dados para o IMC:"),
                                    content: Wrap(children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Peso (em quilos)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextField(
                                              controller: controllerPeso,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Altura (em metros)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextField(
                                              controller: controllerAltura,
                                            ),
                                          ]),
                                    ]),
                                    actions: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancelar")),
                                          TextButton(
                                              onPressed: () {
                                                try {
                                                  imcItem.altura = double.parse(
                                                      controllerAltura.text);
                                                  imcItem.peso = double.parse(
                                                      controllerPeso.text);
                                                  instanciaHive
                                                      .alterar(imcItem);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Insira valores válidos.")));
                                                  return;
                                                }

                                                obterIMCs();
                                                setState(() {});

                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "IMC calculado com sucesso")));
                                              },
                                              child:
                                                  const Text("Calcular IMC")),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("IMC: ${imcItem.imc.toStringAsFixed(2)}"),
                            ],
                          ),
                          leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Peso: ${imcItem.peso.toString()}"),
                                Text("Altura: ${imcItem.altura.toString()}")
                              ]),
                          trailing: Text(imcItem.condicao.toString()),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controllerAltura.text = "";
            controllerPeso.text = "";
            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                    title: const Text("Insira os dados da pessoa para o IMC:"),
                    content: Wrap(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Peso (em quilos)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: controllerPeso,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Altura (em metros)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: controllerAltura,
                            ),
                          ]),
                    ]),
                    actions: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar")),
                          TextButton(
                              onPressed: () {
                                try {
                                  instanciaHive.salvar(ImcHive.criar(
                                      double.parse(controllerPeso.text),
                                      double.parse(controllerAltura.text)));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Insira valores válidos.")));
                                  return;
                                }

                                obterIMCs();
                                setState(() {});

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("IMC calculado com sucesso")));
                              },
                              child: const Text("Calcular IMC")),
                        ],
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
