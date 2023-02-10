import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pharmdel_business/DB/OrderComplete.dart';
import 'package:pharmdel_business/DB/delivery_list.dart';

import 'Token.dart';

part 'MyDatabase.g.dart';

@DriftDatabase(tables: [Token, DeliveryList, CustomerDetails,
  CustomerAddresses, OrderCompleteData, ExemptionsData])
class MyDatabase extends _$MyDatabase {
  static final int schemaVersionCode = 41;
  static final MyDatabase _singleton = MyDatabase._internal();

  factory MyDatabase() {
    return _singleton;
  }

  MyDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => schemaVersionCode;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(

      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < schemaVersionCode) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.deleteTable("tokens");
          await m.deleteTable("delivery_list");
          await m.deleteTable("customer_details");
          await m.deleteTable("customer_address");
          await m.deleteTable("exemptions");
          await m.deleteTable("order_complete_data");
          await m.createAll();
        }
      },
    );
  }

  Future<List<delivery_list>> getAllOutForDeliverys() => select(deliveryList).get();

  Stream<List<delivery_list>> watchAllDeliveries() => select(deliveryList).watch();

  Future<int> insertDeliveries(DeliveryListCompanion list) => into(deliveryList).insert(list);

  Future updateDeliveries(DeliveryListCompanion list) => update(deliveryList).replace(list);

  Future deleteDeliveries(DeliveryListCompanion list) => delete(deliveryList).delete(list);

  Future<List<customer_details>> watchCustomerAllListDetails() async {
    return transaction(() async {
      return await select(customerDetails).get();
    });
  }

  Future<int> insertCustomerDetails(CustomerDetailsCompanion details) async {
    return transaction(() async {
      return await into(customerDetails).insert(details);
    });
  }

  Future<List<customer_details>> getAllCustomerDetails() async {
    return transaction(() async {
      return await select(customerDetails).get();
    });
  }

  Future updateCustomerDetails(CustomerDetailsCompanion details) {
    return transaction(() async {
      return update(customerDetails).replace(details);
    });
  }

  Future deleteCustomerDetails(CustomerDetailsCompanion details) async {
    return transaction(() async {
      return await delete(customerDetails).delete(details);
    });
  }

  Future<List<customer_address>> getAllCustomerAddress() {
    return transaction(() async {
      return await select(customerAddresses).get();
    });
  }

  Future<int> insertCustomerAddress(CustomerAddressesCompanion address) async {
    return transaction(() async {
      return await into(customerAddresses).insert(address);
    });
  }

  Future updateCustomerAddress(CustomerAddressesCompanion address) async {
    return transaction(() async {
      return await update(customerAddresses).replace(address);
    });
  }

  Future deleteCustomerAddress(CustomerAddressesCompanion address) async {
    return transaction(() async {
      return await delete(customerAddresses).delete(address);
    });
  }

  Future<List<order_complete_data>> getAllOrderCompleteData() async {
    return transaction(() async {
      return await select(orderCompleteData).get();
    });
  }

  Future insertOrderCompleteData(OrderCompleteDataCompanion data) async {
    return transaction(() async {
      return await into(orderCompleteData).insert(data);
    });
  }

  Future updateOrderCompleteData(OrderCompleteDataCompanion data) async {
    return transaction(() async {
      return await update(orderCompleteData).replace(data);
    });
  }

  Future deleteOrderCompleteData(OrderCompleteDataCompanion data) async {
    return transaction(() async {
      return await delete(orderCompleteData).delete(data);
    });
  }

  Future insertExemption(ExemptionsDataCompanion exemptions) async {
    return transaction(() async {
      return await into(exemptionsData).insert(exemptions);
    });
  }

  Future<List<exemptions>> getExemptionsList() async {
    return transaction(() async {
      return await select(exemptionsData).get();
    });
  }

  Future insertToken(TokenCompanion data) async {
    return transaction(() async {
      return await into(token).insert(data);
    });
  }

  Future<List<tokens>> getToken() {
    return transaction(() async {
      return await select(token).get();
    });
  }

  Future deleteToken() async {
    return transaction(() async {
      return await (delete(token)).go();
    });
  }

  Future delecteDeliveryById(DeliveryListCompanion orderID) async {
    return transaction(() async {
      return await (delete(deliveryList)).delete(orderID);
    });
  }

  Future delecteCompletedDeliveryById(order_complete_data data) async {
    return transaction(() async {
      return await (delete(orderCompleteData)).delete(data);
    });
  }

  Future<List<delivery_list>> getAllOutForDeliverysOnly() async {
    return transaction(() async {
      return await (select(deliveryList)..where((t) => t.deliveryStatus.equals(4))).get();
    });
  }

  Future<int> updateDeliveryStatus(int orderId, String status, int selectedStatusCode) async {
    return transaction(() async {
      return await (update(deliveryList)..where((t) => t.orderId.equals(orderId))).write(
        DeliveryListCompanion(status: Value(status), deliveryStatus: Value(selectedStatusCode)),
      );
    });
  }

  Future deleteCancleDeliveryListById(int orderId) async {
    return transaction(() async {
      return await (delete(deliveryList)..where((tbl) => tbl.orderId.equals(orderId))).go();
    });
  }

  Future deleteCancleCustomerDetailsById(int orderId) async {
    return transaction(() async {
      return await (delete(customerDetails)..where((tbl) => tbl.order_id.equals(orderId))).go();
    });
  }

  Future deleteCancleAddressDeliveryById(int orderId) async {
    return transaction(() async {
      return await (delete(customerAddresses)..where((tbl) => tbl.order_id.equals(orderId))).go();
    });
  }

  Future delecteDeliveryList() async {
    return transaction(() async {
      return await (delete(deliveryList)).go();
    });
  }

  Future deleteExemptionList() async {
    return transaction(() async {
      return await (delete(exemptionsData)).go();
    });
  }

  Future delecteAddressList() async {
    return transaction(() async {
      return await (delete(customerAddresses)).go();
    });
  }

  Future delecteCustomerList() async {
    return transaction(() async {
      return await (delete(customerDetails)).go();
    });
  }

  Future deleteOrderCompleteList() async {
    return transaction(() async {
      return await (delete(orderCompleteData)).go();
    });
  }

  Future<List<customer_address>> getDeliveryMatchedList(String delivery) async {
    return transaction(() async {
      return await (select(customerAddresses)..where((t) => t.duration.equals(delivery))).get();
    });
  }

  Future<delivery_list?> getDeliveryDetilas(int orderid) async {
    return transaction(() async {
      return await (select(deliveryList)..where((t) => t.orderId.equals(orderid))).getSingleOrNull();
    });
  }

  Future<customer_details?> getCustomerDetilas(int orderid) async {
    return transaction(() async {
      return await (select(customerDetails)..where((t) => t.order_id.equals(orderid))).getSingleOrNull();
    });
  }

  Future<customer_address?> getCustomerAddress(int orderid) async {
    return transaction(() async {
      return await (select(customerAddresses)..where((t) => t.order_id.equals(orderid))).getSingleOrNull();
    });
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pharmdel_db_21.sqlite'));
    return NativeDatabase(file);
  });
}
