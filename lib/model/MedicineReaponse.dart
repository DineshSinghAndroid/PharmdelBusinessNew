// @dart=2.9
class MedicineReaponse {
  bool authenticated;
  bool error;
  String message;
  DataMain dataMain;

  MedicineReaponse({this.authenticated, this.error, this.message, this.dataMain});

  MedicineReaponse.fromJson(Map<String, dynamic> json) {
    authenticated = json['authenticated'];
    error = json['error'];
    message = json['message'];
    dataMain = json['data'] != null ? new DataMain.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authenticated'] = this.authenticated;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.dataMain != null) {
      data['data'] = this.dataMain.toJson();
    }
    return data;
  }
}

class DataMain {
  dynamic currentPage;
  List<MedicineDataList> data;
  String firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String lastPageUrl;
  List<Links> links;
  String nextPageUrl;
  String path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  DataMain({this.currentPage, this.data, this.firstPageUrl, this.from, this.lastPage, this.lastPageUrl, this.links, this.nextPageUrl, this.path, this.perPage, this.prevPageUrl, this.to, this.total});

  DataMain.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<MedicineDataList>();
      json['data'].forEach((v) {
        data.add(new MedicineDataList.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = new List<Links>();
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
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

class MedicineDataList {
  dynamic id;
  String name;
  dynamic vtmName;
  dynamic packSize;
  dynamic drugInfo;
  String quntity;
  String days;
  bool isControlDrug = false;
  bool isFridge = false;

  MedicineDataList({this.id, this.name, this.vtmName, this.packSize, this.drugInfo});

  MedicineDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vtmName = json['vtm_name'];
    packSize = json['pack_size'];
    drugInfo = json['drug_info'];
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
  String url;
  String label;
  bool active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
