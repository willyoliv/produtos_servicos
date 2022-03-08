import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:produtos_servicos/controllers/AppController.dart';
import 'package:produtos_servicos/models/enums/operacao.dart';
import 'package:produtos_servicos/pages/form_page.dart';
import 'package:produtos_servicos/widgets/lista_funcionarios_widget.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    await controller.start();
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Funcionários"),
          actions: [
            IconButton(
              splashRadius: 20,
              onPressed: () {
                Get.to(const FormPage(tipoOperacao: TipoOperacao.SALVAR));
              },
              icon: const Icon(Icons.person_add),
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
          physics: const BouncingScrollPhysics(),
          children: [
            ListaFuncionariosWidget(
              isFuncionariosAtivos: true,
            ),
            ListaFuncionariosWidget(
              isFuncionariosAtivos: false,
            ),
          ],
        ),
      ),
    );
  }
}
