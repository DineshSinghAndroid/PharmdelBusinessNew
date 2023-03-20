class GetMapRoutesApiResponse {
  double? longitude;
  double? latitude;
  String? kmtom;
  bool? isPharmacyAddress;
  String? deliveryStatus;
  String? deliveryStatusDec;
  String? customerAddress;
  String? customerName;
  String? completeTime;

  GetMapRoutesApiResponse(
      {this.longitude,
      this.latitude,
      this.kmtom,
      this.isPharmacyAddress,
      this.deliveryStatus,
      this.deliveryStatusDec,
      this.customerAddress,
      this.customerName,
      this.completeTime});

  GetMapRoutesApiResponse.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
    kmtom = json['kmtom'] != null ? json['kmtom'].toString():null;
    isPharmacyAddress = json['isPharmacyAddress'];
    deliveryStatus = json['deliveryStatus'] != null ? json['deliveryStatus'].toString():null;
    deliveryStatusDec = json['deliveryStatusDec'] != null ? json['deliveryStatusDec'].toString():null;
    customerAddress = json['customerAddress'] != null ? json['customerAddress'].toString():null;
    customerName = json['customerName'] != null ? json['customerName'].toString():null;
    completeTime = json['completeTime'] != null ? json['completeTime'].toString():null;
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
