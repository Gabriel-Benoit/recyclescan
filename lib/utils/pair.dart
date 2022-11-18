class Pair<E1, E2> {
  final E1 _first;
  final E2 _second;
  const Pair(this._first, this._second);

  E1 first() {
    return _first;
  }

  E2 second() {
    return _second;
  }
}
