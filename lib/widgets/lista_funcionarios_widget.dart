import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:produtos_servicos/controllers/app_controller.dart';
import 'package:produtos_servicos/models/enums/operacao.dart';
import 'package:produtos_servicos/models/funcionario.dart';
import 'package:produtos_servicos/pages/form_page.dart';
import 'package:produtos_servicos/pages/funcionario_detalhes.dart';

class ListaFuncionariosWidget extends GetView<AppController> {
  final appController = Get.put(AppController());
  final bool isFuncionariosAtivos;
  ListaFuncionariosWidget({Key? key, required this.isFuncionariosAtivos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (appController.loading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        List<Funcionario> funcionarios = isFuncionariosAtivos
            ? appController.funcionarios
            : appController.funcionariosDemitidos;
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: funcionarios.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: funcionarios.length,
                  itemBuilder: (context, index) {
                    Funcionario funcionario = funcionarios[index];
                    return GestureDetector(
                      child: SizedBox(
                        height: 80,
                        child: Card(
                          child: ListTile(
                            title: Text(funcionario.nome),
                            subtitle: Text(funcionario.cargo),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'editar',
                                    child: Text('Editar'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'deletar',
                                    child: Text('Deletar'),
                                  )
                                ];
                              },
                              onSelected: (String value) {
                                if (value == 'editar') {
                                  Get.to(
                                    FormPage(
                                      tipoOperacao: TipoOperacao.EDITAR,
                                      funcionario: funcionario,
                                    ),
                                  );
                                } else {
                                  Get.defaultDialog(
                                    title: "Deseja excluir este funcionário?",
                                    middleText:
                                        "Você está prestes a excluir este funcionário...",
                                    titleStyle: const TextStyle(fontSize: 18),
                                    barrierDismissible: false,
                                    radius: 10.0,
                                    confirm: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Theme.of(context).errorColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        appController
                                            .deletarFuncionario(funcionario);
                                        Get.back();
                                      },
                                      child: const Text("Confirmar"),
                                    ),
                                    cancel: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      onTap: () =>
                          Get.to(FuncionarioDetalhes(funcionario: funcionario)),
                    );
                  })
              : const Center(
                  child: Text("Nenhum funcionário encontrado."),
                ),
        );
      }
    });
  }
}
