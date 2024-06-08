import 'package:medpocket/src/actions/Actions.dart';
import '../app_state/AppState.dart';

AppState appReducer(state, action) {
  return AppState(
    token: tokenReducer(state.token, action),
  );
}

tokenReducer(user, action) {
  if (action is GetToken) {
    return action.token;
  }
}
