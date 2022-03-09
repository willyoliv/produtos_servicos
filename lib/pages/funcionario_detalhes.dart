import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:produtos_servicos/controllers/app_controller.dart';
import 'package:produtos_servicos/models/funcionario.dart';

class FuncionarioDetalhes extends StatelessWidget {
  final controller = Get.put(AppController());

  final Funcionario funcionario;
  FuncionarioDetalhes({Key? key, required this.funcionario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Funcionário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nome: ",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
              ),
            ),
            Text(
              funcionario.nome,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Cargo: ",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
              ),
            ),
            Text(
              funcionario.cargo,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Setor: ",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
              ),
            ),
            Text(
              funcionario.setor,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Data de nascimento: ",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(funcionario.dataNascimento),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Data de contratação: ",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(funcionario.dataContratacao),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            if (!funcionario.isFuncionarioAtivo)
              const Text(
                "Data de demissão: ",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              ),
            if (!funcionario.isFuncionarioAtivo)
              Text(
                DateFormat('dd/MM/yyyy').format(funcionario.dataDesligamento),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(
                      funcionario.isFuncionarioAtivo ? 'Demitir' : 'Readimitir',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: funcionario.isFuncionarioAtivo
                        ? Theme.of(context).errorColor
                        : Colors.green,
                    fixedSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                      title:
                          "Deseja ${funcionario.isFuncionarioAtivo ? 'Demitir' : 'Readimitir'} este funcionário?",
                      middleText:
                          "Você está prestes a ${funcionario.isFuncionarioAtivo ? 'Demitir' : 'Readimitir'} este funcionário...",
                      titleStyle: const TextStyle(fontSize: 18),
                      barrierDismissible: false,
                      radius: 10.0,
                      confirm: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Theme.of(context).errorColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          controller
                              .demitirOuReadimitirFuncionario(funcionario);
                          Get.back();
                          Get.back();
                        },
                        child: const Text("Confirmar"),
                      ),
                      cancel: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancelar"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
