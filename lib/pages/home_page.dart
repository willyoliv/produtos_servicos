import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:produtos_servicos/controllers/AppController.dart';
import 'package:produtos_servicos/models/enums/operacao.dart';
import 'package:produtos_servicos/models/funcionario.dart';
import 'package:produtos_servicos/pages/form_page.dart';

class Homepage extends StatelessWidget {
  final controller = Get.put(AppController());

  Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Funcionários"),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(FormPage(tipoOperacao: TipoOperacao.SALVAR));
              },
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ativos", icon: Icon(Icons.person)),
              Tab(text: "Demitidos", icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: GetX<AppController>(builder: (controller) {
                return ListView.builder(
                    itemCount: controller.funcionarios.length,
                    itemBuilder: (context, index) {
                      Funcionario funcionario = controller.funcionarios[index];
                      return SizedBox(
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
                                  controller.deleteFuncionario(funcionario.id);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    });
              }),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
