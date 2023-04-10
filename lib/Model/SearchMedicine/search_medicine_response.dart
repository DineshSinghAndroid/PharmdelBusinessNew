class SearchMedicineListApiResponse {
  bool? authenticated;
  bool? error;
  String? message;
  SearchMedicineData? medicineData;

  SearchMedicineListApiResponse(
      {this.authenticated, this.error, this.message, this.medicineData});

  SearchMedicineListApiResponse.fromJson(Map<String, dynamic> json) {
    authenticated = json['authenticated'] != null && json['authenticated'].toString().toLowerCase() == "true" ? true:false;
    error = json['error'] != null && json['error'].toString().toLowerCase() == "true" ? true:false;
    message = json['message'] != null ? json['message'].toString():null;
    medicineData = json['data'] != null ? new SearchMedicineData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authenticated'] = this.authenticated;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.medicineData != null) {
      data['data'] = this.medicineData!.toJson();
    }
    return data;
  }
}

class SearchMedicineData {
  String? currentPage;
  List<SearchMedicineListData>? medicineListData;
  String? firstPageUrl;
  String? from;
  String? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  String? perPage;
  String? prevPageUrl;
  String? to;
  String? total;

  SearchMedicineData(
      {this.currentPage,
        this.medicineListData,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  SearchMedicineData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'] != null ? json['current_page'].toString():null;
    if (json['data'] != null) {
      medicineListData = <SearchMedicineListData>[];
      json['data'].forEach((v) {
        medicineListData!.add(new SearchMedicineListData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'] != null ? json['first_page_url'].toString():null;
    from = json['from'] != null ? json['from'].toString():null;
    lastPage = json['last_page'] != null ? json['last_page'].toString():null;
    lastPageUrl = json['last_page_url'] != null ? json['last_page_url'].toString():null;
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'] != null ? json['next_page_url'].toString():null;
    path = json['path'] != null ? json['path'].toString():null;
    perPage = json['per_page'] != null ? json['per_page'].toString():null;
    prevPageUrl = json['prev_page_url'] != null ? json['prev_page_url'].toString():null;
    to = json['to'] != null ? json['to'].toString():null;
    total = json['total'] != null ? json['total'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.medicineListData != null) {
      data['data'] = this.medicineListData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class SearchMedicineListData {
  String? id;
  String? name;
  String? vtmName;
  String? packSize;
  String? drugInfo;
  String? quantity;
  String? days;
  bool isControlDrug = false;
  bool isFridge = false;

  SearchMedicineListData({this.id, this.name, this.vtmName, this.packSize, this.drugInfo});

  SearchMedicineListData.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    vtmName = json['vtm_name'] != null ? json['vtm_name'].toString():null;
    packSize = json['pack_size'] != null ? json['pack_size'].toString():null;
    drugInfo = json['drug_info'] != null ? json['drug_info'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['vtm_name'] = this.vtmName;
    data['pack_size'] = this.packSize;
    data['drug_info'] = this.drugInfo;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'] != null ? json['url'].toString():null;
    label = json['label'] != null ? json['label'].toString():null;
    active = json['active'] != null && json['active'].toString().toLowerCase() == "true" ? true:false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
