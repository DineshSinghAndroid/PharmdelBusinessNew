// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyDatabase.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class tokens extends DataClass implements Insertable<tokens> {
  final int id;
  final String token;

  tokens({required this.id, required this.token});

  factory tokens.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return tokens(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      token: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}token'])!,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['token'] = Variable<String>(token);
    return map;
  }

  TokenCompanion toCompanion(bool nullToAbsent) {
    return TokenCompanion(
      id: Value(id),
      token: Value(token),
    );
  }

  factory tokens.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return tokens(
      id: serializer.fromJson<int>(json['id']),
      token: serializer.fromJson<String>(json['token']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'token': serializer.toJson<String>(token),
    };
  }

  tokens copyWith({int? id, String? token}) => tokens(
        id: id ?? this.id,
        token: token ?? this.token,
      );

  @override
  String toString() {
    return (StringBuffer('tokens(')
          ..write('id: $id, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, token);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is tokens && other.id == this.id && other.token == this.token);
}

class TokenCompanion extends UpdateCompanion<tokens> {
  final Value<int> id;
  final Value<String> token;

  const TokenCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
  });

  TokenCompanion.insert({
    this.id = const Value.absent(),
    required String token,
  }) : token = Value(token);

  static Insertable<tokens> custom({
    Expression<int>? id,
    Expression<String>? token,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
    });
  }

  TokenCompanion copyWith({Value<int>? id, Value<String>? token}) {
    return TokenCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TokenCompanion(')
          ..write('id: $id, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }
}

class $TokenTable extends Token with TableInfo<$TokenTable, tokens> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $TokenTable(this.attachedDatabase, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false, type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String?> token = GeneratedColumn<String?>('token', aliasedName, false, type: const StringType(), requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, token];

  @override
  String get aliasedName => _alias ?? 'token';

  @override
  String get actualTableName => 'token';

  @override
  VerificationContext validateIntegrity(Insertable<tokens> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('token')) {
      context.handle(_tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  tokens map(Map<String, dynamic> data, {String? tablePrefix}) {
    return tokens.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TokenTable createAlias(String alias) {
    return $TokenTable(attachedDatabase, alias);
  }
}

class delivery_list extends DataClass implements Insertable<delivery_list> {
  final int id;
  final int orderId;
  final int deliveryStatus;
  final int pharmacyId;
  final int isDelCharge;
  final int isSubsCharge;
  final int totalStorageFridge;
  final int totalControlledDrugs;
  final int nursing_home_id;
  final String status;
  final String routeId;
  final String userId;
  final String param1;
  final String param2;
  final String param3;
  final String param4;
  final String param5;
  final String param6;
  final String bagSize;
  final String paymentStatus;
  final String exemption;
  final String isStorageFridge;
  final String parcelBoxName;
  final String sortBy;
  final String isControlledDrugs;
  final String deliveryNotes;
  final String existingDeliveryNotes;
  final String rxCharge;
  final int rxInvoice;
  final int subsId;
  final String delCharge;
  final String serviceName;
  final String isCronCreated;
  final String pmr_type;
  final String pr_id;
  final String pharmacyName;

  delivery_list(
      {required this.id,
      required this.orderId,
      required this.deliveryStatus,
      required this.pharmacyId,
      required this.isDelCharge,
      required this.isSubsCharge,
      required this.totalStorageFridge,
      required this.totalControlledDrugs,
      required this.nursing_home_id,
      required this.status,
      required this.routeId,
      required this.userId,
      required this.param1,
      required this.param2,
      required this.param3,
      required this.param4,
      required this.param5,
      required this.param6,
      required this.bagSize,
      required this.paymentStatus,
      required this.exemption,
      required this.isStorageFridge,
      required this.parcelBoxName,
      required this.sortBy,
      required this.isControlledDrugs,
      required this.deliveryNotes,
      required this.existingDeliveryNotes,
      required this.rxCharge,
      required this.rxInvoice,
      required this.subsId,
      required this.delCharge,
      required this.serviceName,
      required this.isCronCreated,
      required this.pmr_type,
      required this.pr_id,
      required this.pharmacyName});

  factory delivery_list.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return delivery_list(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      orderId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order_id'])!,
      deliveryStatus: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}delivery_status'])!,
      pharmacyId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}pharmacy_id'])!,
      isDelCharge: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}is_del_charge'])!,
      isSubsCharge: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}is_subs_charge'])!,
      totalStorageFridge: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}total_storage_fridge'])!,
      totalControlledDrugs: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}total_controlled_drugs'])!,
      nursing_home_id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}nursing_home_id'])!,
      status: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      routeId: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}route_id'])!,
      userId: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      param1: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param1'])!,
      param2: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param2'])!,
      param3: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param3'])!,
      param4: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param4'])!,
      param5: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param5'])!,
      param6: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param6'])!,
      bagSize: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}bag_size'])!,
      paymentStatus: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}payment_status'])!,
      exemption: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}exemption'])!,
      isStorageFridge: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}is_storage_fridge'])!,
      parcelBoxName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}parcel_box_name'])!,
      sortBy: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}sort_by'])!,
      isControlledDrugs: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}is_controlled_drugs'])!,
      deliveryNotes: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}delivery_notes'])!,
      existingDeliveryNotes: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}existing_delivery_notes'])!,
      rxCharge: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}rx_charge'])!,
      rxInvoice: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}rx_invoice'])!,
      subsId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}subs_id'])!,
      delCharge: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}del_charge'])!,
      serviceName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}service_name'])!,
      isCronCreated: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}is_cron_created'])!,
      pmr_type: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}pmr_type'])!,
      pr_id: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}pr_id'])!,
      pharmacyName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}pharmacy_name'])!,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['delivery_status'] = Variable<int>(deliveryStatus);
    map['pharmacy_id'] = Variable<int>(pharmacyId);
    map['is_del_charge'] = Variable<int>(isDelCharge);
    map['is_subs_charge'] = Variable<int>(isSubsCharge);
    map['total_storage_fridge'] = Variable<int>(totalStorageFridge);
    map['total_controlled_drugs'] = Variable<int>(totalControlledDrugs);
    map['nursing_home_id'] = Variable<int>(nursing_home_id);
    map['status'] = Variable<String>(status);
    map['route_id'] = Variable<String>(routeId);
    map['user_id'] = Variable<String>(userId);
    map['param1'] = Variable<String>(param1);
    map['param2'] = Variable<String>(param2);
    map['param3'] = Variable<String>(param3);
    map['param4'] = Variable<String>(param4);
    map['param5'] = Variable<String>(param5);
    map['param6'] = Variable<String>(param6);
    map['bag_size'] = Variable<String>(bagSize);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['exemption'] = Variable<String>(exemption);
    map['is_storage_fridge'] = Variable<String>(isStorageFridge);
    map['parcel_box_name'] = Variable<String>(parcelBoxName);
    map['sort_by'] = Variable<String>(sortBy);
    map['is_controlled_drugs'] = Variable<String>(isControlledDrugs);
    map['delivery_notes'] = Variable<String>(deliveryNotes);
    map['existing_delivery_notes'] = Variable<String>(existingDeliveryNotes);
    map['rx_charge'] = Variable<String>(rxCharge);
    map['rx_invoice'] = Variable<int>(rxInvoice);
    map['subs_id'] = Variable<int>(subsId);
    map['del_charge'] = Variable<String>(delCharge);
    map['service_name'] = Variable<String>(serviceName);
    map['is_cron_created'] = Variable<String>(isCronCreated);
    map['pmr_type'] = Variable<String>(pmr_type);
    map['pr_id'] = Variable<String>(pr_id);
    map['pharmacy_name'] = Variable<String>(pharmacyName);
    return map;
  }

  DeliveryListCompanion toCompanion(bool nullToAbsent) {
    return DeliveryListCompanion(
      id: Value(id),
      orderId: Value(orderId),
      deliveryStatus: Value(deliveryStatus),
      pharmacyId: Value(pharmacyId),
      isDelCharge: Value(isDelCharge),
      isSubsCharge: Value(isSubsCharge),
      totalStorageFridge: Value(totalStorageFridge),
      totalControlledDrugs: Value(totalControlledDrugs),
      nursing_home_id: Value(nursing_home_id),
      status: Value(status),
      routeId: Value(routeId),
      userId: Value(userId),
      param1: Value(param1),
      param2: Value(param2),
      param3: Value(param3),
      param4: Value(param4),
      param5: Value(param5),
      param6: Value(param6),
      bagSize: Value(bagSize),
      paymentStatus: Value(paymentStatus),
      exemption: Value(exemption),
      isStorageFridge: Value(isStorageFridge),
      parcelBoxName: Value(parcelBoxName),
      sortBy: Value(sortBy),
      isControlledDrugs: Value(isControlledDrugs),
      deliveryNotes: Value(deliveryNotes),
      existingDeliveryNotes: Value(existingDeliveryNotes),
      rxCharge: Value(rxCharge),
      rxInvoice: Value(rxInvoice),
      subsId: Value(subsId),
      delCharge: Value(delCharge),
      serviceName: Value(serviceName),
      isCronCreated: Value(isCronCreated),
      pmr_type: Value(pmr_type),
      pr_id: Value(pr_id),
      pharmacyName: Value(pharmacyName),
    );
  }

  factory delivery_list.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return delivery_list(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      deliveryStatus: serializer.fromJson<int>(json['deliveryStatus']),
      pharmacyId: serializer.fromJson<int>(json['pharmacyId']),
      isDelCharge: serializer.fromJson<int>(json['isDelCharge']),
      isSubsCharge: serializer.fromJson<int>(json['isSubsCharge']),
      totalStorageFridge: serializer.fromJson<int>(json['totalStorageFridge']),
      totalControlledDrugs: serializer.fromJson<int>(json['totalControlledDrugs']),
      nursing_home_id: serializer.fromJson<int>(json['nursing_home_id']),
      status: serializer.fromJson<String>(json['status']),
      routeId: serializer.fromJson<String>(json['routeId']),
      userId: serializer.fromJson<String>(json['userId']),
      param1: serializer.fromJson<String>(json['param1']),
      param2: serializer.fromJson<String>(json['param2']),
      param3: serializer.fromJson<String>(json['param3']),
      param4: serializer.fromJson<String>(json['param4']),
      param5: serializer.fromJson<String>(json['param5']),
      param6: serializer.fromJson<String>(json['param6']),
      bagSize: serializer.fromJson<String>(json['bagSize']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      exemption: serializer.fromJson<String>(json['exemption']),
      isStorageFridge: serializer.fromJson<String>(json['isStorageFridge']),
      parcelBoxName: serializer.fromJson<String>(json['parcelBoxName']),
      sortBy: serializer.fromJson<String>(json['sortBy']),
      isControlledDrugs: serializer.fromJson<String>(json['isControlledDrugs']),
      deliveryNotes: serializer.fromJson<String>(json['deliveryNotes']),
      existingDeliveryNotes: serializer.fromJson<String>(json['existingDeliveryNotes']),
      rxCharge: serializer.fromJson<String>(json['rxCharge']),
      rxInvoice: serializer.fromJson<int>(json['rxInvoice']),
      subsId: serializer.fromJson<int>(json['subsId']),
      delCharge: serializer.fromJson<String>(json['delCharge']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      isCronCreated: serializer.fromJson<String>(json['isCronCreated']),
      pmr_type: serializer.fromJson<String>(json['pmr_type']),
      pr_id: serializer.fromJson<String>(json['pr_id']),
      pharmacyName: serializer.fromJson<String>(json['pharmacyName']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'deliveryStatus': serializer.toJson<int>(deliveryStatus),
      'pharmacyId': serializer.toJson<int>(pharmacyId),
      'isDelCharge': serializer.toJson<int>(isDelCharge),
      'isSubsCharge': serializer.toJson<int>(isSubsCharge),
      'totalStorageFridge': serializer.toJson<int>(totalStorageFridge),
      'totalControlledDrugs': serializer.toJson<int>(totalControlledDrugs),
      'nursing_home_id': serializer.toJson<int>(nursing_home_id),
      'status': serializer.toJson<String>(status),
      'routeId': serializer.toJson<String>(routeId),
      'userId': serializer.toJson<String>(userId),
      'param1': serializer.toJson<String>(param1),
      'param2': serializer.toJson<String>(param2),
      'param3': serializer.toJson<String>(param3),
      'param4': serializer.toJson<String>(param4),
      'param5': serializer.toJson<String>(param5),
      'param6': serializer.toJson<String>(param6),
      'bagSize': serializer.toJson<String>(bagSize),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'exemption': serializer.toJson<String>(exemption),
      'isStorageFridge': serializer.toJson<String>(isStorageFridge),
      'parcelBoxName': serializer.toJson<String>(parcelBoxName),
      'sortBy': serializer.toJson<String>(sortBy),
      'isControlledDrugs': serializer.toJson<String>(isControlledDrugs),
      'deliveryNotes': serializer.toJson<String>(deliveryNotes),
      'existingDeliveryNotes': serializer.toJson<String>(existingDeliveryNotes),
      'rxCharge': serializer.toJson<String>(rxCharge),
      'rxInvoice': serializer.toJson<int>(rxInvoice),
      'subsId': serializer.toJson<int>(subsId),
      'delCharge': serializer.toJson<String>(delCharge),
      'serviceName': serializer.toJson<String>(serviceName),
      'isCronCreated': serializer.toJson<String>(isCronCreated),
      'pmr_type': serializer.toJson<String>(pmr_type),
      'pr_id': serializer.toJson<String>(pr_id),
      'pharmacyName': serializer.toJson<String>(pharmacyName),
    };
  }

  delivery_list copyWith({int? id, int? orderId, int? deliveryStatus, int? pharmacyId, int? isDelCharge, int? isSubsCharge, int? totalStorageFridge, int? totalControlledDrugs, int? nursing_home_id, String? status, String? routeId, String? userId, String? param1, String? param2, String? param3, String? param4, String? param5, String? param6, String? bagSize, String? paymentStatus, String? exemption, String? isStorageFridge, String? parcelBoxName, String? sortBy, String? isControlledDrugs, String? deliveryNotes, String? existingDeliveryNotes, String? rxCharge, int? rxInvoice, int? subsId, String? delCharge, String? serviceName, String? isCronCreated, String? pmr_type, String? pr_id, String? pharmacyName}) => delivery_list(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        deliveryStatus: deliveryStatus ?? this.deliveryStatus,
        pharmacyId: pharmacyId ?? this.pharmacyId,
        isDelCharge: isDelCharge ?? this.isDelCharge,
        isSubsCharge: isSubsCharge ?? this.isSubsCharge,
        totalStorageFridge: totalStorageFridge ?? this.totalStorageFridge,
        totalControlledDrugs: totalControlledDrugs ?? this.totalControlledDrugs,
        nursing_home_id: nursing_home_id ?? this.nursing_home_id,
        status: status ?? this.status,
        routeId: routeId ?? this.routeId,
        userId: userId ?? this.userId,
        param1: param1 ?? this.param1,
        param2: param2 ?? this.param2,
        param3: param3 ?? this.param3,
        param4: param4 ?? this.param4,
        param5: param5 ?? this.param5,
        param6: param6 ?? this.param6,
        bagSize: bagSize ?? this.bagSize,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        exemption: exemption ?? this.exemption,
        isStorageFridge: isStorageFridge ?? this.isStorageFridge,
        parcelBoxName: parcelBoxName ?? this.parcelBoxName,
        sortBy: sortBy ?? this.sortBy,
        isControlledDrugs: isControlledDrugs ?? this.isControlledDrugs,
        deliveryNotes: deliveryNotes ?? this.deliveryNotes,
        existingDeliveryNotes: existingDeliveryNotes ?? this.existingDeliveryNotes,
        rxCharge: rxCharge ?? this.rxCharge,
        rxInvoice: rxInvoice ?? this.rxInvoice,
        subsId: subsId ?? this.subsId,
        delCharge: delCharge ?? this.delCharge,
        serviceName: serviceName ?? this.serviceName,
        isCronCreated: isCronCreated ?? this.isCronCreated,
        pmr_type: pmr_type ?? this.pmr_type,
        pr_id: pr_id ?? this.pr_id,
        pharmacyName: pharmacyName ?? this.pharmacyName,
      );

  @override
  String toString() {
    return (StringBuffer('delivery_list(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('deliveryStatus: $deliveryStatus, ')
          ..write('pharmacyId: $pharmacyId, ')
          ..write('isDelCharge: $isDelCharge, ')
          ..write('isSubsCharge: $isSubsCharge, ')
          ..write('totalStorageFridge: $totalStorageFridge, ')
          ..write('totalControlledDrugs: $totalControlledDrugs, ')
          ..write('nursing_home_id: $nursing_home_id, ')
          ..write('status: $status, ')
          ..write('routeId: $routeId, ')
          ..write('userId: $userId, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('param5: $param5, ')
          ..write('param6: $param6, ')
          ..write('bagSize: $bagSize, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('exemption: $exemption, ')
          ..write('isStorageFridge: $isStorageFridge, ')
          ..write('parcelBoxName: $parcelBoxName, ')
          ..write('sortBy: $sortBy, ')
          ..write('isControlledDrugs: $isControlledDrugs, ')
          ..write('deliveryNotes: $deliveryNotes, ')
          ..write('existingDeliveryNotes: $existingDeliveryNotes, ')
          ..write('rxCharge: $rxCharge, ')
          ..write('rxInvoice: $rxInvoice, ')
          ..write('subsId: $subsId, ')
          ..write('delCharge: $delCharge, ')
          ..write('serviceName: $serviceName, ')
          ..write('isCronCreated: $isCronCreated, ')
          ..write('pmr_type: $pmr_type, ')
          ..write('pr_id: $pr_id, ')
          ..write('pharmacyName: $pharmacyName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([id, orderId, deliveryStatus, pharmacyId, isDelCharge, isSubsCharge, totalStorageFridge, totalControlledDrugs, nursing_home_id, status, routeId, userId, param1, param2, param3, param4, param5, param6, bagSize, paymentStatus, exemption, isStorageFridge, parcelBoxName, sortBy, isControlledDrugs, deliveryNotes, existingDeliveryNotes, rxCharge, rxInvoice, subsId, delCharge, serviceName, isCronCreated, pmr_type, pr_id, pharmacyName]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is delivery_list &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.deliveryStatus == this.deliveryStatus &&
          other.pharmacyId == this.pharmacyId &&
          other.isDelCharge == this.isDelCharge &&
          other.isSubsCharge == this.isSubsCharge &&
          other.totalStorageFridge == this.totalStorageFridge &&
          other.totalControlledDrugs == this.totalControlledDrugs &&
          other.nursing_home_id == this.nursing_home_id &&
          other.status == this.status &&
          other.routeId == this.routeId &&
          other.userId == this.userId &&
          other.param1 == this.param1 &&
          other.param2 == this.param2 &&
          other.param3 == this.param3 &&
          other.param4 == this.param4 &&
          other.param5 == this.param5 &&
          other.param6 == this.param6 &&
          other.bagSize == this.bagSize &&
          other.paymentStatus == this.paymentStatus &&
          other.exemption == this.exemption &&
          other.isStorageFridge == this.isStorageFridge &&
          other.parcelBoxName == this.parcelBoxName &&
          other.sortBy == this.sortBy &&
          other.isControlledDrugs == this.isControlledDrugs &&
          other.deliveryNotes == this.deliveryNotes &&
          other.existingDeliveryNotes == this.existingDeliveryNotes &&
          other.rxCharge == this.rxCharge &&
          other.rxInvoice == this.rxInvoice &&
          other.subsId == this.subsId &&
          other.delCharge == this.delCharge &&
          other.serviceName == this.serviceName &&
          other.isCronCreated == this.isCronCreated &&
          other.pmr_type == this.pmr_type &&
          other.pr_id == this.pr_id &&
          other.pharmacyName == this.pharmacyName);
}

class DeliveryListCompanion extends UpdateCompanion<delivery_list> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> deliveryStatus;
  final Value<int> pharmacyId;
  final Value<int> isDelCharge;
  final Value<int> isSubsCharge;
  final Value<int> totalStorageFridge;
  final Value<int> totalControlledDrugs;
  final Value<int> nursing_home_id;
  final Value<String> status;
  final Value<String> routeId;
  final Value<String> userId;
  final Value<String> param1;
  final Value<String> param2;
  final Value<String> param3;
  final Value<String> param4;
  final Value<String> param5;
  final Value<String> param6;
  final Value<String> bagSize;
  final Value<String> paymentStatus;
  final Value<String> exemption;
  final Value<String> isStorageFridge;
  final Value<String> parcelBoxName;
  final Value<String> sortBy;
  final Value<String> isControlledDrugs;
  final Value<String> deliveryNotes;
  final Value<String> existingDeliveryNotes;
  final Value<String> rxCharge;
  final Value<int> rxInvoice;
  final Value<int> subsId;
  final Value<String> delCharge;
  final Value<String> serviceName;
  final Value<String> isCronCreated;
  final Value<String> pmr_type;
  final Value<String> pr_id;
  final Value<String> pharmacyName;

  const DeliveryListCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.deliveryStatus = const Value.absent(),
    this.pharmacyId = const Value.absent(),
    this.isDelCharge = const Value.absent(),
    this.isSubsCharge = const Value.absent(),
    this.totalStorageFridge = const Value.absent(),
    this.totalControlledDrugs = const Value.absent(),
    this.nursing_home_id = const Value.absent(),
    this.status = const Value.absent(),
    this.routeId = const Value.absent(),
    this.userId = const Value.absent(),
    this.param1 = const Value.absent(),
    this.param2 = const Value.absent(),
    this.param3 = const Value.absent(),
    this.param4 = const Value.absent(),
    this.param5 = const Value.absent(),
    this.param6 = const Value.absent(),
    this.bagSize = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.exemption = const Value.absent(),
    this.isStorageFridge = const Value.absent(),
    this.parcelBoxName = const Value.absent(),
    this.sortBy = const Value.absent(),
    this.isControlledDrugs = const Value.absent(),
    this.deliveryNotes = const Value.absent(),
    this.existingDeliveryNotes = const Value.absent(),
    this.rxCharge = const Value.absent(),
    this.rxInvoice = const Value.absent(),
    this.subsId = const Value.absent(),
    this.delCharge = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.isCronCreated = const Value.absent(),
    this.pmr_type = const Value.absent(),
    this.pr_id = const Value.absent(),
    this.pharmacyName = const Value.absent(),
  });

  DeliveryListCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int deliveryStatus,
    required int pharmacyId,
    required int isDelCharge,
    required int isSubsCharge,
    required int totalStorageFridge,
    required int totalControlledDrugs,
    required int nursing_home_id,
    required String status,
    required String routeId,
    required String userId,
    required String param1,
    required String param2,
    required String param3,
    required String param4,
    required String param5,
    required String param6,
    required String bagSize,
    required String paymentStatus,
    required String exemption,
    required String isStorageFridge,
    required String parcelBoxName,
    required String sortBy,
    required String isControlledDrugs,
    required String deliveryNotes,
    required String existingDeliveryNotes,
    required String rxCharge,
    required int rxInvoice,
    required int subsId,
    required String delCharge,
    required String serviceName,
    required String isCronCreated,
    required String pmr_type,
    required String pr_id,
    required String pharmacyName,
  })  : orderId = Value(orderId),
        deliveryStatus = Value(deliveryStatus),
        pharmacyId = Value(pharmacyId),
        isDelCharge = Value(isDelCharge),
        isSubsCharge = Value(isSubsCharge),
        totalStorageFridge = Value(totalStorageFridge),
        totalControlledDrugs = Value(totalControlledDrugs),
        nursing_home_id = Value(nursing_home_id),
        status = Value(status),
        routeId = Value(routeId),
        userId = Value(userId),
        param1 = Value(param1),
        param2 = Value(param2),
        param3 = Value(param3),
        param4 = Value(param4),
        param5 = Value(param5),
        param6 = Value(param6),
        bagSize = Value(bagSize),
        paymentStatus = Value(paymentStatus),
        exemption = Value(exemption),
        isStorageFridge = Value(isStorageFridge),
        parcelBoxName = Value(parcelBoxName),
        sortBy = Value(sortBy),
        isControlledDrugs = Value(isControlledDrugs),
        deliveryNotes = Value(deliveryNotes),
        existingDeliveryNotes = Value(existingDeliveryNotes),
        rxCharge = Value(rxCharge),
        rxInvoice = Value(rxInvoice),
        subsId = Value(subsId),
        delCharge = Value(delCharge),
        serviceName = Value(serviceName),
        isCronCreated = Value(isCronCreated),
        pmr_type = Value(pmr_type),
        pr_id = Value(pr_id),
        pharmacyName = Value(pharmacyName);

  static Insertable<delivery_list> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? deliveryStatus,
    Expression<int>? pharmacyId,
    Expression<int>? isDelCharge,
    Expression<int>? isSubsCharge,
    Expression<int>? totalStorageFridge,
    Expression<int>? totalControlledDrugs,
    Expression<int>? nursing_home_id,
    Expression<String>? status,
    Expression<String>? routeId,
    Expression<String>? userId,
    Expression<String>? param1,
    Expression<String>? param2,
    Expression<String>? param3,
    Expression<String>? param4,
    Expression<String>? param5,
    Expression<String>? param6,
    Expression<String>? bagSize,
    Expression<String>? paymentStatus,
    Expression<String>? exemption,
    Expression<String>? isStorageFridge,
    Expression<String>? parcelBoxName,
    Expression<String>? sortBy,
    Expression<String>? isControlledDrugs,
    Expression<String>? deliveryNotes,
    Expression<String>? existingDeliveryNotes,
    Expression<String>? rxCharge,
    Expression<int>? rxInvoice,
    Expression<int>? subsId,
    Expression<String>? delCharge,
    Expression<String>? serviceName,
    Expression<String>? isCronCreated,
    Expression<String>? pmr_type,
    Expression<String>? pr_id,
    Expression<String>? pharmacyName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (deliveryStatus != null) 'delivery_status': deliveryStatus,
      if (pharmacyId != null) 'pharmacy_id': pharmacyId,
      if (isDelCharge != null) 'is_del_charge': isDelCharge,
      if (isSubsCharge != null) 'is_subs_charge': isSubsCharge,
      if (totalStorageFridge != null) 'total_storage_fridge': totalStorageFridge,
      if (totalControlledDrugs != null) 'total_controlled_drugs': totalControlledDrugs,
      if (nursing_home_id != null) 'nursing_home_id': nursing_home_id,
      if (status != null) 'status': status,
      if (routeId != null) 'route_id': routeId,
      if (userId != null) 'user_id': userId,
      if (param1 != null) 'param1': param1,
      if (param2 != null) 'param2': param2,
      if (param3 != null) 'param3': param3,
      if (param4 != null) 'param4': param4,
      if (param5 != null) 'param5': param5,
      if (param6 != null) 'param6': param6,
      if (bagSize != null) 'bag_size': bagSize,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (exemption != null) 'exemption': exemption,
      if (isStorageFridge != null) 'is_storage_fridge': isStorageFridge,
      if (parcelBoxName != null) 'parcel_box_name': parcelBoxName,
      if (sortBy != null) 'sort_by': sortBy,
      if (isControlledDrugs != null) 'is_controlled_drugs': isControlledDrugs,
      if (deliveryNotes != null) 'delivery_notes': deliveryNotes,
      if (existingDeliveryNotes != null) 'existing_delivery_notes': existingDeliveryNotes,
      if (rxCharge != null) 'rx_charge': rxCharge,
      if (rxInvoice != null) 'rx_invoice': rxInvoice,
      if (subsId != null) 'subs_id': subsId,
      if (delCharge != null) 'del_charge': delCharge,
      if (serviceName != null) 'service_name': serviceName,
      if (isCronCreated != null) 'is_cron_created': isCronCreated,
      if (pmr_type != null) 'pmr_type': pmr_type,
      if (pr_id != null) 'pr_id': pr_id,
      if (pharmacyName != null) 'pharmacy_name': pharmacyName,
    });
  }

  DeliveryListCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? deliveryStatus,
      Value<int>? pharmacyId,
      Value<int>? isDelCharge,
      Value<int>? isSubsCharge,
      Value<int>? totalStorageFridge,
      Value<int>? totalControlledDrugs,
      Value<int>? nursing_home_id,
      Value<String>? status,
      Value<String>? routeId,
      Value<String>? userId,
      Value<String>? param1,
      Value<String>? param2,
      Value<String>? param3,
      Value<String>? param4,
      Value<String>? param5,
      Value<String>? param6,
      Value<String>? bagSize,
      Value<String>? paymentStatus,
      Value<String>? exemption,
      Value<String>? isStorageFridge,
      Value<String>? parcelBoxName,
      Value<String>? sortBy,
      Value<String>? isControlledDrugs,
      Value<String>? deliveryNotes,
      Value<String>? existingDeliveryNotes,
      Value<String>? rxCharge,
      Value<int>? rxInvoice,
      Value<int>? subsId,
      Value<String>? delCharge,
      Value<String>? serviceName,
      Value<String>? isCronCreated,
      Value<String>? pmr_type,
      Value<String>? pr_id,
      Value<String>? pharmacyName}) {
    return DeliveryListCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      isDelCharge: isDelCharge ?? this.isDelCharge,
      isSubsCharge: isSubsCharge ?? this.isSubsCharge,
      totalStorageFridge: totalStorageFridge ?? this.totalStorageFridge,
      totalControlledDrugs: totalControlledDrugs ?? this.totalControlledDrugs,
      nursing_home_id: nursing_home_id ?? this.nursing_home_id,
      status: status ?? this.status,
      routeId: routeId ?? this.routeId,
      userId: userId ?? this.userId,
      param1: param1 ?? this.param1,
      param2: param2 ?? this.param2,
      param3: param3 ?? this.param3,
      param4: param4 ?? this.param4,
      param5: param5 ?? this.param5,
      param6: param6 ?? this.param6,
      bagSize: bagSize ?? this.bagSize,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      exemption: exemption ?? this.exemption,
      isStorageFridge: isStorageFridge ?? this.isStorageFridge,
      parcelBoxName: parcelBoxName ?? this.parcelBoxName,
      sortBy: sortBy ?? this.sortBy,
      isControlledDrugs: isControlledDrugs ?? this.isControlledDrugs,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      existingDeliveryNotes: existingDeliveryNotes ?? this.existingDeliveryNotes,
      rxCharge: rxCharge ?? this.rxCharge,
      rxInvoice: rxInvoice ?? this.rxInvoice,
      subsId: subsId ?? this.subsId,
      delCharge: delCharge ?? this.delCharge,
      serviceName: serviceName ?? this.serviceName,
      isCronCreated: isCronCreated ?? this.isCronCreated,
      pmr_type: pmr_type ?? this.pmr_type,
      pr_id: pr_id ?? this.pr_id,
      pharmacyName: pharmacyName ?? this.pharmacyName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (deliveryStatus.present) {
      map['delivery_status'] = Variable<int>(deliveryStatus.value);
    }
    if (pharmacyId.present) {
      map['pharmacy_id'] = Variable<int>(pharmacyId.value);
    }
    if (isDelCharge.present) {
      map['is_del_charge'] = Variable<int>(isDelCharge.value);
    }
    if (isSubsCharge.present) {
      map['is_subs_charge'] = Variable<int>(isSubsCharge.value);
    }
    if (totalStorageFridge.present) {
      map['total_storage_fridge'] = Variable<int>(totalStorageFridge.value);
    }
    if (totalControlledDrugs.present) {
      map['total_controlled_drugs'] = Variable<int>(totalControlledDrugs.value);
    }
    if (nursing_home_id.present) {
      map['nursing_home_id'] = Variable<int>(nursing_home_id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (param1.present) {
      map['param1'] = Variable<String>(param1.value);
    }
    if (param2.present) {
      map['param2'] = Variable<String>(param2.value);
    }
    if (param3.present) {
      map['param3'] = Variable<String>(param3.value);
    }
    if (param4.present) {
      map['param4'] = Variable<String>(param4.value);
    }
    if (param5.present) {
      map['param5'] = Variable<String>(param5.value);
    }
    if (param6.present) {
      map['param6'] = Variable<String>(param6.value);
    }
    if (bagSize.present) {
      map['bag_size'] = Variable<String>(bagSize.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (exemption.present) {
      map['exemption'] = Variable<String>(exemption.value);
    }
    if (isStorageFridge.present) {
      map['is_storage_fridge'] = Variable<String>(isStorageFridge.value);
    }
    if (parcelBoxName.present) {
      map['parcel_box_name'] = Variable<String>(parcelBoxName.value);
    }
    if (sortBy.present) {
      map['sort_by'] = Variable<String>(sortBy.value);
    }
    if (isControlledDrugs.present) {
      map['is_controlled_drugs'] = Variable<String>(isControlledDrugs.value);
    }
    if (deliveryNotes.present) {
      map['delivery_notes'] = Variable<String>(deliveryNotes.value);
    }
    if (existingDeliveryNotes.present) {
      map['existing_delivery_notes'] = Variable<String>(existingDeliveryNotes.value);
    }
    if (rxCharge.present) {
      map['rx_charge'] = Variable<String>(rxCharge.value);
    }
    if (rxInvoice.present) {
      map['rx_invoice'] = Variable<int>(rxInvoice.value);
    }
    if (subsId.present) {
      map['subs_id'] = Variable<int>(subsId.value);
    }
    if (delCharge.present) {
      map['del_charge'] = Variable<String>(delCharge.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (isCronCreated.present) {
      map['is_cron_created'] = Variable<String>(isCronCreated.value);
    }
    if (pmr_type.present) {
      map['pmr_type'] = Variable<String>(pmr_type.value);
    }
    if (pr_id.present) {
      map['pr_id'] = Variable<String>(pr_id.value);
    }
    if (pharmacyName.present) {
      map['pharmacy_name'] = Variable<String>(pharmacyName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryListCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('deliveryStatus: $deliveryStatus, ')
          ..write('pharmacyId: $pharmacyId, ')
          ..write('isDelCharge: $isDelCharge, ')
          ..write('isSubsCharge: $isSubsCharge, ')
          ..write('totalStorageFridge: $totalStorageFridge, ')
          ..write('totalControlledDrugs: $totalControlledDrugs, ')
          ..write('nursing_home_id: $nursing_home_id, ')
          ..write('status: $status, ')
          ..write('routeId: $routeId, ')
          ..write('userId: $userId, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('param5: $param5, ')
          ..write('param6: $param6, ')
          ..write('bagSize: $bagSize, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('exemption: $exemption, ')
          ..write('isStorageFridge: $isStorageFridge, ')
          ..write('parcelBoxName: $parcelBoxName, ')
          ..write('sortBy: $sortBy, ')
          ..write('isControlledDrugs: $isControlledDrugs, ')
          ..write('deliveryNotes: $deliveryNotes, ')
          ..write('existingDeliveryNotes: $existingDeliveryNotes, ')
          ..write('rxCharge: $rxCharge, ')
          ..write('rxInvoice: $rxInvoice, ')
          ..write('subsId: $subsId, ')
          ..write('delCharge: $delCharge, ')
          ..write('serviceName: $serviceName, ')
          ..write('isCronCreated: $isCronCreated, ')
          ..write('pmr_type: $pmr_type, ')
          ..write('pr_id: $pr_id, ')
          ..write('pharmacyName: $pharmacyName')
          ..write(')'))
        .toString();
  }
}

class $DeliveryListTable extends DeliveryList with TableInfo<$DeliveryListTable, delivery_list> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $DeliveryListTable(this.attachedDatabase, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false, type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _orderIdMeta = const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int?> orderId = GeneratedColumn<int?>('order_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _deliveryStatusMeta = const VerificationMeta('deliveryStatus');
  @override
  late final GeneratedColumn<int?> deliveryStatus = GeneratedColumn<int?>('delivery_status', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _pharmacyIdMeta = const VerificationMeta('pharmacyId');
  @override
  late final GeneratedColumn<int?> pharmacyId = GeneratedColumn<int?>('pharmacy_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _isDelChargeMeta = const VerificationMeta('isDelCharge');
  @override
  late final GeneratedColumn<int?> isDelCharge = GeneratedColumn<int?>('is_del_charge', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _isSubsChargeMeta = const VerificationMeta('isSubsCharge');
  @override
  late final GeneratedColumn<int?> isSubsCharge = GeneratedColumn<int?>('is_subs_charge', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _totalStorageFridgeMeta = const VerificationMeta('totalStorageFridge');
  @override
  late final GeneratedColumn<int?> totalStorageFridge = GeneratedColumn<int?>('total_storage_fridge', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _totalControlledDrugsMeta = const VerificationMeta('totalControlledDrugs');
  @override
  late final GeneratedColumn<int?> totalControlledDrugs = GeneratedColumn<int?>('total_controlled_drugs', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nursing_home_idMeta = const VerificationMeta('nursing_home_id');
  @override
  late final GeneratedColumn<int?> nursing_home_id = GeneratedColumn<int?>('nursing_home_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String?> status = GeneratedColumn<String?>('status', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _routeIdMeta = const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<String?> routeId = GeneratedColumn<String?>('route_id', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>('user_id', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param1Meta = const VerificationMeta('param1');
  @override
  late final GeneratedColumn<String?> param1 = GeneratedColumn<String?>('param1', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param2Meta = const VerificationMeta('param2');
  @override
  late final GeneratedColumn<String?> param2 = GeneratedColumn<String?>('param2', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param3Meta = const VerificationMeta('param3');
  @override
  late final GeneratedColumn<String?> param3 = GeneratedColumn<String?>('param3', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param4Meta = const VerificationMeta('param4');
  @override
  late final GeneratedColumn<String?> param4 = GeneratedColumn<String?>('param4', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param5Meta = const VerificationMeta('param5');
  @override
  late final GeneratedColumn<String?> param5 = GeneratedColumn<String?>('param5', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param6Meta = const VerificationMeta('param6');
  @override
  late final GeneratedColumn<String?> param6 = GeneratedColumn<String?>('param6', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _bagSizeMeta = const VerificationMeta('bagSize');
  @override
  late final GeneratedColumn<String?> bagSize = GeneratedColumn<String?>('bag_size', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _paymentStatusMeta = const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String?> paymentStatus = GeneratedColumn<String?>('payment_status', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _exemptionMeta = const VerificationMeta('exemption');
  @override
  late final GeneratedColumn<String?> exemption = GeneratedColumn<String?>('exemption', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isStorageFridgeMeta = const VerificationMeta('isStorageFridge');
  @override
  late final GeneratedColumn<String?> isStorageFridge = GeneratedColumn<String?>('is_storage_fridge', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _parcelBoxNameMeta = const VerificationMeta('parcelBoxName');
  @override
  late final GeneratedColumn<String?> parcelBoxName = GeneratedColumn<String?>('parcel_box_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _sortByMeta = const VerificationMeta('sortBy');
  @override
  late final GeneratedColumn<String?> sortBy = GeneratedColumn<String?>('sort_by', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isControlledDrugsMeta = const VerificationMeta('isControlledDrugs');
  @override
  late final GeneratedColumn<String?> isControlledDrugs = GeneratedColumn<String?>('is_controlled_drugs', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _deliveryNotesMeta = const VerificationMeta('deliveryNotes');
  @override
  late final GeneratedColumn<String?> deliveryNotes = GeneratedColumn<String?>('delivery_notes', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _existingDeliveryNotesMeta = const VerificationMeta('existingDeliveryNotes');
  @override
  late final GeneratedColumn<String?> existingDeliveryNotes = GeneratedColumn<String?>('existing_delivery_notes', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _rxChargeMeta = const VerificationMeta('rxCharge');
  @override
  late final GeneratedColumn<String?> rxCharge = GeneratedColumn<String?>('rx_charge', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _rxInvoiceMeta = const VerificationMeta('rxInvoice');
  @override
  late final GeneratedColumn<int?> rxInvoice = GeneratedColumn<int?>('rx_invoice', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _subsIdMeta = const VerificationMeta('subsId');
  @override
  late final GeneratedColumn<int?> subsId = GeneratedColumn<int?>('subs_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _delChargeMeta = const VerificationMeta('delCharge');
  @override
  late final GeneratedColumn<String?> delCharge = GeneratedColumn<String?>('del_charge', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _serviceNameMeta = const VerificationMeta('serviceName');
  @override
  late final GeneratedColumn<String?> serviceName = GeneratedColumn<String?>('service_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isCronCreatedMeta = const VerificationMeta('isCronCreated');
  @override
  late final GeneratedColumn<String?> isCronCreated = GeneratedColumn<String?>('is_cron_created', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _pmr_typeMeta = const VerificationMeta('pmr_type');
  @override
  late final GeneratedColumn<String?> pmr_type = GeneratedColumn<String?>('pmr_type', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _pr_idMeta = const VerificationMeta('pr_id');
  @override
  late final GeneratedColumn<String?> pr_id = GeneratedColumn<String?>('pr_id', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _pharmacyNameMeta = const VerificationMeta('pharmacyName');
  @override
  late final GeneratedColumn<String?> pharmacyName = GeneratedColumn<String?>('pharmacy_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, orderId, deliveryStatus, pharmacyId, isDelCharge, isSubsCharge, totalStorageFridge, totalControlledDrugs, nursing_home_id, status, routeId, userId, param1, param2, param3, param4, param5, param6, bagSize, paymentStatus, exemption, isStorageFridge, parcelBoxName, sortBy, isControlledDrugs, deliveryNotes, existingDeliveryNotes, rxCharge, rxInvoice, subsId, delCharge, serviceName, isCronCreated, pmr_type, pr_id, pharmacyName];

  @override
  String get aliasedName => _alias ?? 'delivery_list';

  @override
  String get actualTableName => 'delivery_list';

  @override
  VerificationContext validateIntegrity(Insertable<delivery_list> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta, orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('delivery_status')) {
      context.handle(_deliveryStatusMeta, deliveryStatus.isAcceptableOrUnknown(data['delivery_status']!, _deliveryStatusMeta));
    } else if (isInserting) {
      context.missing(_deliveryStatusMeta);
    }
    if (data.containsKey('pharmacy_id')) {
      context.handle(_pharmacyIdMeta, pharmacyId.isAcceptableOrUnknown(data['pharmacy_id']!, _pharmacyIdMeta));
    } else if (isInserting) {
      context.missing(_pharmacyIdMeta);
    }
    if (data.containsKey('is_del_charge')) {
      context.handle(_isDelChargeMeta, isDelCharge.isAcceptableOrUnknown(data['is_del_charge']!, _isDelChargeMeta));
    } else if (isInserting) {
      context.missing(_isDelChargeMeta);
    }
    if (data.containsKey('is_subs_charge')) {
      context.handle(_isSubsChargeMeta, isSubsCharge.isAcceptableOrUnknown(data['is_subs_charge']!, _isSubsChargeMeta));
    } else if (isInserting) {
      context.missing(_isSubsChargeMeta);
    }
    if (data.containsKey('total_storage_fridge')) {
      context.handle(_totalStorageFridgeMeta, totalStorageFridge.isAcceptableOrUnknown(data['total_storage_fridge']!, _totalStorageFridgeMeta));
    } else if (isInserting) {
      context.missing(_totalStorageFridgeMeta);
    }
    if (data.containsKey('total_controlled_drugs')) {
      context.handle(_totalControlledDrugsMeta, totalControlledDrugs.isAcceptableOrUnknown(data['total_controlled_drugs']!, _totalControlledDrugsMeta));
    } else if (isInserting) {
      context.missing(_totalControlledDrugsMeta);
    }
    if (data.containsKey('nursing_home_id')) {
      context.handle(_nursing_home_idMeta, nursing_home_id.isAcceptableOrUnknown(data['nursing_home_id']!, _nursing_home_idMeta));
    } else if (isInserting) {
      context.missing(_nursing_home_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta, routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('param1')) {
      context.handle(_param1Meta, param1.isAcceptableOrUnknown(data['param1']!, _param1Meta));
    } else if (isInserting) {
      context.missing(_param1Meta);
    }
    if (data.containsKey('param2')) {
      context.handle(_param2Meta, param2.isAcceptableOrUnknown(data['param2']!, _param2Meta));
    } else if (isInserting) {
      context.missing(_param2Meta);
    }
    if (data.containsKey('param3')) {
      context.handle(_param3Meta, param3.isAcceptableOrUnknown(data['param3']!, _param3Meta));
    } else if (isInserting) {
      context.missing(_param3Meta);
    }
    if (data.containsKey('param4')) {
      context.handle(_param4Meta, param4.isAcceptableOrUnknown(data['param4']!, _param4Meta));
    } else if (isInserting) {
      context.missing(_param4Meta);
    }
    if (data.containsKey('param5')) {
      context.handle(_param5Meta, param5.isAcceptableOrUnknown(data['param5']!, _param5Meta));
    } else if (isInserting) {
      context.missing(_param5Meta);
    }
    if (data.containsKey('param6')) {
      context.handle(_param6Meta, param6.isAcceptableOrUnknown(data['param6']!, _param6Meta));
    } else if (isInserting) {
      context.missing(_param6Meta);
    }
    if (data.containsKey('bag_size')) {
      context.handle(_bagSizeMeta, bagSize.isAcceptableOrUnknown(data['bag_size']!, _bagSizeMeta));
    } else if (isInserting) {
      context.missing(_bagSizeMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(_paymentStatusMeta, paymentStatus.isAcceptableOrUnknown(data['payment_status']!, _paymentStatusMeta));
    } else if (isInserting) {
      context.missing(_paymentStatusMeta);
    }
    if (data.containsKey('exemption')) {
      context.handle(_exemptionMeta, exemption.isAcceptableOrUnknown(data['exemption']!, _exemptionMeta));
    } else if (isInserting) {
      context.missing(_exemptionMeta);
    }
    if (data.containsKey('is_storage_fridge')) {
      context.handle(_isStorageFridgeMeta, isStorageFridge.isAcceptableOrUnknown(data['is_storage_fridge']!, _isStorageFridgeMeta));
    } else if (isInserting) {
      context.missing(_isStorageFridgeMeta);
    }
    if (data.containsKey('parcel_box_name')) {
      context.handle(_parcelBoxNameMeta, parcelBoxName.isAcceptableOrUnknown(data['parcel_box_name']!, _parcelBoxNameMeta));
    } else if (isInserting) {
      context.missing(_parcelBoxNameMeta);
    }
    if (data.containsKey('sort_by')) {
      context.handle(_sortByMeta, sortBy.isAcceptableOrUnknown(data['sort_by']!, _sortByMeta));
    } else if (isInserting) {
      context.missing(_sortByMeta);
    }
    if (data.containsKey('is_controlled_drugs')) {
      context.handle(_isControlledDrugsMeta, isControlledDrugs.isAcceptableOrUnknown(data['is_controlled_drugs']!, _isControlledDrugsMeta));
    } else if (isInserting) {
      context.missing(_isControlledDrugsMeta);
    }
    if (data.containsKey('delivery_notes')) {
      context.handle(_deliveryNotesMeta, deliveryNotes.isAcceptableOrUnknown(data['delivery_notes']!, _deliveryNotesMeta));
    } else if (isInserting) {
      context.missing(_deliveryNotesMeta);
    }
    if (data.containsKey('existing_delivery_notes')) {
      context.handle(_existingDeliveryNotesMeta, existingDeliveryNotes.isAcceptableOrUnknown(data['existing_delivery_notes']!, _existingDeliveryNotesMeta));
    } else if (isInserting) {
      context.missing(_existingDeliveryNotesMeta);
    }
    if (data.containsKey('rx_charge')) {
      context.handle(_rxChargeMeta, rxCharge.isAcceptableOrUnknown(data['rx_charge']!, _rxChargeMeta));
    } else if (isInserting) {
      context.missing(_rxChargeMeta);
    }
    if (data.containsKey('rx_invoice')) {
      context.handle(_rxInvoiceMeta, rxInvoice.isAcceptableOrUnknown(data['rx_invoice']!, _rxInvoiceMeta));
    } else if (isInserting) {
      context.missing(_rxInvoiceMeta);
    }
    if (data.containsKey('subs_id')) {
      context.handle(_subsIdMeta, subsId.isAcceptableOrUnknown(data['subs_id']!, _subsIdMeta));
    } else if (isInserting) {
      context.missing(_subsIdMeta);
    }
    if (data.containsKey('del_charge')) {
      context.handle(_delChargeMeta, delCharge.isAcceptableOrUnknown(data['del_charge']!, _delChargeMeta));
    } else if (isInserting) {
      context.missing(_delChargeMeta);
    }
    if (data.containsKey('service_name')) {
      context.handle(_serviceNameMeta, serviceName.isAcceptableOrUnknown(data['service_name']!, _serviceNameMeta));
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('is_cron_created')) {
      context.handle(_isCronCreatedMeta, isCronCreated.isAcceptableOrUnknown(data['is_cron_created']!, _isCronCreatedMeta));
    } else if (isInserting) {
      context.missing(_isCronCreatedMeta);
    }
    if (data.containsKey('pmr_type')) {
      context.handle(_pmr_typeMeta, pmr_type.isAcceptableOrUnknown(data['pmr_type']!, _pmr_typeMeta));
    } else if (isInserting) {
      context.missing(_pmr_typeMeta);
    }
    if (data.containsKey('pr_id')) {
      context.handle(_pr_idMeta, pr_id.isAcceptableOrUnknown(data['pr_id']!, _pr_idMeta));
    } else if (isInserting) {
      context.missing(_pr_idMeta);
    }
    if (data.containsKey('pharmacy_name')) {
      context.handle(_pharmacyNameMeta, pharmacyName.isAcceptableOrUnknown(data['pharmacy_name']!, _pharmacyNameMeta));
    } else if (isInserting) {
      context.missing(_pharmacyNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  delivery_list map(Map<String, dynamic> data, {String? tablePrefix}) {
    return delivery_list.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DeliveryListTable createAlias(String alias) {
    return $DeliveryListTable(attachedDatabase, alias);
  }
}

class customer_details extends DataClass implements Insertable<customer_details> {
  final int id;
  final int customerId;
  final String surgeryName;
  final String service_name;
  final String firstName;
  final String param1;
  final String param2;
  final String param3;
  final String param4;
  final String middleName;
  final String lastName;
  final String mobile;
  final String title;
  final String address;
  final int order_id;

  customer_details({required this.id, required this.customerId, required this.surgeryName, required this.service_name, required this.firstName, required this.param1, required this.param2, required this.param3, required this.param4, required this.middleName, required this.lastName, required this.mobile, required this.title, required this.address, required this.order_id});

  factory customer_details.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return customer_details(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      customerId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}customer_id'])!,
      surgeryName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}surgery_name'])!,
      service_name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}service_name'])!,
      firstName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}first_name'])!,
      param1: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param1'])!,
      param2: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param2'])!,
      param3: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param3'])!,
      param4: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param4'])!,
      middleName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}middle_name'])!,
      lastName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}last_name'])!,
      mobile: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}mobile'])!,
      title: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      address: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}address'])!,
      order_id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order_id'])!,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<int>(customerId);
    map['surgery_name'] = Variable<String>(surgeryName);
    map['service_name'] = Variable<String>(service_name);
    map['first_name'] = Variable<String>(firstName);
    map['param1'] = Variable<String>(param1);
    map['param2'] = Variable<String>(param2);
    map['param3'] = Variable<String>(param3);
    map['param4'] = Variable<String>(param4);
    map['middle_name'] = Variable<String>(middleName);
    map['last_name'] = Variable<String>(lastName);
    map['mobile'] = Variable<String>(mobile);
    map['title'] = Variable<String>(title);
    map['address'] = Variable<String>(address);
    map['order_id'] = Variable<int>(order_id);
    return map;
  }

  CustomerDetailsCompanion toCompanion(bool nullToAbsent) {
    return CustomerDetailsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      surgeryName: Value(surgeryName),
      service_name: Value(service_name),
      firstName: Value(firstName),
      param1: Value(param1),
      param2: Value(param2),
      param3: Value(param3),
      param4: Value(param4),
      middleName: Value(middleName),
      lastName: Value(lastName),
      mobile: Value(mobile),
      title: Value(title),
      address: Value(address),
      order_id: Value(order_id),
    );
  }

  factory customer_details.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return customer_details(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int>(json['customerId']),
      surgeryName: serializer.fromJson<String>(json['surgeryName']),
      service_name: serializer.fromJson<String>(json['service_name']),
      firstName: serializer.fromJson<String>(json['firstName']),
      param1: serializer.fromJson<String>(json['param1']),
      param2: serializer.fromJson<String>(json['param2']),
      param3: serializer.fromJson<String>(json['param3']),
      param4: serializer.fromJson<String>(json['param4']),
      middleName: serializer.fromJson<String>(json['middleName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      mobile: serializer.fromJson<String>(json['mobile']),
      title: serializer.fromJson<String>(json['title']),
      address: serializer.fromJson<String>(json['address']),
      order_id: serializer.fromJson<int>(json['order_id']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int>(customerId),
      'surgeryName': serializer.toJson<String>(surgeryName),
      'service_name': serializer.toJson<String>(service_name),
      'firstName': serializer.toJson<String>(firstName),
      'param1': serializer.toJson<String>(param1),
      'param2': serializer.toJson<String>(param2),
      'param3': serializer.toJson<String>(param3),
      'param4': serializer.toJson<String>(param4),
      'middleName': serializer.toJson<String>(middleName),
      'lastName': serializer.toJson<String>(lastName),
      'mobile': serializer.toJson<String>(mobile),
      'title': serializer.toJson<String>(title),
      'address': serializer.toJson<String>(address),
      'order_id': serializer.toJson<int>(order_id),
    };
  }

  customer_details copyWith({int? id, int? customerId, String? surgeryName, String? service_name, String? firstName, String? param1, String? param2, String? param3, String? param4, String? middleName, String? lastName, String? mobile, String? title, String? address, int? order_id}) => customer_details(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        surgeryName: surgeryName ?? this.surgeryName,
        service_name: service_name ?? this.service_name,
        firstName: firstName ?? this.firstName,
        param1: param1 ?? this.param1,
        param2: param2 ?? this.param2,
        param3: param3 ?? this.param3,
        param4: param4 ?? this.param4,
        middleName: middleName ?? this.middleName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        title: title ?? this.title,
        address: address ?? this.address,
        order_id: order_id ?? this.order_id,
      );

  @override
  String toString() {
    return (StringBuffer('customer_details(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('surgeryName: $surgeryName, ')
          ..write('service_name: $service_name, ')
          ..write('firstName: $firstName, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('mobile: $mobile, ')
          ..write('title: $title, ')
          ..write('address: $address, ')
          ..write('order_id: $order_id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customerId, surgeryName, service_name, firstName, param1, param2, param3, param4, middleName, lastName, mobile, title, address, order_id);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is customer_details && other.id == this.id && other.customerId == this.customerId && other.surgeryName == this.surgeryName && other.service_name == this.service_name && other.firstName == this.firstName && other.param1 == this.param1 && other.param2 == this.param2 && other.param3 == this.param3 && other.param4 == this.param4 && other.middleName == this.middleName && other.lastName == this.lastName && other.mobile == this.mobile && other.title == this.title && other.address == this.address && other.order_id == this.order_id);
}

class CustomerDetailsCompanion extends UpdateCompanion<customer_details> {
  final Value<int> id;
  final Value<int> customerId;
  final Value<String> surgeryName;
  final Value<String> service_name;
  final Value<String> firstName;
  final Value<String> param1;
  final Value<String> param2;
  final Value<String> param3;
  final Value<String> param4;
  final Value<String> middleName;
  final Value<String> lastName;
  final Value<String> mobile;
  final Value<String> title;
  final Value<String> address;
  final Value<int> order_id;

  const CustomerDetailsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.surgeryName = const Value.absent(),
    this.service_name = const Value.absent(),
    this.firstName = const Value.absent(),
    this.param1 = const Value.absent(),
    this.param2 = const Value.absent(),
    this.param3 = const Value.absent(),
    this.param4 = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.mobile = const Value.absent(),
    this.title = const Value.absent(),
    this.address = const Value.absent(),
    this.order_id = const Value.absent(),
  });

  CustomerDetailsCompanion.insert({
    this.id = const Value.absent(),
    required int customerId,
    required String surgeryName,
    required String service_name,
    required String firstName,
    required String param1,
    required String param2,
    required String param3,
    required String param4,
    required String middleName,
    required String lastName,
    required String mobile,
    required String title,
    required String address,
    required int order_id,
  })  : customerId = Value(customerId),
        surgeryName = Value(surgeryName),
        service_name = Value(service_name),
        firstName = Value(firstName),
        param1 = Value(param1),
        param2 = Value(param2),
        param3 = Value(param3),
        param4 = Value(param4),
        middleName = Value(middleName),
        lastName = Value(lastName),
        mobile = Value(mobile),
        title = Value(title),
        address = Value(address),
        order_id = Value(order_id);

  static Insertable<customer_details> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<String>? surgeryName,
    Expression<String>? service_name,
    Expression<String>? firstName,
    Expression<String>? param1,
    Expression<String>? param2,
    Expression<String>? param3,
    Expression<String>? param4,
    Expression<String>? middleName,
    Expression<String>? lastName,
    Expression<String>? mobile,
    Expression<String>? title,
    Expression<String>? address,
    Expression<int>? order_id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (surgeryName != null) 'surgery_name': surgeryName,
      if (service_name != null) 'service_name': service_name,
      if (firstName != null) 'first_name': firstName,
      if (param1 != null) 'param1': param1,
      if (param2 != null) 'param2': param2,
      if (param3 != null) 'param3': param3,
      if (param4 != null) 'param4': param4,
      if (middleName != null) 'middle_name': middleName,
      if (lastName != null) 'last_name': lastName,
      if (mobile != null) 'mobile': mobile,
      if (title != null) 'title': title,
      if (address != null) 'address': address,
      if (order_id != null) 'order_id': order_id,
    });
  }

  CustomerDetailsCompanion copyWith({Value<int>? id, Value<int>? customerId, Value<String>? surgeryName, Value<String>? service_name, Value<String>? firstName, Value<String>? param1, Value<String>? param2, Value<String>? param3, Value<String>? param4, Value<String>? middleName, Value<String>? lastName, Value<String>? mobile, Value<String>? title, Value<String>? address, Value<int>? order_id}) {
    return CustomerDetailsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      surgeryName: surgeryName ?? this.surgeryName,
      service_name: service_name ?? this.service_name,
      firstName: firstName ?? this.firstName,
      param1: param1 ?? this.param1,
      param2: param2 ?? this.param2,
      param3: param3 ?? this.param3,
      param4: param4 ?? this.param4,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      title: title ?? this.title,
      address: address ?? this.address,
      order_id: order_id ?? this.order_id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (surgeryName.present) {
      map['surgery_name'] = Variable<String>(surgeryName.value);
    }
    if (service_name.present) {
      map['service_name'] = Variable<String>(service_name.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (param1.present) {
      map['param1'] = Variable<String>(param1.value);
    }
    if (param2.present) {
      map['param2'] = Variable<String>(param2.value);
    }
    if (param3.present) {
      map['param3'] = Variable<String>(param3.value);
    }
    if (param4.present) {
      map['param4'] = Variable<String>(param4.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (order_id.present) {
      map['order_id'] = Variable<int>(order_id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerDetailsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('surgeryName: $surgeryName, ')
          ..write('service_name: $service_name, ')
          ..write('firstName: $firstName, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('mobile: $mobile, ')
          ..write('title: $title, ')
          ..write('address: $address, ')
          ..write('order_id: $order_id')
          ..write(')'))
        .toString();
  }
}

class $CustomerDetailsTable extends CustomerDetails with TableInfo<$CustomerDetailsTable, customer_details> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $CustomerDetailsTable(this.attachedDatabase, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false, type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _customerIdMeta = const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int?> customerId = GeneratedColumn<int?>('customer_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _surgeryNameMeta = const VerificationMeta('surgeryName');
  @override
  late final GeneratedColumn<String?> surgeryName = GeneratedColumn<String?>('surgery_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _service_nameMeta = const VerificationMeta('service_name');
  @override
  late final GeneratedColumn<String?> service_name = GeneratedColumn<String?>('service_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _firstNameMeta = const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String?> firstName = GeneratedColumn<String?>('first_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param1Meta = const VerificationMeta('param1');
  @override
  late final GeneratedColumn<String?> param1 = GeneratedColumn<String?>('param1', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param2Meta = const VerificationMeta('param2');
  @override
  late final GeneratedColumn<String?> param2 = GeneratedColumn<String?>('param2', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param3Meta = const VerificationMeta('param3');
  @override
  late final GeneratedColumn<String?> param3 = GeneratedColumn<String?>('param3', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param4Meta = const VerificationMeta('param4');
  @override
  late final GeneratedColumn<String?> param4 = GeneratedColumn<String?>('param4', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _middleNameMeta = const VerificationMeta('middleName');
  @override
  late final GeneratedColumn<String?> middleName = GeneratedColumn<String?>('middle_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _lastNameMeta = const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String?> lastName = GeneratedColumn<String?>('last_name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String?> mobile = GeneratedColumn<String?>('mobile', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>('title', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _addressMeta = const VerificationMeta('address');
  @override
  late final GeneratedColumn<String?> address = GeneratedColumn<String?>('address', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _order_idMeta = const VerificationMeta('order_id');
  @override
  late final GeneratedColumn<int?> order_id = GeneratedColumn<int?>('order_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, customerId, surgeryName, service_name, firstName, param1, param2, param3, param4, middleName, lastName, mobile, title, address, order_id];

  @override
  String get aliasedName => _alias ?? 'customer_details';

  @override
  String get actualTableName => 'customer_details';

  @override
  VerificationContext validateIntegrity(Insertable<customer_details> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(_customerIdMeta, customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('surgery_name')) {
      context.handle(_surgeryNameMeta, surgeryName.isAcceptableOrUnknown(data['surgery_name']!, _surgeryNameMeta));
    } else if (isInserting) {
      context.missing(_surgeryNameMeta);
    }
    if (data.containsKey('service_name')) {
      context.handle(_service_nameMeta, service_name.isAcceptableOrUnknown(data['service_name']!, _service_nameMeta));
    } else if (isInserting) {
      context.missing(_service_nameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta, firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('param1')) {
      context.handle(_param1Meta, param1.isAcceptableOrUnknown(data['param1']!, _param1Meta));
    } else if (isInserting) {
      context.missing(_param1Meta);
    }
    if (data.containsKey('param2')) {
      context.handle(_param2Meta, param2.isAcceptableOrUnknown(data['param2']!, _param2Meta));
    } else if (isInserting) {
      context.missing(_param2Meta);
    }
    if (data.containsKey('param3')) {
      context.handle(_param3Meta, param3.isAcceptableOrUnknown(data['param3']!, _param3Meta));
    } else if (isInserting) {
      context.missing(_param3Meta);
    }
    if (data.containsKey('param4')) {
      context.handle(_param4Meta, param4.isAcceptableOrUnknown(data['param4']!, _param4Meta));
    } else if (isInserting) {
      context.missing(_param4Meta);
    }
    if (data.containsKey('middle_name')) {
      context.handle(_middleNameMeta, middleName.isAcceptableOrUnknown(data['middle_name']!, _middleNameMeta));
    } else if (isInserting) {
      context.missing(_middleNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta, lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta, mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta));
    } else if (isInserting) {
      context.missing(_mobileMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta, address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_order_idMeta, order_id.isAcceptableOrUnknown(data['order_id']!, _order_idMeta));
    } else if (isInserting) {
      context.missing(_order_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  customer_details map(Map<String, dynamic> data, {String? tablePrefix}) {
    return customer_details.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CustomerDetailsTable createAlias(String alias) {
    return $CustomerDetailsTable(attachedDatabase, alias);
  }
}

class customer_address extends DataClass implements Insertable<customer_address> {
  final int id;
  final String address1;
  final String alt_address;
  final String address2;
  final String postCode;
  final double latitude;
  final String param1;
  final String param2;
  final String param3;
  final String param4;
  final double longitude;
  final String duration;
  final String matchAddress;
  final int order_id;

  customer_address({required this.id, required this.address1, required this.alt_address, required this.address2, required this.postCode, required this.latitude, required this.param1, required this.param2, required this.param3, required this.param4, required this.longitude, required this.duration, required this.matchAddress, required this.order_id});

  factory customer_address.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return customer_address(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      address1: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}address1'])!,
      alt_address: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}alt_address'])!,
      address2: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}address2'])!,
      postCode: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}post_code'])!,
      latitude: const RealType().mapFromDatabaseResponse(data['${effectivePrefix}latitude'])!,
      param1: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param1'])!,
      param2: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param2'])!,
      param3: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param3'])!,
      param4: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param4'])!,
      longitude: const RealType().mapFromDatabaseResponse(data['${effectivePrefix}longitude'])!,
      duration: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}duration'])!,
      matchAddress: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}match_address'])!,
      order_id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order_id'])!,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['address1'] = Variable<String>(address1);
    map['alt_address'] = Variable<String>(alt_address);
    map['address2'] = Variable<String>(address2);
    map['post_code'] = Variable<String>(postCode);
    map['latitude'] = Variable<double>(latitude);
    map['param1'] = Variable<String>(param1);
    map['param2'] = Variable<String>(param2);
    map['param3'] = Variable<String>(param3);
    map['param4'] = Variable<String>(param4);
    map['longitude'] = Variable<double>(longitude);
    map['duration'] = Variable<String>(duration);
    map['match_address'] = Variable<String>(matchAddress);
    map['order_id'] = Variable<int>(order_id);
    return map;
  }

  CustomerAddressesCompanion toCompanion(bool nullToAbsent) {
    return CustomerAddressesCompanion(
      id: Value(id),
      address1: Value(address1),
      alt_address: Value(alt_address),
      address2: Value(address2),
      postCode: Value(postCode),
      latitude: Value(latitude),
      param1: Value(param1),
      param2: Value(param2),
      param3: Value(param3),
      param4: Value(param4),
      longitude: Value(longitude),
      duration: Value(duration),
      matchAddress: Value(matchAddress),
      order_id: Value(order_id),
    );
  }

  factory customer_address.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return customer_address(
      id: serializer.fromJson<int>(json['id']),
      address1: serializer.fromJson<String>(json['address1']),
      alt_address: serializer.fromJson<String>(json['alt_address']),
      address2: serializer.fromJson<String>(json['address2']),
      postCode: serializer.fromJson<String>(json['postCode']),
      latitude: serializer.fromJson<double>(json['latitude']),
      param1: serializer.fromJson<String>(json['param1']),
      param2: serializer.fromJson<String>(json['param2']),
      param3: serializer.fromJson<String>(json['param3']),
      param4: serializer.fromJson<String>(json['param4']),
      longitude: serializer.fromJson<double>(json['longitude']),
      duration: serializer.fromJson<String>(json['duration']),
      matchAddress: serializer.fromJson<String>(json['matchAddress']),
      order_id: serializer.fromJson<int>(json['order_id']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'address1': serializer.toJson<String>(address1),
      'alt_address': serializer.toJson<String>(alt_address),
      'address2': serializer.toJson<String>(address2),
      'postCode': serializer.toJson<String>(postCode),
      'latitude': serializer.toJson<double>(latitude),
      'param1': serializer.toJson<String>(param1),
      'param2': serializer.toJson<String>(param2),
      'param3': serializer.toJson<String>(param3),
      'param4': serializer.toJson<String>(param4),
      'longitude': serializer.toJson<double>(longitude),
      'duration': serializer.toJson<String>(duration),
      'matchAddress': serializer.toJson<String>(matchAddress),
      'order_id': serializer.toJson<int>(order_id),
    };
  }

  customer_address copyWith({int? id, String? address1, String? alt_address, String? address2, String? postCode, double? latitude, String? param1, String? param2, String? param3, String? param4, double? longitude, String? duration, String? matchAddress, int? order_id}) => customer_address(
        id: id ?? this.id,
        address1: address1 ?? this.address1,
        alt_address: alt_address ?? this.alt_address,
        address2: address2 ?? this.address2,
        postCode: postCode ?? this.postCode,
        latitude: latitude ?? this.latitude,
        param1: param1 ?? this.param1,
        param2: param2 ?? this.param2,
        param3: param3 ?? this.param3,
        param4: param4 ?? this.param4,
        longitude: longitude ?? this.longitude,
        duration: duration ?? this.duration,
        matchAddress: matchAddress ?? this.matchAddress,
        order_id: order_id ?? this.order_id,
      );

  @override
  String toString() {
    return (StringBuffer('customer_address(')
          ..write('id: $id, ')
          ..write('address1: $address1, ')
          ..write('alt_address: $alt_address, ')
          ..write('address2: $address2, ')
          ..write('postCode: $postCode, ')
          ..write('latitude: $latitude, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('longitude: $longitude, ')
          ..write('duration: $duration, ')
          ..write('matchAddress: $matchAddress, ')
          ..write('order_id: $order_id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, address1, alt_address, address2, postCode, latitude, param1, param2, param3, param4, longitude, duration, matchAddress, order_id);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is customer_address && other.id == this.id && other.address1 == this.address1 && other.alt_address == this.alt_address && other.address2 == this.address2 && other.postCode == this.postCode && other.latitude == this.latitude && other.param1 == this.param1 && other.param2 == this.param2 && other.param3 == this.param3 && other.param4 == this.param4 && other.longitude == this.longitude && other.duration == this.duration && other.matchAddress == this.matchAddress && other.order_id == this.order_id);
}

class CustomerAddressesCompanion extends UpdateCompanion<customer_address> {
  final Value<int> id;
  final Value<String> address1;
  final Value<String> alt_address;
  final Value<String> address2;
  final Value<String> postCode;
  final Value<double> latitude;
  final Value<String> param1;
  final Value<String> param2;
  final Value<String> param3;
  final Value<String> param4;
  final Value<double> longitude;
  final Value<String> duration;
  final Value<String> matchAddress;
  final Value<int> order_id;

  const CustomerAddressesCompanion({
    this.id = const Value.absent(),
    this.address1 = const Value.absent(),
    this.alt_address = const Value.absent(),
    this.address2 = const Value.absent(),
    this.postCode = const Value.absent(),
    this.latitude = const Value.absent(),
    this.param1 = const Value.absent(),
    this.param2 = const Value.absent(),
    this.param3 = const Value.absent(),
    this.param4 = const Value.absent(),
    this.longitude = const Value.absent(),
    this.duration = const Value.absent(),
    this.matchAddress = const Value.absent(),
    this.order_id = const Value.absent(),
  });

  CustomerAddressesCompanion.insert({
    this.id = const Value.absent(),
    required String address1,
    required String alt_address,
    required String address2,
    required String postCode,
    required double latitude,
    required String param1,
    required String param2,
    required String param3,
    required String param4,
    required double longitude,
    required String duration,
    required String matchAddress,
    required int order_id,
  })  : address1 = Value(address1),
        alt_address = Value(alt_address),
        address2 = Value(address2),
        postCode = Value(postCode),
        latitude = Value(latitude),
        param1 = Value(param1),
        param2 = Value(param2),
        param3 = Value(param3),
        param4 = Value(param4),
        longitude = Value(longitude),
        duration = Value(duration),
        matchAddress = Value(matchAddress),
        order_id = Value(order_id);

  static Insertable<customer_address> custom({
    Expression<int>? id,
    Expression<String>? address1,
    Expression<String>? alt_address,
    Expression<String>? address2,
    Expression<String>? postCode,
    Expression<double>? latitude,
    Expression<String>? param1,
    Expression<String>? param2,
    Expression<String>? param3,
    Expression<String>? param4,
    Expression<double>? longitude,
    Expression<String>? duration,
    Expression<String>? matchAddress,
    Expression<int>? order_id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address1 != null) 'address1': address1,
      if (alt_address != null) 'alt_address': alt_address,
      if (address2 != null) 'address2': address2,
      if (postCode != null) 'post_code': postCode,
      if (latitude != null) 'latitude': latitude,
      if (param1 != null) 'param1': param1,
      if (param2 != null) 'param2': param2,
      if (param3 != null) 'param3': param3,
      if (param4 != null) 'param4': param4,
      if (longitude != null) 'longitude': longitude,
      if (duration != null) 'duration': duration,
      if (matchAddress != null) 'match_address': matchAddress,
      if (order_id != null) 'order_id': order_id,
    });
  }

  CustomerAddressesCompanion copyWith({Value<int>? id, Value<String>? address1, Value<String>? alt_address, Value<String>? address2, Value<String>? postCode, Value<double>? latitude, Value<String>? param1, Value<String>? param2, Value<String>? param3, Value<String>? param4, Value<double>? longitude, Value<String>? duration, Value<String>? matchAddress, Value<int>? order_id}) {
    return CustomerAddressesCompanion(
      id: id ?? this.id,
      address1: address1 ?? this.address1,
      alt_address: alt_address ?? this.alt_address,
      address2: address2 ?? this.address2,
      postCode: postCode ?? this.postCode,
      latitude: latitude ?? this.latitude,
      param1: param1 ?? this.param1,
      param2: param2 ?? this.param2,
      param3: param3 ?? this.param3,
      param4: param4 ?? this.param4,
      longitude: longitude ?? this.longitude,
      duration: duration ?? this.duration,
      matchAddress: matchAddress ?? this.matchAddress,
      order_id: order_id ?? this.order_id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (address1.present) {
      map['address1'] = Variable<String>(address1.value);
    }
    if (alt_address.present) {
      map['alt_address'] = Variable<String>(alt_address.value);
    }
    if (address2.present) {
      map['address2'] = Variable<String>(address2.value);
    }
    if (postCode.present) {
      map['post_code'] = Variable<String>(postCode.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (param1.present) {
      map['param1'] = Variable<String>(param1.value);
    }
    if (param2.present) {
      map['param2'] = Variable<String>(param2.value);
    }
    if (param3.present) {
      map['param3'] = Variable<String>(param3.value);
    }
    if (param4.present) {
      map['param4'] = Variable<String>(param4.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (matchAddress.present) {
      map['match_address'] = Variable<String>(matchAddress.value);
    }
    if (order_id.present) {
      map['order_id'] = Variable<int>(order_id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerAddressesCompanion(')
          ..write('id: $id, ')
          ..write('address1: $address1, ')
          ..write('alt_address: $alt_address, ')
          ..write('address2: $address2, ')
          ..write('postCode: $postCode, ')
          ..write('latitude: $latitude, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('longitude: $longitude, ')
          ..write('duration: $duration, ')
          ..write('matchAddress: $matchAddress, ')
          ..write('order_id: $order_id')
          ..write(')'))
        .toString();
  }
}

class $CustomerAddressesTable extends CustomerAddresses with TableInfo<$CustomerAddressesTable, customer_address> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $CustomerAddressesTable(this.attachedDatabase, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false, type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _address1Meta = const VerificationMeta('address1');
  @override
  late final GeneratedColumn<String?> address1 = GeneratedColumn<String?>('address1', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _alt_addressMeta = const VerificationMeta('alt_address');
  @override
  late final GeneratedColumn<String?> alt_address = GeneratedColumn<String?>('alt_address', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _address2Meta = const VerificationMeta('address2');
  @override
  late final GeneratedColumn<String?> address2 = GeneratedColumn<String?>('address2', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _postCodeMeta = const VerificationMeta('postCode');
  @override
  late final GeneratedColumn<String?> postCode = GeneratedColumn<String?>('post_code', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double?> latitude = GeneratedColumn<double?>('latitude', aliasedName, false, type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _param1Meta = const VerificationMeta('param1');
  @override
  late final GeneratedColumn<String?> param1 = GeneratedColumn<String?>('param1', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param2Meta = const VerificationMeta('param2');
  @override
  late final GeneratedColumn<String?> param2 = GeneratedColumn<String?>('param2', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param3Meta = const VerificationMeta('param3');
  @override
  late final GeneratedColumn<String?> param3 = GeneratedColumn<String?>('param3', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param4Meta = const VerificationMeta('param4');
  @override
  late final GeneratedColumn<String?> param4 = GeneratedColumn<String?>('param4', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double?> longitude = GeneratedColumn<double?>('longitude', aliasedName, false, type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _durationMeta = const VerificationMeta('duration');
  @override
  late final GeneratedColumn<String?> duration = GeneratedColumn<String?>('duration', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _matchAddressMeta = const VerificationMeta('matchAddress');
  @override
  late final GeneratedColumn<String?> matchAddress = GeneratedColumn<String?>('match_address', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _order_idMeta = const VerificationMeta('order_id');
  @override
  late final GeneratedColumn<int?> order_id = GeneratedColumn<int?>('order_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, address1, alt_address, address2, postCode, latitude, param1, param2, param3, param4, longitude, duration, matchAddress, order_id];

  @override
  String get aliasedName => _alias ?? 'customer_addresses';

  @override
  String get actualTableName => 'customer_addresses';

  @override
  VerificationContext validateIntegrity(Insertable<customer_address> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('address1')) {
      context.handle(_address1Meta, address1.isAcceptableOrUnknown(data['address1']!, _address1Meta));
    } else if (isInserting) {
      context.missing(_address1Meta);
    }
    if (data.containsKey('alt_address')) {
      context.handle(_alt_addressMeta, alt_address.isAcceptableOrUnknown(data['alt_address']!, _alt_addressMeta));
    } else if (isInserting) {
      context.missing(_alt_addressMeta);
    }
    if (data.containsKey('address2')) {
      context.handle(_address2Meta, address2.isAcceptableOrUnknown(data['address2']!, _address2Meta));
    } else if (isInserting) {
      context.missing(_address2Meta);
    }
    if (data.containsKey('post_code')) {
      context.handle(_postCodeMeta, postCode.isAcceptableOrUnknown(data['post_code']!, _postCodeMeta));
    } else if (isInserting) {
      context.missing(_postCodeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta, latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('param1')) {
      context.handle(_param1Meta, param1.isAcceptableOrUnknown(data['param1']!, _param1Meta));
    } else if (isInserting) {
      context.missing(_param1Meta);
    }
    if (data.containsKey('param2')) {
      context.handle(_param2Meta, param2.isAcceptableOrUnknown(data['param2']!, _param2Meta));
    } else if (isInserting) {
      context.missing(_param2Meta);
    }
    if (data.containsKey('param3')) {
      context.handle(_param3Meta, param3.isAcceptableOrUnknown(data['param3']!, _param3Meta));
    } else if (isInserting) {
      context.missing(_param3Meta);
    }
    if (data.containsKey('param4')) {
      context.handle(_param4Meta, param4.isAcceptableOrUnknown(data['param4']!, _param4Meta));
    } else if (isInserting) {
      context.missing(_param4Meta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta, longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta, duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('match_address')) {
      context.handle(_matchAddressMeta, matchAddress.isAcceptableOrUnknown(data['match_address']!, _matchAddressMeta));
    } else if (isInserting) {
      context.missing(_matchAddressMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_order_idMeta, order_id.isAcceptableOrUnknown(data['order_id']!, _order_idMeta));
    } else if (isInserting) {
      context.missing(_order_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  customer_address map(Map<String, dynamic> data, {String? tablePrefix}) {
    return customer_address.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CustomerAddressesTable createAlias(String alias) {
    return $CustomerAddressesTable(attachedDatabase, alias);
  }
}

class order_complete_data extends DataClass implements Insertable<order_complete_data> {
  final int id;
  final String remarks;
  final int userId;
  final String deliveredTo;
  final String addDelCharge;
  final String notPaidReason;
  final int subsId;
  final String rxInvoice;
  final String rxCharge;
  final String paymentMethode;
  final String deliveryId;
  final String routeId;
  final String customerRemarks;
  final String baseSignature;
  final String baseImage;
  final String date_Time;
  final int deliveryStatus;
  final int exemptionId;
  final String questionAnswerModels;
  final String paymentStatus;
  final String reschudleDate;
  final String param1;
  final String param2;
  final String param3;
  final String param4;
  final String param5;
  final String param6;
  final String param7;
  final String param8;
  final String param10;
  final String param9;
  final double latitude;
  final double longitude;

  order_complete_data(
      {required this.id,
      required this.remarks,
      required this.userId,
      required this.deliveredTo,
      required this.addDelCharge,
      required this.notPaidReason,
      required this.subsId,
      required this.rxInvoice,
      required this.rxCharge,
      required this.paymentMethode,
      required this.deliveryId,
      required this.routeId,
      required this.customerRemarks,
      required this.baseSignature,
      required this.baseImage,
      required this.date_Time,
      required this.deliveryStatus,
      required this.exemptionId,
      required this.questionAnswerModels,
      required this.paymentStatus,
      required this.reschudleDate,
      required this.param1,
      required this.param2,
      required this.param3,
      required this.param4,
      required this.param5,
      required this.param6,
      required this.param7,
      required this.param8,
      required this.param10,
      required this.param9,
      required this.latitude,
      required this.longitude});

  factory order_complete_data.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return order_complete_data(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      remarks: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}remarks'])!,
      userId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      deliveredTo: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}delivered_to'])!,
      addDelCharge: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}add_del_charge'])!,
      notPaidReason: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}not_paid_reason'])!,
      subsId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}subs_id'])!,
      rxInvoice: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}rx_invoice'])!,
      rxCharge: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}rx_charge'])!,
      paymentMethode: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}payment_methode'])!,
      deliveryId: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}delivery_id'])!,
      routeId: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}route_id'])!,
      customerRemarks: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}customer_remarks'])!,
      baseSignature: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}base_signature'])!,
      baseImage: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}base_image'])!,
      date_Time: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}date_time'])!,
      deliveryStatus: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}delivery_status'])!,
      exemptionId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}exemption_id'])!,
      questionAnswerModels: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}question_answer_models'])!,
      paymentStatus: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}payment_status'])!,
      reschudleDate: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}reschudle_date'])!,
      param1: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param1'])!,
      param2: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param2'])!,
      param3: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param3'])!,
      param4: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param4'])!,
      param5: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param5'])!,
      param6: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param6'])!,
      param7: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param7'])!,
      param8: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param8'])!,
      param10: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param10'])!,
      param9: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}param9'])!,
      latitude: const RealType().mapFromDatabaseResponse(data['${effectivePrefix}latitude'])!,
      longitude: const RealType().mapFromDatabaseResponse(data['${effectivePrefix}longitude'])!,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remarks'] = Variable<String>(remarks);
    map['user_id'] = Variable<int>(userId);
    map['delivered_to'] = Variable<String>(deliveredTo);
    map['add_del_charge'] = Variable<String>(addDelCharge);
    map['not_paid_reason'] = Variable<String>(notPaidReason);
    map['subs_id'] = Variable<int>(subsId);
    map['rx_invoice'] = Variable<String>(rxInvoice);
    map['rx_charge'] = Variable<String>(rxCharge);
    map['payment_methode'] = Variable<String>(paymentMethode);
    map['delivery_id'] = Variable<String>(deliveryId);
    map['route_id'] = Variable<String>(routeId);
    map['customer_remarks'] = Variable<String>(customerRemarks);
    map['base_signature'] = Variable<String>(baseSignature);
    map['base_image'] = Variable<String>(baseImage);
    map['date_time'] = Variable<String>(date_Time);
    map['delivery_status'] = Variable<int>(deliveryStatus);
    map['exemption_id'] = Variable<int>(exemptionId);
    map['question_answer_models'] = Variable<String>(questionAnswerModels);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['reschudle_date'] = Variable<String>(reschudleDate);
    map['param1'] = Variable<String>(param1);
    map['param2'] = Variable<String>(param2);
    map['param3'] = Variable<String>(param3);
    map['param4'] = Variable<String>(param4);
    map['param5'] = Variable<String>(param5);
    map['param6'] = Variable<String>(param6);
    map['param7'] = Variable<String>(param7);
    map['param8'] = Variable<String>(param8);
    map['param10'] = Variable<String>(param10);
    map['param9'] = Variable<String>(param9);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    return map;
  }

  OrderCompleteDataCompanion toCompanion(bool nullToAbsent) {
    return OrderCompleteDataCompanion(
      id: Value(id),
      remarks: Value(remarks),
      userId: Value(userId),
      deliveredTo: Value(deliveredTo),
      addDelCharge: Value(addDelCharge),
      notPaidReason: Value(notPaidReason),
      subsId: Value(subsId),
      rxInvoice: Value(rxInvoice),
      rxCharge: Value(rxCharge),
      paymentMethode: Value(paymentMethode),
      deliveryId: Value(deliveryId),
      routeId: Value(routeId),
      customerRemarks: Value(customerRemarks),
      baseSignature: Value(baseSignature),
      baseImage: Value(baseImage),
      date_Time: Value(date_Time),
      deliveryStatus: Value(deliveryStatus),
      exemptionId: Value(exemptionId),
      questionAnswerModels: Value(questionAnswerModels),
      paymentStatus: Value(paymentStatus),
      reschudleDate: Value(reschudleDate),
      param1: Value(param1),
      param2: Value(param2),
      param3: Value(param3),
      param4: Value(param4),
      param5: Value(param5),
      param6: Value(param6),
      param7: Value(param7),
      param8: Value(param8),
      param10: Value(param10),
      param9: Value(param9),
      latitude: Value(latitude),
      longitude: Value(longitude),
    );
  }

  factory order_complete_data.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return order_complete_data(
      id: serializer.fromJson<int>(json['id']),
      remarks: serializer.fromJson<String>(json['remarks']),
      userId: serializer.fromJson<int>(json['userId']),
      deliveredTo: serializer.fromJson<String>(json['deliveredTo']),
      addDelCharge: serializer.fromJson<String>(json['addDelCharge']),
      notPaidReason: serializer.fromJson<String>(json['notPaidReason']),
      subsId: serializer.fromJson<int>(json['subsId']),
      rxInvoice: serializer.fromJson<String>(json['rxInvoice']),
      rxCharge: serializer.fromJson<String>(json['rxCharge']),
      paymentMethode: serializer.fromJson<String>(json['paymentMethode']),
      deliveryId: serializer.fromJson<String>(json['deliveryId']),
      routeId: serializer.fromJson<String>(json['routeId']),
      customerRemarks: serializer.fromJson<String>(json['customerRemarks']),
      baseSignature: serializer.fromJson<String>(json['baseSignature']),
      baseImage: serializer.fromJson<String>(json['baseImage']),
      date_Time: serializer.fromJson<String>(json['date_Time']),
      deliveryStatus: serializer.fromJson<int>(json['deliveryStatus']),
      exemptionId: serializer.fromJson<int>(json['exemptionId']),
      questionAnswerModels: serializer.fromJson<String>(json['questionAnswerModels']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      reschudleDate: serializer.fromJson<String>(json['reschudleDate']),
      param1: serializer.fromJson<String>(json['param1']),
      param2: serializer.fromJson<String>(json['param2']),
      param3: serializer.fromJson<String>(json['param3']),
      param4: serializer.fromJson<String>(json['param4']),
      param5: serializer.fromJson<String>(json['param5']),
      param6: serializer.fromJson<String>(json['param6']),
      param7: serializer.fromJson<String>(json['param7']),
      param8: serializer.fromJson<String>(json['param8']),
      param10: serializer.fromJson<String>(json['param10']),
      param9: serializer.fromJson<String>(json['param9']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remarks': serializer.toJson<String>(remarks),
      'userId': serializer.toJson<int>(userId),
      'deliveredTo': serializer.toJson<String>(deliveredTo),
      'addDelCharge': serializer.toJson<String>(addDelCharge),
      'notPaidReason': serializer.toJson<String>(notPaidReason),
      'subsId': serializer.toJson<int>(subsId),
      'rxInvoice': serializer.toJson<String>(rxInvoice),
      'rxCharge': serializer.toJson<String>(rxCharge),
      'paymentMethode': serializer.toJson<String>(paymentMethode),
      'deliveryId': serializer.toJson<String>(deliveryId),
      'routeId': serializer.toJson<String>(routeId),
      'customerRemarks': serializer.toJson<String>(customerRemarks),
      'baseSignature': serializer.toJson<String>(baseSignature),
      'baseImage': serializer.toJson<String>(baseImage),
      'date_Time': serializer.toJson<String>(date_Time),
      'deliveryStatus': serializer.toJson<int>(deliveryStatus),
      'exemptionId': serializer.toJson<int>(exemptionId),
      'questionAnswerModels': serializer.toJson<String>(questionAnswerModels),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'reschudleDate': serializer.toJson<String>(reschudleDate),
      'param1': serializer.toJson<String>(param1),
      'param2': serializer.toJson<String>(param2),
      'param3': serializer.toJson<String>(param3),
      'param4': serializer.toJson<String>(param4),
      'param5': serializer.toJson<String>(param5),
      'param6': serializer.toJson<String>(param6),
      'param7': serializer.toJson<String>(param7),
      'param8': serializer.toJson<String>(param8),
      'param10': serializer.toJson<String>(param10),
      'param9': serializer.toJson<String>(param9),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  order_complete_data copyWith({int? id, String? remarks, int? userId, String? deliveredTo, String? addDelCharge, String? notPaidReason, int? subsId, String? rxInvoice, String? rxCharge, String? paymentMethode, String? deliveryId, String? routeId, String? customerRemarks, String? baseSignature, String? baseImage, String? date_Time, int? deliveryStatus, int? exemptionId, String? questionAnswerModels, String? paymentStatus, String? reschudleDate, String? param1, String? param2, String? param3, String? param4, String? param5, String? param6, String? param7, String? param8, String? param10, String? param9, double? latitude, double? longitude}) => order_complete_data(
        id: id ?? this.id,
        remarks: remarks ?? this.remarks,
        userId: userId ?? this.userId,
        deliveredTo: deliveredTo ?? this.deliveredTo,
        addDelCharge: addDelCharge ?? this.addDelCharge,
        notPaidReason: notPaidReason ?? this.notPaidReason,
        subsId: subsId ?? this.subsId,
        rxInvoice: rxInvoice ?? this.rxInvoice,
        rxCharge: rxCharge ?? this.rxCharge,
        paymentMethode: paymentMethode ?? this.paymentMethode,
        deliveryId: deliveryId ?? this.deliveryId,
        routeId: routeId ?? this.routeId,
        customerRemarks: customerRemarks ?? this.customerRemarks,
        baseSignature: baseSignature ?? this.baseSignature,
        baseImage: baseImage ?? this.baseImage,
        date_Time: date_Time ?? this.date_Time,
        deliveryStatus: deliveryStatus ?? this.deliveryStatus,
        exemptionId: exemptionId ?? this.exemptionId,
        questionAnswerModels: questionAnswerModels ?? this.questionAnswerModels,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        reschudleDate: reschudleDate ?? this.reschudleDate,
        param1: param1 ?? this.param1,
        param2: param2 ?? this.param2,
        param3: param3 ?? this.param3,
        param4: param4 ?? this.param4,
        param5: param5 ?? this.param5,
        param6: param6 ?? this.param6,
        param7: param7 ?? this.param7,
        param8: param8 ?? this.param8,
        param10: param10 ?? this.param10,
        param9: param9 ?? this.param9,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  @override
  String toString() {
    return (StringBuffer('order_complete_data(')
          ..write('id: $id, ')
          ..write('remarks: $remarks, ')
          ..write('userId: $userId, ')
          ..write('deliveredTo: $deliveredTo, ')
          ..write('addDelCharge: $addDelCharge, ')
          ..write('notPaidReason: $notPaidReason, ')
          ..write('subsId: $subsId, ')
          ..write('rxInvoice: $rxInvoice, ')
          ..write('rxCharge: $rxCharge, ')
          ..write('paymentMethode: $paymentMethode, ')
          ..write('deliveryId: $deliveryId, ')
          ..write('routeId: $routeId, ')
          ..write('customerRemarks: $customerRemarks, ')
          ..write('baseSignature: $baseSignature, ')
          ..write('baseImage: $baseImage, ')
          ..write('date_Time: $date_Time, ')
          ..write('deliveryStatus: $deliveryStatus, ')
          ..write('exemptionId: $exemptionId, ')
          ..write('questionAnswerModels: $questionAnswerModels, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('reschudleDate: $reschudleDate, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('param5: $param5, ')
          ..write('param6: $param6, ')
          ..write('param7: $param7, ')
          ..write('param8: $param8, ')
          ..write('param10: $param10, ')
          ..write('param9: $param9, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([id, remarks, userId, deliveredTo, addDelCharge, notPaidReason, subsId, rxInvoice, rxCharge, paymentMethode, deliveryId, routeId, customerRemarks, baseSignature, baseImage, date_Time, deliveryStatus, exemptionId, questionAnswerModels, paymentStatus, reschudleDate, param1, param2, param3, param4, param5, param6, param7, param8, param10, param9, latitude, longitude]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is order_complete_data &&
          other.id == this.id &&
          other.remarks == this.remarks &&
          other.userId == this.userId &&
          other.deliveredTo == this.deliveredTo &&
          other.addDelCharge == this.addDelCharge &&
          other.notPaidReason == this.notPaidReason &&
          other.subsId == this.subsId &&
          other.rxInvoice == this.rxInvoice &&
          other.rxCharge == this.rxCharge &&
          other.paymentMethode == this.paymentMethode &&
          other.deliveryId == this.deliveryId &&
          other.routeId == this.routeId &&
          other.customerRemarks == this.customerRemarks &&
          other.baseSignature == this.baseSignature &&
          other.baseImage == this.baseImage &&
          other.date_Time == this.date_Time &&
          other.deliveryStatus == this.deliveryStatus &&
          other.exemptionId == this.exemptionId &&
          other.questionAnswerModels == this.questionAnswerModels &&
          other.paymentStatus == this.paymentStatus &&
          other.reschudleDate == this.reschudleDate &&
          other.param1 == this.param1 &&
          other.param2 == this.param2 &&
          other.param3 == this.param3 &&
          other.param4 == this.param4 &&
          other.param5 == this.param5 &&
          other.param6 == this.param6 &&
          other.param7 == this.param7 &&
          other.param8 == this.param8 &&
          other.param10 == this.param10 &&
          other.param9 == this.param9 &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class OrderCompleteDataCompanion extends UpdateCompanion<order_complete_data> {
  final Value<int> id;
  final Value<String> remarks;
  final Value<int> userId;
  final Value<String> deliveredTo;
  final Value<String> addDelCharge;
  final Value<String> notPaidReason;
  final Value<int> subsId;
  final Value<String> rxInvoice;
  final Value<String> rxCharge;
  final Value<String> paymentMethode;
  final Value<String> deliveryId;
  final Value<String> routeId;
  final Value<String> customerRemarks;
  final Value<String> baseSignature;
  final Value<String> baseImage;
  final Value<String> date_Time;
  final Value<int> deliveryStatus;
  final Value<int> exemptionId;
  final Value<String> questionAnswerModels;
  final Value<String> paymentStatus;
  final Value<String> reschudleDate;
  final Value<String> param1;
  final Value<String> param2;
  final Value<String> param3;
  final Value<String> param4;
  final Value<String> param5;
  final Value<String> param6;
  final Value<String> param7;
  final Value<String> param8;
  final Value<String> param10;
  final Value<String> param9;
  final Value<double> latitude;
  final Value<double> longitude;

  const OrderCompleteDataCompanion({
    this.id = const Value.absent(),
    this.remarks = const Value.absent(),
    this.userId = const Value.absent(),
    this.deliveredTo = const Value.absent(),
    this.addDelCharge = const Value.absent(),
    this.notPaidReason = const Value.absent(),
    this.subsId = const Value.absent(),
    this.rxInvoice = const Value.absent(),
    this.rxCharge = const Value.absent(),
    this.paymentMethode = const Value.absent(),
    this.deliveryId = const Value.absent(),
    this.routeId = const Value.absent(),
    this.customerRemarks = const Value.absent(),
    this.baseSignature = const Value.absent(),
    this.baseImage = const Value.absent(),
    this.date_Time = const Value.absent(),
    this.deliveryStatus = const Value.absent(),
    this.exemptionId = const Value.absent(),
    this.questionAnswerModels = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.reschudleDate = const Value.absent(),
    this.param1 = const Value.absent(),
    this.param2 = const Value.absent(),
    this.param3 = const Value.absent(),
    this.param4 = const Value.absent(),
    this.param5 = const Value.absent(),
    this.param6 = const Value.absent(),
    this.param7 = const Value.absent(),
    this.param8 = const Value.absent(),
    this.param10 = const Value.absent(),
    this.param9 = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });

  OrderCompleteDataCompanion.insert({
    this.id = const Value.absent(),
    required String remarks,
    required int userId,
    required String deliveredTo,
    required String addDelCharge,
    required String notPaidReason,
    required int subsId,
    required String rxInvoice,
    required String rxCharge,
    required String paymentMethode,
    required String deliveryId,
    required String routeId,
    required String customerRemarks,
    required String baseSignature,
    required String baseImage,
    required String date_Time,
    required int deliveryStatus,
    required int exemptionId,
    required String questionAnswerModels,
    required String paymentStatus,
    required String reschudleDate,
    required String param1,
    required String param2,
    required String param3,
    required String param4,
    required String param5,
    required String param6,
    required String param7,
    required String param8,
    required String param10,
    required String param9,
    required double latitude,
    required double longitude,
  })  : remarks = Value(remarks),
        userId = Value(userId),
        deliveredTo = Value(deliveredTo),
        addDelCharge = Value(addDelCharge),
        notPaidReason = Value(notPaidReason),
        subsId = Value(subsId),
        rxInvoice = Value(rxInvoice),
        rxCharge = Value(rxCharge),
        paymentMethode = Value(paymentMethode),
        deliveryId = Value(deliveryId),
        routeId = Value(routeId),
        customerRemarks = Value(customerRemarks),
        baseSignature = Value(baseSignature),
        baseImage = Value(baseImage),
        date_Time = Value(date_Time),
        deliveryStatus = Value(deliveryStatus),
        exemptionId = Value(exemptionId),
        questionAnswerModels = Value(questionAnswerModels),
        paymentStatus = Value(paymentStatus),
        reschudleDate = Value(reschudleDate),
        param1 = Value(param1),
        param2 = Value(param2),
        param3 = Value(param3),
        param4 = Value(param4),
        param5 = Value(param5),
        param6 = Value(param6),
        param7 = Value(param7),
        param8 = Value(param8),
        param10 = Value(param10),
        param9 = Value(param9),
        latitude = Value(latitude),
        longitude = Value(longitude);

  static Insertable<order_complete_data> custom({
    Expression<int>? id,
    Expression<String>? remarks,
    Expression<int>? userId,
    Expression<String>? deliveredTo,
    Expression<String>? addDelCharge,
    Expression<String>? notPaidReason,
    Expression<int>? subsId,
    Expression<String>? rxInvoice,
    Expression<String>? rxCharge,
    Expression<String>? paymentMethode,
    Expression<String>? deliveryId,
    Expression<String>? routeId,
    Expression<String>? customerRemarks,
    Expression<String>? baseSignature,
    Expression<String>? baseImage,
    Expression<String>? date_Time,
    Expression<int>? deliveryStatus,
    Expression<int>? exemptionId,
    Expression<String>? questionAnswerModels,
    Expression<String>? paymentStatus,
    Expression<String>? reschudleDate,
    Expression<String>? param1,
    Expression<String>? param2,
    Expression<String>? param3,
    Expression<String>? param4,
    Expression<String>? param5,
    Expression<String>? param6,
    Expression<String>? param7,
    Expression<String>? param8,
    Expression<String>? param10,
    Expression<String>? param9,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remarks != null) 'remarks': remarks,
      if (userId != null) 'user_id': userId,
      if (deliveredTo != null) 'delivered_to': deliveredTo,
      if (addDelCharge != null) 'add_del_charge': addDelCharge,
      if (notPaidReason != null) 'not_paid_reason': notPaidReason,
      if (subsId != null) 'subs_id': subsId,
      if (rxInvoice != null) 'rx_invoice': rxInvoice,
      if (rxCharge != null) 'rx_charge': rxCharge,
      if (paymentMethode != null) 'payment_methode': paymentMethode,
      if (deliveryId != null) 'delivery_id': deliveryId,
      if (routeId != null) 'route_id': routeId,
      if (customerRemarks != null) 'customer_remarks': customerRemarks,
      if (baseSignature != null) 'base_signature': baseSignature,
      if (baseImage != null) 'base_image': baseImage,
      if (date_Time != null) 'date_time': date_Time,
      if (deliveryStatus != null) 'delivery_status': deliveryStatus,
      if (exemptionId != null) 'exemption_id': exemptionId,
      if (questionAnswerModels != null) 'question_answer_models': questionAnswerModels,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (reschudleDate != null) 'reschudle_date': reschudleDate,
      if (param1 != null) 'param1': param1,
      if (param2 != null) 'param2': param2,
      if (param3 != null) 'param3': param3,
      if (param4 != null) 'param4': param4,
      if (param5 != null) 'param5': param5,
      if (param6 != null) 'param6': param6,
      if (param7 != null) 'param7': param7,
      if (param8 != null) 'param8': param8,
      if (param10 != null) 'param10': param10,
      if (param9 != null) 'param9': param9,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  OrderCompleteDataCompanion copyWith(
      {Value<int>? id,
      Value<String>? remarks,
      Value<int>? userId,
      Value<String>? deliveredTo,
      Value<String>? addDelCharge,
      Value<String>? notPaidReason,
      Value<int>? subsId,
      Value<String>? rxInvoice,
      Value<String>? rxCharge,
      Value<String>? paymentMethode,
      Value<String>? deliveryId,
      Value<String>? routeId,
      Value<String>? customerRemarks,
      Value<String>? baseSignature,
      Value<String>? baseImage,
      Value<String>? date_Time,
      Value<int>? deliveryStatus,
      Value<int>? exemptionId,
      Value<String>? questionAnswerModels,
      Value<String>? paymentStatus,
      Value<String>? reschudleDate,
      Value<String>? param1,
      Value<String>? param2,
      Value<String>? param3,
      Value<String>? param4,
      Value<String>? param5,
      Value<String>? param6,
      Value<String>? param7,
      Value<String>? param8,
      Value<String>? param10,
      Value<String>? param9,
      Value<double>? latitude,
      Value<double>? longitude}) {
    return OrderCompleteDataCompanion(
      id: id ?? this.id,
      remarks: remarks ?? this.remarks,
      userId: userId ?? this.userId,
      deliveredTo: deliveredTo ?? this.deliveredTo,
      addDelCharge: addDelCharge ?? this.addDelCharge,
      notPaidReason: notPaidReason ?? this.notPaidReason,
      subsId: subsId ?? this.subsId,
      rxInvoice: rxInvoice ?? this.rxInvoice,
      rxCharge: rxCharge ?? this.rxCharge,
      paymentMethode: paymentMethode ?? this.paymentMethode,
      deliveryId: deliveryId ?? this.deliveryId,
      routeId: routeId ?? this.routeId,
      customerRemarks: customerRemarks ?? this.customerRemarks,
      baseSignature: baseSignature ?? this.baseSignature,
      baseImage: baseImage ?? this.baseImage,
      date_Time: date_Time ?? this.date_Time,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      exemptionId: exemptionId ?? this.exemptionId,
      questionAnswerModels: questionAnswerModels ?? this.questionAnswerModels,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      reschudleDate: reschudleDate ?? this.reschudleDate,
      param1: param1 ?? this.param1,
      param2: param2 ?? this.param2,
      param3: param3 ?? this.param3,
      param4: param4 ?? this.param4,
      param5: param5 ?? this.param5,
      param6: param6 ?? this.param6,
      param7: param7 ?? this.param7,
      param8: param8 ?? this.param8,
      param10: param10 ?? this.param10,
      param9: param9 ?? this.param9,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (deliveredTo.present) {
      map['delivered_to'] = Variable<String>(deliveredTo.value);
    }
    if (addDelCharge.present) {
      map['add_del_charge'] = Variable<String>(addDelCharge.value);
    }
    if (notPaidReason.present) {
      map['not_paid_reason'] = Variable<String>(notPaidReason.value);
    }
    if (subsId.present) {
      map['subs_id'] = Variable<int>(subsId.value);
    }
    if (rxInvoice.present) {
      map['rx_invoice'] = Variable<String>(rxInvoice.value);
    }
    if (rxCharge.present) {
      map['rx_charge'] = Variable<String>(rxCharge.value);
    }
    if (paymentMethode.present) {
      map['payment_methode'] = Variable<String>(paymentMethode.value);
    }
    if (deliveryId.present) {
      map['delivery_id'] = Variable<String>(deliveryId.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (customerRemarks.present) {
      map['customer_remarks'] = Variable<String>(customerRemarks.value);
    }
    if (baseSignature.present) {
      map['base_signature'] = Variable<String>(baseSignature.value);
    }
    if (baseImage.present) {
      map['base_image'] = Variable<String>(baseImage.value);
    }
    if (date_Time.present) {
      map['date_time'] = Variable<String>(date_Time.value);
    }
    if (deliveryStatus.present) {
      map['delivery_status'] = Variable<int>(deliveryStatus.value);
    }
    if (exemptionId.present) {
      map['exemption_id'] = Variable<int>(exemptionId.value);
    }
    if (questionAnswerModels.present) {
      map['question_answer_models'] = Variable<String>(questionAnswerModels.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (reschudleDate.present) {
      map['reschudle_date'] = Variable<String>(reschudleDate.value);
    }
    if (param1.present) {
      map['param1'] = Variable<String>(param1.value);
    }
    if (param2.present) {
      map['param2'] = Variable<String>(param2.value);
    }
    if (param3.present) {
      map['param3'] = Variable<String>(param3.value);
    }
    if (param4.present) {
      map['param4'] = Variable<String>(param4.value);
    }
    if (param5.present) {
      map['param5'] = Variable<String>(param5.value);
    }
    if (param6.present) {
      map['param6'] = Variable<String>(param6.value);
    }
    if (param7.present) {
      map['param7'] = Variable<String>(param7.value);
    }
    if (param8.present) {
      map['param8'] = Variable<String>(param8.value);
    }
    if (param10.present) {
      map['param10'] = Variable<String>(param10.value);
    }
    if (param9.present) {
      map['param9'] = Variable<String>(param9.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderCompleteDataCompanion(')
          ..write('id: $id, ')
          ..write('remarks: $remarks, ')
          ..write('userId: $userId, ')
          ..write('deliveredTo: $deliveredTo, ')
          ..write('addDelCharge: $addDelCharge, ')
          ..write('notPaidReason: $notPaidReason, ')
          ..write('subsId: $subsId, ')
          ..write('rxInvoice: $rxInvoice, ')
          ..write('rxCharge: $rxCharge, ')
          ..write('paymentMethode: $paymentMethode, ')
          ..write('deliveryId: $deliveryId, ')
          ..write('routeId: $routeId, ')
          ..write('customerRemarks: $customerRemarks, ')
          ..write('baseSignature: $baseSignature, ')
          ..write('baseImage: $baseImage, ')
          ..write('date_Time: $date_Time, ')
          ..write('deliveryStatus: $deliveryStatus, ')
          ..write('exemptionId: $exemptionId, ')
          ..write('questionAnswerModels: $questionAnswerModels, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('reschudleDate: $reschudleDate, ')
          ..write('param1: $param1, ')
          ..write('param2: $param2, ')
          ..write('param3: $param3, ')
          ..write('param4: $param4, ')
          ..write('param5: $param5, ')
          ..write('param6: $param6, ')
          ..write('param7: $param7, ')
          ..write('param8: $param8, ')
          ..write('param10: $param10, ')
          ..write('param9: $param9, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

class $OrderCompleteDataTable extends OrderCompleteData with TableInfo<$OrderCompleteDataTable, order_complete_data> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $OrderCompleteDataTable(this.attachedDatabase, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false, type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _remarksMeta = const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String?> remarks = GeneratedColumn<String?>('remarks', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int?> userId = GeneratedColumn<int?>('user_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _deliveredToMeta = const VerificationMeta('deliveredTo');
  @override
  late final GeneratedColumn<String?> deliveredTo = GeneratedColumn<String?>('delivered_to', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _addDelChargeMeta = const VerificationMeta('addDelCharge');
  @override
  late final GeneratedColumn<String?> addDelCharge = GeneratedColumn<String?>('add_del_charge', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _notPaidReasonMeta = const VerificationMeta('notPaidReason');
  @override
  late final GeneratedColumn<String?> notPaidReason = GeneratedColumn<String?>('not_paid_reason', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _subsIdMeta = const VerificationMeta('subsId');
  @override
  late final GeneratedColumn<int?> subsId = GeneratedColumn<int?>('subs_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _rxInvoiceMeta = const VerificationMeta('rxInvoice');
  @override
  late final GeneratedColumn<String?> rxInvoice = GeneratedColumn<String?>('rx_invoice', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _rxChargeMeta = const VerificationMeta('rxCharge');
  @override
  late final GeneratedColumn<String?> rxCharge = GeneratedColumn<String?>('rx_charge', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _paymentMethodeMeta = const VerificationMeta('paymentMethode');
  @override
  late final GeneratedColumn<String?> paymentMethode = GeneratedColumn<String?>('payment_methode', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _deliveryIdMeta = const VerificationMeta('deliveryId');
  @override
  late final GeneratedColumn<String?> deliveryId = GeneratedColumn<String?>('delivery_id', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _routeIdMeta = const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<String?> routeId = GeneratedColumn<String?>('route_id', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _customerRemarksMeta = const VerificationMeta('customerRemarks');
  @override
  late final GeneratedColumn<String?> customerRemarks = GeneratedColumn<String?>('customer_remarks', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _baseSignatureMeta = const VerificationMeta('baseSignature');
  @override
  late final GeneratedColumn<String?> baseSignature = GeneratedColumn<String?>('base_signature', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _baseImageMeta = const VerificationMeta('baseImage');
  @override
  late final GeneratedColumn<String?> baseImage = GeneratedColumn<String?>('base_image', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _date_TimeMeta = const VerificationMeta('date_Time');
  @override
  late final GeneratedColumn<String?> date_Time = GeneratedColumn<String?>('date_time', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _deliveryStatusMeta = const VerificationMeta('deliveryStatus');
  @override
  late final GeneratedColumn<int?> deliveryStatus = GeneratedColumn<int?>('delivery_status', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _exemptionIdMeta = const VerificationMeta('exemptionId');
  @override
  late final GeneratedColumn<int?> exemptionId = GeneratedColumn<int?>('exemption_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _questionAnswerModelsMeta = const VerificationMeta('questionAnswerModels');
  @override
  late final GeneratedColumn<String?> questionAnswerModels = GeneratedColumn<String?>('question_answer_models', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _paymentStatusMeta = const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String?> paymentStatus = GeneratedColumn<String?>('payment_status', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _reschudleDateMeta = const VerificationMeta('reschudleDate');
  @override
  late final GeneratedColumn<String?> reschudleDate = GeneratedColumn<String?>('reschudle_date', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param1Meta = const VerificationMeta('param1');
  @override
  late final GeneratedColumn<String?> param1 = GeneratedColumn<String?>('param1', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param2Meta = const VerificationMeta('param2');
  @override
  late final GeneratedColumn<String?> param2 = GeneratedColumn<String?>('param2', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param3Meta = const VerificationMeta('param3');
  @override
  late final GeneratedColumn<String?> param3 = GeneratedColumn<String?>('param3', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param4Meta = const VerificationMeta('param4');
  @override
  late final GeneratedColumn<String?> param4 = GeneratedColumn<String?>('param4', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param5Meta = const VerificationMeta('param5');
  @override
  late final GeneratedColumn<String?> param5 = GeneratedColumn<String?>('param5', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param6Meta = const VerificationMeta('param6');
  @override
  late final GeneratedColumn<String?> param6 = GeneratedColumn<String?>('param6', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param7Meta = const VerificationMeta('param7');
  @override
  late final GeneratedColumn<String?> param7 = GeneratedColumn<String?>('param7', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param8Meta = const VerificationMeta('param8');
  @override
  late final GeneratedColumn<String?> param8 = GeneratedColumn<String?>('param8', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param10Meta = const VerificationMeta('param10');
  @override
  late final GeneratedColumn<String?> param10 = GeneratedColumn<String?>('param10', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _param9Meta = const VerificationMeta('param9');
  @override
  late final GeneratedColumn<String?> param9 = GeneratedColumn<String?>('param9', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double?> latitude = GeneratedColumn<double?>('latitude', aliasedName, false, type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double?> longitude = GeneratedColumn<double?>('longitude', aliasedName, false, type: const RealType(), requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, remarks, userId, deliveredTo, addDelCharge, notPaidReason, subsId, rxInvoice, rxCharge, paymentMethode, deliveryId, routeId, customerRemarks, baseSignature, baseImage, date_Time, deliveryStatus, exemptionId, questionAnswerModels, paymentStatus, reschudleDate, param1, param2, param3, param4, param5, param6, param7, param8, param10, param9, latitude, longitude];

  @override
  String get aliasedName => _alias ?? 'order_complete_data';

  @override
  String get actualTableName => 'order_complete_data';

  @override
  VerificationContext validateIntegrity(Insertable<order_complete_data> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta, remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    } else if (isInserting) {
      context.missing(_remarksMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('delivered_to')) {
      context.handle(_deliveredToMeta, deliveredTo.isAcceptableOrUnknown(data['delivered_to']!, _deliveredToMeta));
    } else if (isInserting) {
      context.missing(_deliveredToMeta);
    }
    if (data.containsKey('add_del_charge')) {
      context.handle(_addDelChargeMeta, addDelCharge.isAcceptableOrUnknown(data['add_del_charge']!, _addDelChargeMeta));
    } else if (isInserting) {
      context.missing(_addDelChargeMeta);
    }
    if (data.containsKey('not_paid_reason')) {
      context.handle(_notPaidReasonMeta, notPaidReason.isAcceptableOrUnknown(data['not_paid_reason']!, _notPaidReasonMeta));
    } else if (isInserting) {
      context.missing(_notPaidReasonMeta);
    }
    if (data.containsKey('subs_id')) {
      context.handle(_subsIdMeta, subsId.isAcceptableOrUnknown(data['subs_id']!, _subsIdMeta));
    } else if (isInserting) {
      context.missing(_subsIdMeta);
    }
    if (data.containsKey('rx_invoice')) {
      context.handle(_rxInvoiceMeta, rxInvoice.isAcceptableOrUnknown(data['rx_invoice']!, _rxInvoiceMeta));
    } else if (isInserting) {
      context.missing(_rxInvoiceMeta);
    }
    if (data.containsKey('rx_charge')) {
      context.handle(_rxChargeMeta, rxCharge.isAcceptableOrUnknown(data['rx_charge']!, _rxChargeMeta));
    } else if (isInserting) {
      context.missing(_rxChargeMeta);
    }
    if (data.containsKey('payment_methode')) {
      context.handle(_paymentMethodeMeta, paymentMethode.isAcceptableOrUnknown(data['payment_methode']!, _paymentMethodeMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodeMeta);
    }
    if (data.containsKey('delivery_id')) {
      context.handle(_deliveryIdMeta, deliveryId.isAcceptableOrUnknown(data['delivery_id']!, _deliveryIdMeta));
    } else if (isInserting) {
      context.missing(_deliveryIdMeta);
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta, routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('customer_remarks')) {
      context.handle(_customerRemarksMeta, customerRemarks.isAcceptableOrUnknown(data['customer_remarks']!, _customerRemarksMeta));
    } else if (isInserting) {
      context.missing(_customerRemarksMeta);
    }
    if (data.containsKey('base_signature')) {
      context.handle(_baseSignatureMeta, baseSignature.isAcceptableOrUnknown(data['base_signature']!, _baseSignatureMeta));
    } else if (isInserting) {
      context.missing(_baseSignatureMeta);
    }
    if (data.containsKey('base_image')) {
      context.handle(_baseImageMeta, baseImage.isAcceptableOrUnknown(data['base_image']!, _baseImageMeta));
    } else if (isInserting) {
      context.missing(_baseImageMeta);
    }
    if (data.containsKey('date_time')) {
      context.handle(_date_TimeMeta, date_Time.isAcceptableOrUnknown(data['date_time']!, _date_TimeMeta));
    } else if (isInserting) {
      context.missing(_date_TimeMeta);
    }
    if (data.containsKey('delivery_status')) {
      context.handle(_deliveryStatusMeta, deliveryStatus.isAcceptableOrUnknown(data['delivery_status']!, _deliveryStatusMeta));
    } else if (isInserting) {
      context.missing(_deliveryStatusMeta);
    }
    if (data.containsKey('exemption_id')) {
      context.handle(_exemptionIdMeta, exemptionId.isAcceptableOrUnknown(data['exemption_id']!, _exemptionIdMeta));
    } else if (isInserting) {
      context.missing(_exemptionIdMeta);
    }
    if (data.containsKey('question_answer_models')) {
      context.handle(_questionAnswerModelsMeta, questionAnswerModels.isAcceptableOrUnknown(data['question_answer_models']!, _questionAnswerModelsMeta));
    } else if (isInserting) {
      context.missing(_questionAnswerModelsMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(_paymentStatusMeta, paymentStatus.isAcceptableOrUnknown(data['payment_status']!, _paymentStatusMeta));
    } else if (isInserting) {
      context.missing(_paymentStatusMeta);
    }
    if (data.containsKey('reschudle_date')) {
      context.handle(_reschudleDateMeta, reschudleDate.isAcceptableOrUnknown(data['reschudle_date']!, _reschudleDateMeta));
    } else if (isInserting) {
      context.missing(_reschudleDateMeta);
    }
    if (data.containsKey('param1')) {
      context.handle(_param1Meta, param1.isAcceptableOrUnknown(data['param1']!, _param1Meta));
    } else if (isInserting) {
      context.missing(_param1Meta);
    }
    if (data.containsKey('param2')) {
      context.handle(_param2Meta, param2.isAcceptableOrUnknown(data['param2']!, _param2Meta));
    } else if (isInserting) {
      context.missing(_param2Meta);
    }
    if (data.containsKey('param3')) {
      context.handle(_param3Meta, param3.isAcceptableOrUnknown(data['param3']!, _param3Meta));
    } else if (isInserting) {
      context.missing(_param3Meta);
    }
    if (data.containsKey('param4')) {
      context.handle(_param4Meta, param4.isAcceptableOrUnknown(data['param4']!, _param4Meta));
    } else if (isInserting) {
      context.missing(_param4Meta);
    }
    if (data.containsKey('param5')) {
      context.handle(_param5Meta, param5.isAcceptableOrUnknown(data['param5']!, _param5Meta));
    } else if (isInserting) {
      context.missing(_param5Meta);
    }
    if (data.containsKey('param6')) {
      context.handle(_param6Meta, param6.isAcceptableOrUnknown(data['param6']!, _param6Meta));
    } else if (isInserting) {
      context.missing(_param6Meta);
    }
    if (data.containsKey('param7')) {
      context.handle(_param7Meta, param7.isAcceptableOrUnknown(data['param7']!, _param7Meta));
    } else if (isInserting) {
      context.missing(_param7Meta);
    }
    if (data.containsKey('param8')) {
      context.handle(_param8Meta, param8.isAcceptableOrUnknown(data['param8']!, _param8Meta));
    } else if (isInserting) {
      context.missing(_param8Meta);
    }
    if (data.containsKey('param10')) {
      context.handle(_param10Meta, param10.isAcceptableOrUnknown(data['param10']!, _param10Meta));
    } else if (isInserting) {
      context.missing(_param10Meta);
    }
    if (data.containsKey('param9')) {
      context.handle(_param9Meta, param9.isAcceptableOrUnknown(data['param9']!, _param9Meta));
    } else if (isInserting) {
      context.missing(_param9Meta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta, latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta, longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  order_complete_data map(Map<String, dynamic> data, {String? tablePrefix}) {
    return order_complete_data.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $OrderCompleteDataTable createAlias(String alias) {
    return $OrderCompleteDataTable(attachedDatabase, alias);
  }
}

class exemptions extends DataClass implements Insertable<exemptions> {
  final int id;
  final int exemptionId;
  final String name;
  final String serialId;

  exemptions({required this.id, required this.exemptionId, required this.name, required this.serialId});

  factory exemptions.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return exemptions(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      exemptionId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}exemption_id'])!,
      name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      serialId: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}serial_id'])!,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exemption_id'] = Variable<int>(exemptionId);
    map['name'] = Variable<String>(name);
    map['serial_id'] = Variable<String>(serialId);
    return map;
  }

  ExemptionsDataCompanion toCompanion(bool nullToAbsent) {
    return ExemptionsDataCompanion(
      id: Value(id),
      exemptionId: Value(exemptionId),
      name: Value(name),
      serialId: Value(serialId),
    );
  }

  factory exemptions.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return exemptions(
      id: serializer.fromJson<int>(json['id']),
      exemptionId: serializer.fromJson<int>(json['exemptionId']),
      name: serializer.fromJson<String>(json['name']),
      serialId: serializer.fromJson<String>(json['serialId']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exemptionId': serializer.toJson<int>(exemptionId),
      'name': serializer.toJson<String>(name),
      'serialId': serializer.toJson<String>(serialId),
    };
  }

  exemptions copyWith({int? id, int? exemptionId, String? name, String? serialId}) => exemptions(
        id: id ?? this.id,
        exemptionId: exemptionId ?? this.exemptionId,
        name: name ?? this.name,
        serialId: serialId ?? this.serialId,
      );

  @override
  String toString() {
    return (StringBuffer('exemptions(')
          ..write('id: $id, ')
          ..write('exemptionId: $exemptionId, ')
          ..write('name: $name, ')
          ..write('serialId: $serialId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exemptionId, name, serialId);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is exemptions && other.id == this.id && other.exemptionId == this.exemptionId && other.name == this.name && other.serialId == this.serialId);
}

class ExemptionsDataCompanion extends UpdateCompanion<exemptions> {
  final Value<int> id;
  final Value<int> exemptionId;
  final Value<String> name;
  final Value<String> serialId;

  const ExemptionsDataCompanion({
    this.id = const Value.absent(),
    this.exemptionId = const Value.absent(),
    this.name = const Value.absent(),
    this.serialId = const Value.absent(),
  });

  ExemptionsDataCompanion.insert({
    this.id = const Value.absent(),
    required int exemptionId,
    required String name,
    required String serialId,
  })  : exemptionId = Value(exemptionId),
        name = Value(name),
        serialId = Value(serialId);

  static Insertable<exemptions> custom({
    Expression<int>? id,
    Expression<int>? exemptionId,
    Expression<String>? name,
    Expression<String>? serialId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exemptionId != null) 'exemption_id': exemptionId,
      if (name != null) 'name': name,
      if (serialId != null) 'serial_id': serialId,
    });
  }

  ExemptionsDataCompanion copyWith({Value<int>? id, Value<int>? exemptionId, Value<String>? name, Value<String>? serialId}) {
    return ExemptionsDataCompanion(
      id: id ?? this.id,
      exemptionId: exemptionId ?? this.exemptionId,
      name: name ?? this.name,
      serialId: serialId ?? this.serialId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exemptionId.present) {
      map['exemption_id'] = Variable<int>(exemptionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (serialId.present) {
      map['serial_id'] = Variable<String>(serialId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExemptionsDataCompanion(')
          ..write('id: $id, ')
          ..write('exemptionId: $exemptionId, ')
          ..write('name: $name, ')
          ..write('serialId: $serialId')
          ..write(')'))
        .toString();
  }
}

class $ExemptionsDataTable extends ExemptionsData with TableInfo<$ExemptionsDataTable, exemptions> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $ExemptionsDataTable(this.attachedDatabase, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false, type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _exemptionIdMeta = const VerificationMeta('exemptionId');
  @override
  late final GeneratedColumn<int?> exemptionId = GeneratedColumn<int?>('exemption_id', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>('name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _serialIdMeta = const VerificationMeta('serialId');
  @override
  late final GeneratedColumn<String?> serialId = GeneratedColumn<String?>('serial_id', aliasedName, false, type: const StringType(), requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, exemptionId, name, serialId];

  @override
  String get aliasedName => _alias ?? 'exemptions_data';

  @override
  String get actualTableName => 'exemptions_data';

  @override
  VerificationContext validateIntegrity(Insertable<exemptions> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exemption_id')) {
      context.handle(_exemptionIdMeta, exemptionId.isAcceptableOrUnknown(data['exemption_id']!, _exemptionIdMeta));
    } else if (isInserting) {
      context.missing(_exemptionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('serial_id')) {
      context.handle(_serialIdMeta, serialId.isAcceptableOrUnknown(data['serial_id']!, _serialIdMeta));
    } else if (isInserting) {
      context.missing(_serialIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  exemptions map(Map<String, dynamic> data, {String? tablePrefix}) {
    return exemptions.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ExemptionsDataTable createAlias(String alias) {
    return $ExemptionsDataTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TokenTable token = $TokenTable(this);
  late final $DeliveryListTable deliveryList = $DeliveryListTable(this);
  late final $CustomerDetailsTable customerDetails = $CustomerDetailsTable(this);
  late final $CustomerAddressesTable customerAddresses = $CustomerAddressesTable(this);
  late final $OrderCompleteDataTable orderCompleteData = $OrderCompleteDataTable(this);
  late final $ExemptionsDataTable exemptionsData = $ExemptionsDataTable(this);

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [token, deliveryList, customerDetails, customerAddresses, orderCompleteData, exemptionsData];
}
