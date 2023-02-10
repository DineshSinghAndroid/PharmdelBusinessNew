import 'package:drift/drift.dart';

@DataClassName('order_complete_data')
class OrderCompleteData extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get remarks => text()();

  IntColumn get userId => integer()();

  TextColumn get deliveredTo => text()();

  TextColumn get addDelCharge => text()();

  TextColumn get notPaidReason => text()();

  IntColumn get subsId => integer()();

  TextColumn get rxInvoice => text()();

  TextColumn get rxCharge => text()();

  TextColumn get paymentMethode => text()();

  TextColumn get deliveryId => text()();

  TextColumn get routeId => text()();

  TextColumn get customerRemarks => text()();

  TextColumn get baseSignature => text()();

  TextColumn get baseImage => text()();

  TextColumn get date_Time => text()();

  IntColumn get deliveryStatus => integer()();

  IntColumn get exemptionId => integer()();

  TextColumn get questionAnswerModels => text()();

  TextColumn get paymentStatus => text()();

  TextColumn get reschudleDate => text()();

  TextColumn get param1 => text()();

  TextColumn get param2 => text()();

  TextColumn get param3 => text()();

  TextColumn get param4 => text()();

  TextColumn get param5 => text()();

  TextColumn get param6 => text()();

  TextColumn get param7 => text()();

  TextColumn get param8 => text()();

  TextColumn get param10 => text()();

  TextColumn get param9 => text()();

  RealColumn get latitude => real()();

  RealColumn get longitude => real()();
}
