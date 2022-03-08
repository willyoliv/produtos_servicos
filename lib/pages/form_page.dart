import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:produtos_servicos/controllers/AppController.dart';
import 'package:produtos_servicos/models/enums/operacao.dart';
import 'package:produtos_servicos/models/funcionario.dart';

class FormPage extends StatefulWidget {
  final TipoOperacao tipoOperacao;
  final Funcionario? funcionario;

  const FormPage({Key? key, required this.tipoOperacao, this.funcionario})
      : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _form = GlobalKey<FormState>();

  final _dataNascimentoFocusNode = FocusNode();

  final _dataContratacaoFocusNode = FocusNode();

  final _dataNascimentoController = TextEditingController();

  final _dataContratacaoController = TextEditingController();

  final _formData = <String, String>{};

  final controller = Get.put(AppController());

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
    if (widget.tipoOperacao == TipoOperacao.SALVAR) {
      controller.addFuncionario(_formData);
      _form.currentState!.reset();
      _dataNascimentoController.clear();
      _dataNascimentoFocusNode.unfocus();
      _dataContratacaoController.clear();
      _dataContratacaoFocusNode.unfocus();
      Get.snackbar('Cadastro realizado.', 'Funcionário cadastrado com sucesso',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      controller.updateFuncionario(_formData, widget.funcionario!);
      Get.snackbar('Cadastro atualizado.', 'Funcionário atualizado com sucesso',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void preencherFormularioParaEdicao() {
    if (widget.tipoOperacao == TipoOperacao.EDITAR) {
      _formData['nome'] = widget.funcionario!.nome;
      _formData['dataNascimento'] =
          widget.funcionario!.dataNascimento.toString();
      _formData['dataContratacao'] =
          widget.funcionario!.dataContratacao.toString();
      _formData['cargo'] = widget.funcionario!.cargo;
      _formData['setor'] = widget.funcionario!.setor;
      _dataNascimentoController.text =
          DateFormat('dd/MM/yyyy').format(widget.funcionario!.dataNascimento);
      _dataContratacaoController.text =
          DateFormat('dd/MM/yyyy').format(widget.funcionario!.dataContratacao);
    }
  }

  @override
  void initState() {
    super.initState();
    preencherFormularioParaEdicao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.tipoOperacao == TipoOperacao.SALVAR ? 'Cadastrar' : 'Atualizar'} Funcionário"),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: _submit,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              TextFormField(
                initialValue: _formData['nome'],
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data de contratacao!';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _formData['cargo'],
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
                value: _formData['setor'],
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
            ],
          ),
        ),
      ),
    );
  }
}
