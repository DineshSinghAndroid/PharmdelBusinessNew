import 'package:drift/drift.dart';

@DataClassName('tokens')
class Token extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get token => text()();
}
