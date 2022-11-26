/// Représente une paire de deux objets ayant chacun leur propre type
class Pair<T1, T2> {
  final T1 _f;
  final T2 _s;

  const Pair(this._f, this._s);

  /// Renvoie le premier élément de la paire
  T1 first() {
    return _f;
  }

  /// Renvoie le second élément de la paire
  T2 second() {
    return _s;
  }
}
