class AppState {
  final dynamic token;
  final dynamic user;

  AppState({this.token, this.user});

  factory AppState.initial() {
    return AppState(token: null, user: null);
  }
}
