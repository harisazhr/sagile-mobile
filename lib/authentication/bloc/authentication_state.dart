part of 'authentication_bloc.dart';

// Determines status of auth when state of auth changes
// Each status corresponds to different events
class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated, user: User.empty);

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
