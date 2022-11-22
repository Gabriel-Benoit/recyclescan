class Pair<T1, T2> {
  final T1 _f;
  final T2 _s;

  const Pair(this._f, this._s);

  T1 first() {
    return _f;
  }

  T2 second() {
    return _s;
  }
}
