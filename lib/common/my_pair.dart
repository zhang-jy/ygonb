class MyPair<FIRST, SECOND> {
  final FIRST first;
  final SECOND second;

  MyPair(this.first, this.second);

  @override
  String toString() {
    return 'MyPair{first: $first, second: $second}';
  }
}