// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cli.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Cli extends _Cli with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Cli(
    Uuid id, {
    String url = '',
    String ref = '',
    String name = '',
    bool isLocal = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Cli>({
        'url': '',
        'ref': '',
        'name': '',
        'isLocal': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'ref', ref);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'isLocal', isLocal);
  }

  Cli._();

  @override
  Uuid get id => RealmObjectBase.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get url => RealmObjectBase.get<String>(this, 'url') as String;
  @override
  set url(String value) => RealmObjectBase.set(this, 'url', value);

  @override
  String get ref => RealmObjectBase.get<String>(this, 'ref') as String;
  @override
  set ref(String value) => RealmObjectBase.set(this, 'ref', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  bool get isLocal => RealmObjectBase.get<bool>(this, 'isLocal') as bool;
  @override
  set isLocal(bool value) => RealmObjectBase.set(this, 'isLocal', value);

  @override
  Stream<RealmObjectChanges<Cli>> get changes =>
      RealmObjectBase.getChanges<Cli>(this);

  @override
  Cli freeze() => RealmObjectBase.freezeObject<Cli>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Cli._);
    return const SchemaObject(ObjectType.realmObject, Cli, 'Cli', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('url', RealmPropertyType.string),
      SchemaProperty('ref', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('isLocal', RealmPropertyType.bool),
    ]);
  }
}
