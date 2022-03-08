import 'dart:convert';

class Funcionario {
  int? id;
  String nome;
  String cargo;
  String setor;
  DateTime dataNascimento;
  DateTime dataContratacao;
  DateTime dataDesligamento;
  bool isFuncionarioAtivo;
  Funcionario({
    this.id,
    required this.nome,
    required this.cargo,
    required this.setor,
    required this.dataNascimento,
    required this.dataContratacao,
    required this.dataDesligamento,
    required this.isFuncionarioAtivo,
  });

  Funcionario copyWith({
    int? id,
    String? nome,
    String? cargo,
    String? setor,
    DateTime? dataNascimento,
    DateTime? dataContratacao,
    DateTime? dataDesligamento,
    bool? isFuncionarioAtivo,
  }) {
    return Funcionario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cargo: cargo ?? this.cargo,
      setor: setor ?? this.setor,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      dataContratacao: dataContratacao ?? this.dataContratacao,
      dataDesligamento: dataDesligamento ?? this.dataDesligamento,
      isFuncionarioAtivo: isFuncionarioAtivo ?? this.isFuncionarioAtivo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cargo': cargo,
      'setor': setor,
      'dataNascimento': dataNascimento.millisecondsSinceEpoch,
      'dataContratacao': dataContratacao.millisecondsSinceEpoch,
      'dataDesligamento': dataDesligamento.millisecondsSinceEpoch,
      'isFuncionarioAtivo': isFuncionarioAtivo == true ? 1 : 0,
    };
  }

  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      id: map['id']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      cargo: map['cargo'] ?? '',
      setor: map['setor'] ?? '',
      dataNascimento:
          DateTime.fromMillisecondsSinceEpoch(map['dataNascimento']),
      dataContratacao:
          DateTime.fromMillisecondsSinceEpoch(map['dataContratacao']),
      dataDesligamento:
          DateTime.fromMillisecondsSinceEpoch(map['dataDesligamento']),
      isFuncionarioAtivo: map['isFuncionarioAtivo'] == 1 ? true : false,
    );
  }
}
