import 'package:get/get.dart';
import 'package:produtos_servicos/models/funcionario.dart';
import 'package:produtos_servicos/repositories/funcionario_repository.dart';

class AppController extends GetxController {
  final FuncionarioRepository _funcionarioRepository =
      Get.put(FuncionarioRepository());
  final _funcionarios = <Funcionario>[].obs;
  final _funcionariosDemitidos = <Funcionario>[].obs;
  final _listaFuncionarioDB = <Funcionario>[].obs;
  RxBool loading = false.obs;

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

  @override
  void onReady() async {
    start();
    super.onReady();
  }

  Future start() async {
    loading(true);
    try {
      _funcionarioRepository.getAll().then((data) {
        _listaFuncionarioDB.value = data;
        _funcionarios.value = _listaFuncionarioDB
            .where((funcionario) => funcionario.isFuncionarioAtivo)
            .toList();
        _funcionariosDemitidos.value = _listaFuncionarioDB
            .where((funcionario) => !funcionario.isFuncionarioAtivo)
            .toList();
        loading(false);
      });
    } catch (e) {
      loading(false);
    }
  }

  void deletarFuncionarioListaLocal(Funcionario funcionario) {
    if (funcionario.isFuncionarioAtivo) {
      _funcionarios.removeWhere((f) => f.id == funcionario.id);
    } else {
      _funcionariosDemitidos.removeWhere((f) => f.id == funcionario.id);
    }
  }

  void demitirOuReadimitirFuncionario(Funcionario funcionario) async {
    if (funcionario.isFuncionarioAtivo) {
      deletarFuncionarioListaLocal(funcionario);
      funcionario.isFuncionarioAtivo = false;
      funcionario.dataDesligamento = DateTime.now();
      _funcionariosDemitidos.add(funcionario);
    } else {
      deletarFuncionarioListaLocal(funcionario);
      funcionario.isFuncionarioAtivo = true;
      _funcionarios.add(funcionario);
    }
    await _funcionarioRepository.update(funcionario);
  }

  void criarFuncionario(Map<String, String> dadosForm) async {
    Funcionario funcionario = Funcionario(
        nome: dadosForm['nome']!,
        cargo: dadosForm['cargo']!,
        setor: dadosForm['setor']!,
        dataNascimento: DateTime.parse(dadosForm['dataNascimento']!),
        dataContratacao: DateTime.parse(dadosForm['dataContratacao']!),
        isFuncionarioAtivo: true,
        dataDesligamento: DateTime.utc(2050));
    Funcionario novoFuncionario =
        await _funcionarioRepository.create(funcionario);
    _funcionarios.add(novoFuncionario);
  }

  void deletarFuncionario(Funcionario funcionario) async {
    await _funcionarioRepository.delete(funcionario.id!);
    deletarFuncionarioListaLocal(funcionario);
  }

  void atualizarFuncionario(
      Map<String, String> dadosForm, Funcionario funcionario) async {
    funcionario.nome = dadosForm['nome']!;
    funcionario.cargo = dadosForm['cargo']!;
    funcionario.setor = dadosForm['setor']!;
    funcionario.dataNascimento = DateTime.parse(dadosForm['dataNascimento']!);
    funcionario.dataContratacao = DateTime.parse(dadosForm['dataContratacao']!);
    await _funcionarioRepository.update(funcionario);

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
}
