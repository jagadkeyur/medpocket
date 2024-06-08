import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state/AppState.dart';

class GetToken {
  final dynamic _token;
  dynamic get token => _token;
  GetToken(this._token);
}

ThunkAction<AppState> getToken = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  store.dispatch(GetToken(token));
};


