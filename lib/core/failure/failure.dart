class Failure {
  final String failureMessage;

  const Failure({required this.failureMessage});

  @override
  String toString() => failureMessage;
}
