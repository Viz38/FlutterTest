import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ProjectFirebaseUser {
  ProjectFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

ProjectFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<ProjectFirebaseUser> projectFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<ProjectFirebaseUser>(
        (user) => currentUser = ProjectFirebaseUser(user));
