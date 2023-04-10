class MakeNextApiResponse {
  bool? error;
  bool? isOptimize;
  String? message;

  MakeNextApiResponse({this.error, this.isOptimize, this.message});

  MakeNextApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null && json['error'].toString().toLowerCase() == "true" ? true:false;
    isOptimize = json['isOptimize'] != null && json['isOptimize'].toString().toLowerCase() == "true" ? true:false;
    message = json['message'] != null ? json['message'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['isOptimize'] = this.isOptimize;
    data['message'] = this.message;
    return data;
  }
}
