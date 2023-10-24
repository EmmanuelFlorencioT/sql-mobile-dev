import 'package:flutter/material.dart';
import 'package:sql_proj/home.dart';

class Agrega extends StatefulWidget {
  const Agrega({super.key});

  @override
  State<Agrega> createState() => _AgregaState();
}

class _AgregaState extends State<Agrega> {
  TextEditingController dato1 = TextEditingController();
  TextEditingController dato2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(children: [
              const SizedBox(
                height: 30,
              ),
              const Text('Dato 1'),
              TextFormField(
                controller: dato1,
                obscureText: false,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.green,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text('Dato 2'),
              TextFormField(
                controller: dato2,
                obscureText: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime,
                ),
                onPressed: () {
                  setState(() {
                    if (dato1.text.isNotEmpty && dato2.text.isNotEmpty) {
                      String record = "${dato1.text}#${dato2.text}";

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Home()));
                    }
                  });
                },
                child: const Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
