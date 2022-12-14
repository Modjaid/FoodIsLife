class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return User.fromFireBase(user);
    } catch (e) {
      print(' ВНиминаиЕ $e');
      return null;
    }
  }

  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return User.fromFireBase(user);
    } catch (e) {
      print(' ВНиминаиЕ $e');
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<User> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User user) => user != null ? User.fromFireBase(user) : null);
  }
}
