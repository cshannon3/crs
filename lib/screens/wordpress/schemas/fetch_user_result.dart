import 'user.dart';

class FetchUsersResult {
  List<User> users;
  int totalUsers;

  FetchUsersResult(List<User> users, int totalUsers) {
    this.users = users;
    this.totalUsers = totalUsers;
  }
}
