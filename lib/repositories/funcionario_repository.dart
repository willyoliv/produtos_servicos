import 'package:get/get.dart';
import 'package:produtos_servicos/db/app_database.dart';
import 'package:produtos_servicos/models/funcionario.dart';

class FuncionarioRepository {
  Future<Funcionario> create(Funcionario funcionario) async {
    final db = await AppDatabase.instance.database;

    final id = await db.insert('funcionarios', funcionario.toMap());

    return funcionario.copyWith(id: id);
  }

  Future<RxList<Funcionario>> getAll() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('funcionarios');

    return RxList.of(result.map((json) => Funcionario.fromMap(json)).toList());
  }

  Future<int> update(Funcionario funcionario) async {
    final db = await AppDatabase.instance.database;

    return db.update(
      'funcionarios',
      funcionario.toMap(),
      where: 'id = ?',
      whereArgs: [funcionario.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.delete(
      'funcionarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
