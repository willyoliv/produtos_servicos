import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:produtos_servicos/controllers/AppController.dart';

class FormPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  // final _nomeFocusNode = FocusNode();
  final _dataNascimentoFocusNode = FocusNode();
  final _dataContratacaoFocusNode = FocusNode();
  final _dataNascimentoController = TextEditingController();
  final _dataContratacaoController = TextEditingController();
  final _formData = <String, String>{};

  final controller = Get.put(AppController());

  FormPage({Key? key}) : super(key: key);

  Future<DateTime?> _selecionarDataNascimento(
      BuildContext context, DateTime firstDate, DateTime lastDate) async {
    final dataAtual = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataAtual,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      return picked;
    }
  }

  void _submit() {
    var isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    controller.addFuncionario(_formData);
    _form.currentState!.reset();
    _dataNascimentoController.clear();
    _dataNascimentoFocusNode.unfocus();
    _dataContratacaoFocusNode.unfocus();
    _dataContratacaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Funcionário"),
        actions: [IconButton(onPressed: _submit, icon: const Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Nome'),
                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
                // textInputAction: TextInputAction.next,
                // onFieldSubmitted: (_) {
                //   FocusScope.of(context).requestFocus(_dataNascimentoFocusNode);
                // },
                onSaved: (value) => _formData['nome'] = value!,
                validator: (value) {
                  bool isEmpty = value!.trim().isEmpty;
                  bool isInvalid = value.trim().length < 3;

                  if (isEmpty || isInvalid) {
                    return 'Informe um Nome com no mínimo 3 letras!';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Data de nascimento'),
                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),
                ),
                textInputAction: TextInputAction.next,
                // onFieldSubmitted: (_) {
                //   FocusScope.of(context).requestFocus(_dataNascimentoFocusNode);
                // },
                controller: _dataNascimentoController,
                focusNode: _dataNascimentoFocusNode,
                readOnly: true,
                onTap: () {
                  _selecionarDataNascimento(
                          context, DateTime(1970), DateTime.now())
                      .then((DateTime? value) {
                    _formData['dataNascimento'] = value!.toString();
                    String dataNascimento =
                        DateFormat('dd/MM/yyyy').format(value);
                    _dataNascimentoController.text = dataNascimento;
                  });
                  // _dataNascimentoFocusNode.unfocus();
                },
                // onSaved: (value) => _formData['dataNascimento'] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Escolha a data de nascimento!';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Data da contratação'),
                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),
                ),
                controller: _dataContratacaoController,
                focusNode: _dataContratacaoFocusNode,
                readOnly: true,
                onTap: () {
                  _selecionarDataNascimento(context, DateTime.now(),
                          DateTime.now().add(const Duration(days: 15)))
                      .then((DateTime? value) {
                    _formData['dataContratacao'] = value!.toString();
                    String dataContratacao =
                        DateFormat('dd/MM/yyyy').format(value);
                    _dataContratacaoController.text = dataContratacao;
                  });
                  // _dataContratacaoFocusNode.unfocus();
                },
                // onSaved: (value) => _formData['dataContratacao'] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data de contratacao!';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _formData['Cargo'],
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Cargo'),
                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
                items: controller.cargos
                    .map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                    ),
                  );
                }).toList(),
                onChanged: (value) => _formData['cargo'] = value!,
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um cargo!';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Setor'),
                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
                items: controller.setores
                    .map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                    ),
                  );
                }).toList(),
                onChanged: (value) => _formData['setor'] = value!,
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um Setor!';
                  }

                  return null;
                },
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       child: const Text("Salvar",
              //           style: TextStyle(color: Colors.white, fontSize: 18)),
              //       style: ElevatedButton.styleFrom(
              //         fixedSize: const Size(130, 50),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(30.0),
              //         ),
              //       ),
              //       onPressed: () {
              //         _form.currentState!.save();
              //         print(_formData);
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
