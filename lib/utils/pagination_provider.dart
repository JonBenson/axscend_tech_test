import 'package:axscend_tech_test/config/constants.dart';
import 'package:flutter/foundation.dart';

abstract class PaginationProvider<T> extends ChangeNotifier {
  final List<T> _items = [];

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  bool _hasDisposed = false;

  List<T> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  bool get hasError => _hasError;
  int get currentPage => _currentPage;

  Future<List<T>> fetchNextPage();

  Future<void> refresh() async {
    _hasError = false;
    _isLoading = false;
    _hasMore = true;
    _currentPage = 1;
    _items.clear();
    _notify();
    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _notify();

    try {
      final newItems = await fetchNextPage();

      _items.addAll(newItems);
      _currentPage++;

      if (newItems.length < pageLimit) {
        _hasMore = false;
      }
    } catch (e) {
      _hasError = true;
      _notify();
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  void _notify() {
    if (!_hasDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _hasDisposed = true;
    super.dispose();
  }
}
