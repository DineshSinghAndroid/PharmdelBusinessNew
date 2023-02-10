import 'package:pharmdel_business/data/rest_ds.dart';

abstract class DeliveryUpdateCotract {
  void onDeliveryUpdateSuccess(Map<String, Object> user);

  void onDeliveryUpdateError(String errorTxt);
}

class DeliveryUpdatePresenter {
  DeliveryUpdateCotract _view;
  RestDatasource api = new RestDatasource();

  DeliveryUpdatePresenter(this._view);

  doDeliveryUpdate(String deliveryId, String remarks, String deliveredTo, var deliveryStatus, Map<String, String> map, String token) {
    api.deliveryStatusUpdate(deliveryId, remarks, deliveredTo, deliveryStatus, map, token).then((Map<String, Object> user) {
      _view.onDeliveryUpdateSuccess(user);
    }).catchError((Object error) => {_view.onDeliveryUpdateError(error.toString())});
  }
}
