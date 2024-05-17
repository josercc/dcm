import 'package:dcm/dcm.dart';
import 'package:realm_dart/realm.dart';

class CliVersionManager {
  final String? prefix;
  final Realm _realm;
  CliVersionManager({this.prefix})
      : _realm = Realm(
            Configuration.local([Cli.schema], path: Path(prefix).realmPath));

  Future<bool> isExitCli(String url, String ref) async {
    final list = _realm.all<Cli>().query(r'url == $0 && ref == $1', [url, ref]);
    return list.isNotEmpty;
  }

  Future<Cli?> queryFromName(String name, String ref) async {
    return _realm
        .query<Cli>(r'name = $0 && ref == $1', [name, ref]).firstOrNull;
  }

  Future<List<Cli>> allInstalled() => Future.value(_realm.all<Cli>().toList());

  Future<void> addCli(Cli cli) => _realm.writeAsync(() => _realm.add(cli));

  Future<void> addClis(List<Cli> clis) =>
      _realm.writeAsync(() => _realm.addAll(clis));

  Future<void> deleteCli(Cli cli) =>
      _realm.writeAsync(() => _realm.delete(cli));
}
