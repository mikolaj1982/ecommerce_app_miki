class AppUser {
  const AppUser({
    required this.uid,
    this.email,
  });

  final String uid;
  final String? email;

  @override
  bool operator ==(covariant AppUser other) => identical(this, other) || (email == other.email);

  @override
  int get hashCode => Object.hashAll([
        email,
      ]);

  // @override
  // bool operator ==(covariant AppUser other) => identical(this, other) || (uid == other.uid && email == other.email);
  //
  // @override
  // int get hashCode => Object.hashAll([
  //       uid,
  //       email,
  //     ]);
}
