// ignore_for_file: unused_element

part of 'cli.dart';

RealmSchemaCreate<Cli> get $CliCreate {
  return RealmSchemaCreate(Cli.schema, (map) {
    return Cli(
      RealmSchemaCreate.valueFromMap<Uuid>(map, 'id')!,
      url: RealmSchemaCreate.valueFromMap<String>(map, 'url') ?? '',
      ref: RealmSchemaCreate.valueFromMap<String>(map, 'ref') ?? '',
      name: RealmSchemaCreate.valueFromMap<String>(map, 'name') ?? '',
      isLocal: RealmSchemaCreate.valueFromMap<bool>(map, 'isLocal') ?? false,
    );
  });
}
