class UserState {
  final bool isLoading;
  final String? error;

  final Map<String, dynamic>? user;

  UserState({this.isLoading = false, this.error, this.user});

  UserState copyWith(
    bool? isLoading,
    String? error,
    Map<String, dynamic>? user,
  ) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}
