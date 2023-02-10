// @dart=2.9
class CustomerDetails {
  CustomerDetails({
    this.customerId,
    this.addressId,
    this.nhsNumber,
    this.oldNhsNumber,
    this.inputDob,
    this.dob,
    this.lastOrderDate,
    this.upcomingDeliveryDate,
    this.reminderDate,
    this.deliveryDate,
    this.pickupTypeId,
    this.pickupType,
    this.routeId,
    this.isActive,
    this.doctorId,
    this.surgeryId,
    this.surgeryEmail,
    this.surgeryMobile,
    this.paymentExemption,
    this.deliveryNote,
    this.branchNote,
    this.surgeryNote,
    this.orders,
    this.surgeries,
    this.paymentExemptions,
    this.customerDocuments,
    this.preferredContactNumber,
    this.companyId,
    this.branchId,
    this.surgeryName,
    this.rating,
    this.fullName,
    this.fullAddress,
    this.totalCount,
    this.rowNum,
    this.routeName,
    this.caseTypeId,
    this.paymentExemptionDesc,
    this.branchCode,
    this.pickupTypes,
    this.states,
    this.countries,
    this.routes,
    this.products,
    this.intervals,
    this.orderStatusList,
    this.deliveryStatusList,
    this.deliveryTypes,
    this.storages,
    this.statusList,
    this.preferredContactTypes,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.firstName,
    this.middleName,
    this.lastName,
    this.mobile,
    this.oldMobile,
    this.email,
    this.oldEmail,
    this.landlineNumber,
    this.alternativeContact,
    this.dependentContactNumber,
    this.contactPerson,
    this.countryName,
    this.gender,
    this.title,
    this.address,
    this.showValidationMsg,
    this.token,
    this.taskStatusList,
    this.isApproved,
  });

  int customerId;
  int addressId;
  dynamic nhsNumber;
  dynamic oldNhsNumber;
  dynamic inputDob;
  DateTime dob;
  dynamic lastOrderDate;
  dynamic upcomingDeliveryDate;
  dynamic reminderDate;
  dynamic deliveryDate;
  dynamic pickupTypeId;
  dynamic pickupType;
  dynamic routeId;
  int isActive;
  dynamic doctorId;
  dynamic surgeryId;
  dynamic surgeryEmail;
  dynamic surgeryMobile;
  dynamic paymentExemption;
  dynamic deliveryNote;
  dynamic branchNote;
  dynamic surgeryNote;
  dynamic orders;
  dynamic surgeries;
  dynamic paymentExemptions;
  dynamic customerDocuments;
  dynamic preferredContactNumber;
  dynamic companyId;
  dynamic branchId;
  dynamic surgeryName;
  int rating;
  dynamic fullName;
  dynamic fullAddress;
  int totalCount;
  int rowNum;
  dynamic routeName;
  dynamic caseTypeId;
  dynamic paymentExemptionDesc;
  dynamic branchCode;
  dynamic pickupTypes;
  dynamic states;
  dynamic countries;
  dynamic routes;
  dynamic products;
  dynamic intervals;
  dynamic orderStatusList;
  dynamic deliveryStatusList;
  dynamic deliveryTypes;
  dynamic storages;
  dynamic statusList;
  dynamic preferredContactTypes;
  int createdBy;
  DateTime createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;
  String firstName;
  dynamic middleName;
  String lastName;
  String mobile;
  dynamic oldMobile;
  String email;
  dynamic oldEmail;
  String landlineNumber;
  String alternativeContact;
  String dependentContactNumber;
  String contactPerson;
  dynamic countryName;
  dynamic gender;
  dynamic title;
  dynamic address;
  bool showValidationMsg;
  dynamic token;
  dynamic taskStatusList;
  dynamic isApproved;

  factory CustomerDetails.fromJson(Map<String, dynamic> json) => CustomerDetails(
        customerId: json["customerId"],
        addressId: json["addressId"],
        nhsNumber: json["nhsNumber"],
        oldNhsNumber: json["oldNHSNumber"],
        inputDob: json["inputDob"],
        dob: DateTime.parse(json["dob"]),
        lastOrderDate: json["lastOrderDate"],
        upcomingDeliveryDate: json["upcomingDeliveryDate"],
        reminderDate: json["reminderDate"],
        deliveryDate: json["deliveryDate"],
        pickupTypeId: json["pickupTypeId"],
        pickupType: json["pickupType"],
        routeId: json["routeId"],
        isActive: json["isActive"],
        doctorId: json["doctorId"],
        surgeryId: json["surgeryId"],
        surgeryEmail: json["surgeryEmail"],
        surgeryMobile: json["surgeryMobile"],
        paymentExemption: json["paymentExemption"],
        deliveryNote: json["deliveryNote"],
        branchNote: json["branchNote"],
        surgeryNote: json["surgeryNote"],
        orders: json["orders"],
        surgeries: json["surgeries"],
        paymentExemptions: json["paymentExemptions"],
        customerDocuments: json["customerDocuments"],
        preferredContactNumber: json["preferredContactNumber"],
        companyId: json["companyId"],
        branchId: json["branchId"],
        surgeryName: json["surgeryName"],
        rating: json["rating"],
        fullName: json["fullName"],
        fullAddress: json["fullAddress"],
        totalCount: json["totalCount"],
        rowNum: json["rowNum"],
        routeName: json["routeName"],
        caseTypeId: json["caseTypeId"],
        paymentExemptionDesc: json["paymentExemptionDesc"],
        branchCode: json["branchCode"],
        pickupTypes: json["pickupTypes"],
        states: json["states"],
        countries: json["countries"],
        routes: json["routes"],
        products: json["products"],
        intervals: json["intervals"],
        orderStatusList: json["orderStatusList"],
        deliveryStatusList: json["deliveryStatusList"],
        deliveryTypes: json["deliveryTypes"],
        storages: json["storages"],
        statusList: json["statusList"],
        preferredContactTypes: json["preferredContactTypes"],
        createdBy: json["createdBy"],
        createdOn: DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        oldMobile: json["oldMobile"],
        email: json["email"],
        oldEmail: json["oldEmail"],
        landlineNumber: json["landlineNumber"],
        alternativeContact: json["alternativeContact"],
        dependentContactNumber: json["dependentContactNumber"],
        contactPerson: json["contactPerson"],
        countryName: json["countryName"],
        gender: json["gender"],
        title: json["title"],
        address: json["address"],
        showValidationMsg: json["showValidationMsg"],
        token: json["token"],
        taskStatusList: json["taskStatusList"],
        isApproved: json["isApproved"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "addressId": addressId,
        "nhsNumber": nhsNumber,
        "oldNHSNumber": oldNhsNumber,
        "inputDob": inputDob,
        "dob": dob.toIso8601String(),
        "lastOrderDate": lastOrderDate,
        "upcomingDeliveryDate": upcomingDeliveryDate,
        "reminderDate": reminderDate,
        "deliveryDate": deliveryDate,
        "pickupTypeId": pickupTypeId,
        "pickupType": pickupType,
        "routeId": routeId,
        "isActive": isActive,
        "doctorId": doctorId,
        "surgeryId": surgeryId,
        "surgeryEmail": surgeryEmail,
        "surgeryMobile": surgeryMobile,
        "paymentExemption": paymentExemption,
        "deliveryNote": deliveryNote,
        "branchNote": branchNote,
        "surgeryNote": surgeryNote,
        "orders": orders,
        "surgeries": surgeries,
        "paymentExemptions": paymentExemptions,
        "customerDocuments": customerDocuments,
        "preferredContactNumber": preferredContactNumber,
        "companyId": companyId,
        "branchId": branchId,
        "surgeryName": surgeryName,
        "rating": rating,
        "fullName": fullName,
        "fullAddress": fullAddress,
        "totalCount": totalCount,
        "rowNum": rowNum,
        "routeName": routeName,
        "caseTypeId": caseTypeId,
        "paymentExemptionDesc": paymentExemptionDesc,
        "branchCode": branchCode,
        "pickupTypes": pickupTypes,
        "states": states,
        "countries": countries,
        "routes": routes,
        "products": products,
        "intervals": intervals,
        "orderStatusList": orderStatusList,
        "deliveryStatusList": deliveryStatusList,
        "deliveryTypes": deliveryTypes,
        "storages": storages,
        "statusList": statusList,
        "preferredContactTypes": preferredContactTypes,
        "createdBy": createdBy,
        "createdOn": createdOn.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "mobile": mobile,
        "oldMobile": oldMobile,
        "email": email,
        "oldEmail": oldEmail,
        "landlineNumber": landlineNumber,
        "alternativeContact": alternativeContact,
        "dependentContactNumber": dependentContactNumber,
        "contactPerson": contactPerson,
        "countryName": countryName,
        "gender": gender,
        "title": title,
        "address": address,
        "showValidationMsg": showValidationMsg,
        "token": token,
        "taskStatusList": taskStatusList,
        "isApproved": isApproved,
      };
}
