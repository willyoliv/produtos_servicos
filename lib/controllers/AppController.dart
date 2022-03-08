import 'package:get/get.dart';
import 'package:produtos_servicos/models/funcionario.dart';

class AppController extends GetxController {
  int id = 0;
  final List<Funcionario> _funcionarios = <Funcionario>[].obs;
  final List<String> _cargos = ["Diretor", "Zelador", "Cozinheiro"];
  final List<String> _setores = ["Secretária", "Transporte", "TI"];

  get cargos => _cargos;

  get setores => _setores;

  get funcionarios => _funcionarios;

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

  void updateFuncionario(Map<String, String> dadosForm, int id) {
    Funcionario funcionario = Funcionario(
      id,
      dadosForm['nome']!,
      dadosForm['cargo']!,
      dadosForm['setor']!,
      DateTime.parse(dadosForm['dataNascimento']!),
      DateTime.parse(dadosForm['dataContratacao']!),
    );
    _funcionarios[_funcionarios
        .indexWhere((funcionario) => funcionario.id == id)] = funcionario;
  }

  void deleteFuncionario(int id) {
    _funcionarios.removeWhere((funcionario) => funcionario.id == id);
  }
}
