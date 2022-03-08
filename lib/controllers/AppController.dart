import 'package:get/get.dart';
import 'package:produtos_servicos/models/funcionario.dart';
import 'package:produtos_servicos/repositories/funcionario_repository.dart';
import 'package:produtos_servicos/utils/enum_states.dart';

class AppController extends GetxController {
  final FuncionarioRepository _funcionarioRepository = FuncionarioRepository();
  int id = 0;
  RxList<Funcionario> _funcionarios = <Funcionario>[].obs;
  RxList<Funcionario> _funcionariosDemitidos = <Funcionario>[].obs;
  RxList<Funcionario> _listaFuncionarioDB = <Funcionario>[].obs;

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

  get listaFuncionarioDB => _listaFuncionarioDB;

  // void addFuncionario(Map<String, String> dadosForm) {
  //   Funcionario funcionario = Funcionario(
  //       id: id,
  //       nome: dadosForm['nome']!,
  //       cargo: dadosForm['cargo']!,
  //       setor: dadosForm['setor']!,
  //       dataNascimento: DateTime.parse(dadosForm['dataNascimento']!),
  //       dataContratacao: DateTime.parse(dadosForm['dataContratacao']!),
  //       isFuncionarioAtivo: true,
  //       dataDesligamento: DateTime.utc(0));
  //   _funcionarios.add(funcionario);
  //   id++;
  // }

  // void updateFuncionario(
  //     Map<String, String> dadosForm, Funcionario funcionario) {
  //   funcionario.nome = dadosForm['nome']!;
  //   funcionario.cargo = dadosForm['cargo']!;
  //   funcionario.setor = dadosForm['setor']!;
  //   funcionario.dataNascimento = DateTime.parse(dadosForm['dataNascimento']!);
  //   funcionario.dataContratacao = DateTime.parse(dadosForm['dataContratacao']!);

  //   if (funcionario.isFuncionarioAtivo) {
  //     _funcionarios[_funcionarios.indexWhere(
  //             (funcionarioItem) => funcionarioItem.id == funcionario.id)] =
  //         funcionario;
  //   } else {
  //     _funcionariosDemitidos[_funcionariosDemitidos.indexWhere(
  //             (funcionarioItem) => funcionarioItem.id == funcionario.id)] =
  //         funcionario;
  //   }
  // }

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
      _funcionariosDemitidos.refresh();
    } else {
      deletarFuncionarioListaLocal(funcionario);
      funcionario.isFuncionarioAtivo = true;
      _funcionarios.add(funcionario);
      _funcionarios.refresh();
    }
    await _funcionarioRepository.update(funcionario);
  }

  Future start() async {
    try {
      _listaFuncionarioDB = await _funcionarioRepository.getAll();
      // _listaFuncionarioDB.refresh();
      _funcionarios = RxList.of(_listaFuncionarioDB
          .where((funcionario) => funcionario.isFuncionarioAtivo)
          .toList());
      _funcionariosDemitidos = RxList.of(_listaFuncionarioDB
          .where((funcionario) => !funcionario.isFuncionarioAtivo)
          .toList());
      _funcionarios.refresh();
      _funcionariosDemitidos.refresh();
      update();
    } catch (e) {
      print(e);
    }
  }

  void criarFuncionario(Map<String, String> dadosForm) async {
    Funcionario funcionario = Funcionario(
        nome: dadosForm['nome']!,
        cargo: dadosForm['cargo']!,
        setor: dadosForm['setor']!,
        dataNascimento: DateTime.parse(dadosForm['dataNascimento']!),
        dataContratacao: DateTime.parse(dadosForm['dataContratacao']!),
        isFuncionarioAtivo: true,
        dataDesligamento: DateTime.now());
    Funcionario novoFuncionario =
        await _funcionarioRepository.create(funcionario);
    _funcionarios.add(novoFuncionario);
    _funcionarios.refresh();
  }

  void deletarFuncionario(Funcionario funcionario) async {
    // if (funcionario.isFuncionarioAtivo) {
    //   deletarFuncionarioListaLocal(funcionario);
    //   funcionario.isFuncionarioAtivo = false;
    //   funcionario.dataDesligamento = DateTime.now();
    //   _funcionariosDemitidos.add(funcionario);
    //   _funcionariosDemitidos.refresh();
    // } else {
    //   deletarFuncionarioListaLocal(funcionario);
    //   funcionario.isFuncionarioAtivo = true;
    //   _funcionarios.add(funcionario);
    //   _funcionarios.refresh();
    // }
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
      _funcionarios.refresh();
    } else {
      _funcionariosDemitidos[_funcionariosDemitidos.indexWhere(
              (funcionarioItem) => funcionarioItem.id == funcionario.id)] =
          funcionario;
      _funcionariosDemitidos.refresh();
    }
  }
}
