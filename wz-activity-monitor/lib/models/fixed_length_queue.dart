class FixedLengthQueue<T> {
  final int maxLength;
  final List<T> _items = [];

  FixedLengthQueue(this.maxLength);

  void add(T item) {
    _items.insert(0, item); // Add to front
    if (_items.length > maxLength) {
      _items.removeLast(); // Remove oldest
    }
  }

  List<T> get items => List.unmodifiable(_items);
}
