import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:produtos_servicos/controllers/AppController.dart';
import 'package:produtos_servicos/pages/form_page.dart';

class Homepage extends StatelessWidget {
  final controller = Get.put(AppController());

  Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            Get.to(FormPage());
          },
          icon: const Icon(Icons.add),
        ),
      ]),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: GetX<AppController>(builder: (controller) {
          return ListView.builder(
              itemCount: controller.funcionarios.length,
              itemBuilder: (context, index) {
                return Text("data");
              });
        }),
      ),
    );
  }
}
