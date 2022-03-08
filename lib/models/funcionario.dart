class Funcionario {
  int _id;
  String _nome;
  String _cargo;
  String _setor;
  DateTime _dataNascimento;
  DateTime _dataContratacao;
  late DateTime _dataDesligamento;
  bool _isFuncionarioAtivo = true;

  Funcionario(this._id, this._nome, this._cargo, this._setor,
      this._dataNascimento, this._dataContratacao);

  DateTime get dataDesligamento => _dataDesligamento;

  set dataDesligamento(DateTime value) {
    _dataDesligamento = value;
  }

  int get id => _id;

  DateTime get dataContratacao => _dataContratacao;

  set dataContratacao(DateTime value) {
    _dataContratacao = value;
  }

  DateTime get dataNascimento => _dataNascimento;

  set dataNascimento(DateTime value) {
    _dataNascimento = value;
  }

  String get setor => _setor;

  set setor(String value) {
    _setor = value;
  }

  String get cargo => _cargo;

  set cargo(String value) {
    _cargo = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
