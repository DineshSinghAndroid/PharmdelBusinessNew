import 'package:drift/drift.dart';

@DataClassName('delivery_list')
class DeliveryList extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer()();
  IntColumn get deliveryStatus => integer()();
  IntColumn get pharmacyId => integer()();
  IntColumn get isDelCharge => integer()();
  IntColumn get isSubsCharge => integer()();
  IntColumn get totalStorageFridge => integer()();
  IntColumn get totalControlledDrugs => integer()();
  IntColumn get nursing_home_id => integer()();
  TextColumn get status => text()();
  TextColumn get routeId => text()();
  TextColumn get userId => text()();
  TextColumn get param1 => text()();
  TextColumn get param2 => text()();
  TextColumn get param3 => text()();
  TextColumn get param4 => text()();
  TextColumn get param5 => text()();
  TextColumn get param6 => text()();
  TextColumn get bagSize => text()();
  TextColumn get paymentStatus => text()();
  TextColumn get exemption => text()();
  TextColumn get isStorageFridge => text()();
  TextColumn get parcelBoxName => text()();
  TextColumn get sortBy => text()();
  TextColumn get isControlledDrugs => text()();
  TextColumn get deliveryNotes => text()();
  TextColumn get existingDeliveryNotes => text()();
  TextColumn get rxCharge => text()();
  IntColumn get rxInvoice => integer()();
  IntColumn get subsId => integer()();
  TextColumn get delCharge => text()();
  TextColumn get serviceName => text()();
  TextColumn get isCronCreated => text()();
  TextColumn get pmr_type => text()();
  TextColumn get pr_id => text()();
  TextColumn get pharmacyName => text()();
}

@DataClassName('customer_details')
class CustomerDetails extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer()();
  TextColumn get surgeryName => text()();
  TextColumn get service_name => text()();
  TextColumn get firstName => text()();
  TextColumn get param1 => text()();
  TextColumn get param2 => text()();
  TextColumn get param3 => text()();
  TextColumn get param4 => text()();
  TextColumn get middleName => text()();
  TextColumn get lastName => text()();
  TextColumn get mobile => text()();
  TextColumn get title => text()();
  TextColumn get address => text()();
  IntColumn get order_id => integer()();
}

@DataClassName('customer_address')
class CustomerAddresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address1 => text()();
  TextColumn get alt_address => text()();
  TextColumn get address2 => text()();
  TextColumn get postCode => text()();
  RealColumn get latitude => real()();
  TextColumn get param1 => text()();
  TextColumn get param2 => text()();
  TextColumn get param3 => text()();
  TextColumn get param4 => text()();
  RealColumn get longitude => real()();
  TextColumn get duration => text()();
  TextColumn get matchAddress => text()();
  IntColumn get order_id => integer()();
}

@DataClassName('exemptions')
class ExemptionsData extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exemptionId => integer()();
  TextColumn get name => text()();
  TextColumn get serialId => text()();
}


@DataClassName('tokens')
class Token extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get token => text()();
}

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
