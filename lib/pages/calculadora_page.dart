import 'package:calculadora_imc/models/imc.dart';
import 'package:flutter/material.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({
    super.key,
  });

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  var instanciaIMC = IMC(0, 0);

  TextEditingController controllerPeso = TextEditingController();
  TextEditingController controllerAltura = TextEditingController();

  var listasIMC = [];

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
                      print(imcItem[2]);
                      return Dismissible(
                        key: GlobalKey(),
                        onDismissed: (direction) => {listasIMC.removeAt(index)},
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("IMC: ${imcItem[2]}"),
                            ],
                          ),
                          leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Peso: ${imcItem[0].toString()}"),
                                Text("Altura: ${imcItem[1].toString()}")
                              ]),
                          // Column(children: [
                          //   Text("Altura"),
                          //   Text(imcItem[1].toString()),
                          // ]),

                          trailing: Text(imcItem[3].toString()),
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
                                  instanciaIMC.altura =
                                      double.parse(controllerAltura.text);
                                  instanciaIMC.peso =
                                      double.parse(controllerPeso.text);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Insira valores válidos.")));
                                  return;
                                }
                                setState(() {
                                  listasIMC.add(instanciaIMC.cadastrarIMC());
                                });

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
