import 'driver_dashboard_response.dart';

class GetDeliveriesWithRouteShortApiResponse {
  List<DeliveryPojoModal>? deliveryList;
  bool? status;
  int? pageNumber;
  int? pageSize;
  int? totalRecords;
  OrderCounts? orderCounts;
  bool? isStart;
  String? systemTime;
  String? message;
  bool? isOrderAvailable;

  GetDeliveriesWithRouteShortApiResponse(
      {this.deliveryList,
        this.status,
        this.pageNumber,
        this.pageSize,
        this.totalRecords,
        this.orderCounts,
        this.isStart,
        this.systemTime,
        this.message,
        this.isOrderAvailable});

  GetDeliveriesWithRouteShortApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['deliveryList'] != null) {
      deliveryList = <DeliveryPojoModal>[];
      json['deliveryList'].forEach((v) {
        deliveryList!.add(new DeliveryPojoModal.fromJson(v));
      });
    }
    status = json['status'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    orderCounts = json['orderCounts'] != null
        ? new OrderCounts.fromJson(json['orderCounts'])
        : null;
    isStart = json['isStart'];
    systemTime = json['system_time'];
    message = json['message'];
    isOrderAvailable = json['isOrderAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryList != null) {
      data['deliveryList'] = this.deliveryList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    if (this.orderCounts != null) {
      data['orderCounts'] = this.orderCounts!.toJson();
    }
    data['isStart'] = this.isStart;
    data['system_time'] = this.systemTime;
    data['message'] = this.message;
    data['isOrderAvailable'] = this.isOrderAvailable;
    return data;
  }
}
