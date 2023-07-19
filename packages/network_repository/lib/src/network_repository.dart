/// {@template network_repository}
/// The interface and models for network-related such as URLs
/// {@endtemplate}
class NetworkRepository {
  /// {@macro network_repository}
  const NetworkRepository();

  /// the main url
  static const mainURL = 'https://241e-161-139-222-49.ngrok-free.app';

  /// the api url
  static const apiURL = '$mainURL/api';

  /// the login url
  static const loginURL = '$apiURL/login';

  /// the logout url
  static const logoutURL = '$apiURL/logout';

  /// the user url
  static const userURL = '$apiURL/user';

  /// the project url
  static const projectURL = '$apiURL/project';

  /// the status url
  static const statusURL = '$apiURL/status';

  /// the userstory url
  static const userstoryURL = '$apiURL/userstory';

  /// the task url
  static const taskURL = '$apiURL/task';
}
