import 'package:quiver/core.dart';

class Pair<T1, T2> {
  final T1 first;
  final T2 last;

  Pair(this.first, this.last);

  @override
  bool operator ==(Object other) {
    return (other is Pair) && other.first == first && other.last == last;
  }

  @override
  int get hashCode => hash2(first.hashCode, last.hashCode);
}