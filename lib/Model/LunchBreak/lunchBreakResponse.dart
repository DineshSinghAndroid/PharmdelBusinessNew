class LunchBreakApiResponse {
  String? status;

  LunchBreakApiResponse({this.status});

  LunchBreakApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? json['status'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}
