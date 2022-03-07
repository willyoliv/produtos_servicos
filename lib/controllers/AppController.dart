import 'package:get/get.dart';
import 'package:produtos_servicos/models/funcionario.dart';

class AppController extends GetxController {
  final List<Funcionario> _funcionarios = <Funcionario>[].obs;
  final List<String> _cargos = ["Diretor", "Zelador", "Cozinheiro"];
  final List<String> _setores = ["Secretária", "Transporte", "TI"];

  get cargos => _cargos;

  get setores => _setores;

  get funcionarios => _funcionarios;

  void addFuncionario(Map<String, String> dadosForm) {
    print(dadosForm);
    Funcionario funcionario = Funcionario(
      dadosForm['nome']!,
      dadosForm['cargo']!,
      dadosForm['setor']!,
      DateTime.parse(dadosForm['dataNascimento']!),
      DateTime.parse(dadosForm['dataContratacao']!),
    );
    print(funcionario);
    _funcionarios.add(funcionario);
  }
}
