import 'package:flutter/cupertino.dart';
import 'package:pharmdel_business/model/pmr_model.dart';

class FetchCustomerData extends ChangeNotifier {
  List<PmrModel> pmrList = [];

  void addData(List<PmrModel> model) {
    pmrList.addAll(model);
    notifyListeners();
  }
}
