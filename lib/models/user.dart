class AppUser {
  final String uid;
  final String displayName;
  final String email;
  final String? photoURL;

  AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoURL,
  });
}
