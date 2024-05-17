// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cli.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Cli extends _Cli with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Cli(
    String url,
    String ref,
    String name,
    int date,
    String installPath, {
    bool isLocal = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Cli>({
        'isLocal': false,
      });
    }
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'ref', ref);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'isLocal', isLocal);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'installPath', installPath);
  }

  Cli._();

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
  int get date => RealmObjectBase.get<int>(this, 'date') as int;
  @override
  set date(int value) => RealmObjectBase.set(this, 'date', value);

  @override
  String get installPath =>
      RealmObjectBase.get<String>(this, 'installPath') as String;
  @override
  set installPath(String value) =>
      RealmObjectBase.set(this, 'installPath', value);

  @override
  Stream<RealmObjectChanges<Cli>> get changes =>
      RealmObjectBase.getChanges<Cli>(this);

  @override
  Cli freeze() => RealmObjectBase.freezeObject<Cli>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'url': url.toEJson(),
      'ref': ref.toEJson(),
      'name': name.toEJson(),
      'isLocal': isLocal.toEJson(),
      'date': date.toEJson(),
      'installPath': installPath.toEJson(),
    };
  }

  static EJsonValue _toEJson(Cli value) => value.toEJson();
  static Cli _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'url': EJsonValue url,
        'ref': EJsonValue ref,
        'name': EJsonValue name,
        'isLocal': EJsonValue isLocal,
        'date': EJsonValue date,
        'installPath': EJsonValue installPath,
      } =>
        Cli(
          fromEJson(url),
          fromEJson(ref),
          fromEJson(name),
          fromEJson(date),
          fromEJson(installPath),
          isLocal: fromEJson(isLocal),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Cli._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Cli, 'Cli', [
      SchemaProperty('url', RealmPropertyType.string),
      SchemaProperty('ref', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('isLocal', RealmPropertyType.bool),
      SchemaProperty('date', RealmPropertyType.int),
      SchemaProperty('installPath', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
