class GetRouteForPharmacyModelResponse {
  double? longitude;
  double? latitude;
  String? kmtom;
  bool? isPharmacyAddress;
  int? deliveryStatus;
  String? deliveryStatusDec;
  String? customerAddress;
  String? customerName;
  String? completeTime;

  GetRouteForPharmacyModelResponse(
      {this.longitude,
        this.latitude,
        this.kmtom,
        this.isPharmacyAddress,
        this.deliveryStatus,
        this.deliveryStatusDec,
        this.customerAddress,
        this.customerName,
        this.completeTime});

  GetRouteForPharmacyModelResponse.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
    kmtom = json['kmtom'];
    isPharmacyAddress = json['isPharmacyAddress'];
    deliveryStatus = json['deliveryStatus'];
    deliveryStatusDec = json['deliveryStatusDec'];
    customerAddress = json['customerAddress'];
    customerName = json['customerName'];
    completeTime = json['completeTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['kmtom'] = this.kmtom;
    data['isPharmacyAddress'] = this.isPharmacyAddress;
    data['deliveryStatus'] = this.deliveryStatus;
    data['deliveryStatusDec'] = this.deliveryStatusDec;
    data['customerAddress'] = this.customerAddress;
    data['customerName'] = this.customerName;
    data['completeTime'] = this.completeTime;
    return data;
  }
}
