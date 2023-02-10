// @dart=2.9
import 'package:flutter/material.dart';
import 'package:pharmdel_business/DB/MyDatabase.dart';

class DbTestScreen extends StatefulWidget {
  const DbTestScreen({Key key}) : super(key: key);

  @override
  State<DbTestScreen> createState() => _DbTestScreenState();
}

class _DbTestScreenState extends State<DbTestScreen> {
  List deliveryList = [];
  List customerDetailsList = [];
  List customerAddressList = [];
  List orderCompleteList = [];
  List tokensList = [];
  List exemptionsList = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("db test"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("delivery_list"),
            Text("${deliveryList.length}"),
            Text("customer_details"),
            Text("${customerDetailsList.length}"),
            Text("customer_address"),
            Text("${customerAddressList.length}"),
            Text("order_complete_data"),
            Text("${orderCompleteList.length}"),
            Text("tokens"),
            Text("${tokensList.length}"),
            Text("exemptions"),
            Text("${exemptionsList.length}"),
          ],
        ),
      ),
    );
  }

  void init() async {
    deliveryList = await MyDatabase().getAllOutForDeliverysOnly();
    customerDetailsList = await MyDatabase().getAllCustomerDetails();
    customerAddressList = await MyDatabase().getAllCustomerAddress();
    orderCompleteList = await MyDatabase().getAllOrderCompleteData();
    tokensList = await MyDatabase().getToken();
    exemptionsList = await MyDatabase().getExemptionsList();
    setState(() {});
  }
}
