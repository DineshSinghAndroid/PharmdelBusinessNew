import 'package:pharmdel_business/data/rest_ds.dart';

abstract class DeliverySignCotract {
  void onDeliverySignUploadSuccess(Map<String, Object> user);

  void onDeliverySignUploadError(String errorTxt);
}

class DeliverySignPresenter {
  DeliverySignCotract _view;
  RestDatasource api = new RestDatasource();

  DeliverySignPresenter(this._view);

  doDeliverySignUpload(String deliveryId, String sign, String token) {
    api.deliverySignUpload(deliveryId, sign, token).then((Map<String, Object> user) {
      _view.onDeliverySignUploadSuccess(user);
    }).catchError((Object error) => {_view.onDeliverySignUploadError(error.toString())});
  }
}
