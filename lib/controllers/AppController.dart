import 'package:get/get.dart';
import 'package:produtos_servicos/models/funcionario.dart';

class AppController extends GetxController {
  int id = 0;
  final List<Funcionario> _funcionarios = <Funcionario>[].obs;
  final List<Funcionario> _funcionariosDemitidos = <Funcionario>[].obs;
  final List<String> _cargos = [
    "Gestor de projetos",
    "Arquiteto de TI",
    "Programador",
    "Administrador de banco de dados",
    "Desenvolvedor web",
    "Desenvolvedor mobile",
    "Desenvolvedor backend"
  ];
  final List<String> _setores = ["TI"];

  get cargos => _cargos;

  get setores => _setores;

  get funcionarios => _funcionarios;
  get funcionariosDemitidos => _funcionariosDemitidos;

  void addFuncionario(Map<String, String> dadosForm) {
    Funcionario funcionario = Funcionario(
      id,
      dadosForm['nome']!,
      dadosForm['cargo']!,
      dadosForm['setor']!,
      DateTime.parse(dadosForm['dataNascimento']!),
      DateTime.parse(dadosForm['dataContratacao']!),
    );
    _funcionarios.add(funcionario);
    id++;
  }

  void updateFuncionario(
      Map<String, String> dadosForm, Funcionario funcionario) {
    funcionario.nome = dadosForm['nome']!;
    funcionario.cargo = dadosForm['cargo']!;
    funcionario.setor = dadosForm['setor']!;
    funcionario.dataNascimento = DateTime.parse(dadosForm['dataNascimento']!);
    funcionario.dataContratacao = DateTime.parse(dadosForm['dataContratacao']!);

    if (funcionario.isFuncionarioAtivo) {
      _funcionarios[_funcionarios.indexWhere(
              (funcionarioItem) => funcionarioItem.id == funcionario.id)] =
          funcionario;
    } else {
      _funcionariosDemitidos[_funcionariosDemitidos.indexWhere(
              (funcionarioItem) => funcionarioItem.id == funcionario.id)] =
          funcionario;
    }
  }

  void deleteFuncionario(Funcionario funcionario) {
    if (funcionario.isFuncionarioAtivo) {
      _funcionarios.removeWhere((f) => f.id == funcionario.id);
    } else {
      _funcionariosDemitidos.removeWhere((f) => f.id == funcionario.id);
    }
  }

  void demitirOuReadimitirFuncionario(Funcionario funcionario) {
    if (funcionario.isFuncionarioAtivo) {
      deleteFuncionario(funcionario);
      funcionario.isFuncionarioAtivo = false;
      funcionario.dataDesligamento = DateTime.now();
      _funcionariosDemitidos.add(funcionario);
    } else {
      deleteFuncionario(funcionario);
      funcionario.isFuncionarioAtivo = true;
      _funcionarios.add(funcionario);
    }
  }
}
