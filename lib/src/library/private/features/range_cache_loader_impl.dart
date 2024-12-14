import 'dart:collection';

import 'package:pshondation/library.dart';
import 'package:pshondation/library_impl.dart';

class RangeCacheLoaderImpl extends BaseDisposable implements RangeCacheLoader {
  RangeCacheLoaderImpl({
    required this.availableRangeRef,
    required this.batchSize,
    required this.maxCacheSize,
    required this.preloadThreshold,
    required this.loadCallback,
    required this.removeCallback,
    required this.onRenderRangeUpdated,
  });

  final ValueGetter<Range> availableRangeRef;

  final int batchSize;

  final int maxCacheSize;

  final int preloadThreshold;

  final Future<void> Function(Range range) loadCallback;
  
  final Future<void> Function(Range range) removeCallback;

  final void Function(List<Range> ranges) onRenderRangeUpdated;

  List<Range> get debugCachedRanges => UnmodifiableListView(_cachedRanges);

  Range? _currentVisibleRange;
  final List<Range> _cachedRanges = [];
  final List<Range> _usageOrder = []; // Для отслеживания порядка использования

  Range get _availableRange => availableRangeRef.value;

  @override
  int size = 0;

  @override
  Future<void> updateVisibleRange(Range visibleRange) async {
    ensureNotDisposed();

    _currentVisibleRange = visibleRange;

    final renderRange = Range(
      visibleRange.start - preloadThreshold,
      visibleRange.end + preloadThreshold,
    ).clamp(_availableRange);

    final batchRange = Range(
      visibleRange.start - batchSize,
      visibleRange.end + batchSize,
    ).clamp(_availableRange);

    await _manageCache(renderRange, batchRange);

    if (disposed) {
      return;
    }

    // Обновляем видимые диапазоны
    _updateRenderRanges(renderRange);
  }

  Future<void> _manageCache(
    Range renderRange,
    Range batchRange,
  ) async {
    // TODO реализовать batchRange

    // Определяем диапазоны, которые нужно загрузить
    final rangesToLoad = _calculateMissingRanges(renderRange, _cachedRanges);

    final sizeToLoad = _calculateRangesSize(rangesToLoad);

    // Удаляем и/или обрезаем лишние диапазоны, если превышен максимальный размер кеша
    while (size + sizeToLoad > maxCacheSize) {
      final int sizeToDelete = sizeToLoad + size - maxCacheSize;
      
      Range? oldestRange = _usageOrder.tryFirst;
      if (oldestRange != null) {
        if (sizeToDelete > oldestRange.length) {
          _usageOrder.remove(oldestRange);
          _cachedRanges.remove(oldestRange);
          size -= oldestRange.length;

        } else {
          final newRange = Range(oldestRange.start + sizeToDelete, oldestRange.end);
          _usageOrder[0] = newRange;
          _cachedRanges.remove(oldestRange);
          _cachedRanges.add(newRange);
          size -= sizeToDelete;

          oldestRange = Range(oldestRange.start, newRange.start);
        }
        
        await removeCallback(oldestRange);

        if (disposed) {
          return;
        }
      }

      // TODO сделать что-то при большом Range
      break;
    }

    for (final range in rangesToLoad) {
      _cachedRanges.add(range);
      _usageOrder.add(range); // Добавляем в порядок использования
      size += range.length;

      await loadCallback(range);

      if (disposed) {
        return;
      }
    }
  }

  void _updateRenderRanges(Range renderRange) {
    // Находим пересечение между текущим видимым диапазоном и кешем
    final overlappingRanges = _cachedRanges
        .where((range) => range.overlapsWith(renderRange))
        .map((range) => range.clamp(renderRange))
        .toList();

    // Объединяем пересекающиеся или примыкающие диапазоны
    final mergedRanges = _mergeRanges(overlappingRanges);

    onRenderRangeUpdated(mergedRanges);
  }

  @override
  void dispose() {
    super.dispose();
    
    _cachedRanges.clear();
    _usageOrder.clear();
  }

  /// Вычисляет общий размер кеша, суммируя длины всех диапазонов.
  static int _calculateRangesSize(List<Range> ranges) {
    return ranges.fold(0, (sum, range) => sum + range.length);
  }
}



/// Вычисляет, какие диапазоны отсутствуют в кеше.
List<Range> _calculateMissingRanges(Range range, List<Range> otherRanges) {
  final List<Range> missingRanges = [];
  int start = range.start;

  for (final range in otherRanges) {
    if (range.overlapsWith(range)) {
      if (range.start > start) {
        missingRanges.add(Range(start, range.start - 1));
      }
      start = range.end;
    }
  }

  if (start <= range.end) {
    missingRanges.add(Range(start, range.end));
  }

  return missingRanges;
}

/// Объединяет пересекающиеся или примыкающие диапазоны в список непрерывных диапазонов.
List<Range> _mergeRanges(List<Range> ranges) {
  if (ranges.isEmpty) return [];

  // Сортируем диапазоны по началу
  ranges.sort((a, b) => a.start.compareTo(b.start));

  final mergedRanges = <Range>[];
  var currentRange = ranges.first;

  for (var i = 1; i < ranges.length; i++) {
    final nextRange = ranges[i];

    // Пытаемся объединить текущий диапазон с следующим
    final merged = currentRange.tryMerge(nextRange);
    if (merged != null) {
      currentRange = merged; // Объединили, продолжаем
    } else {
      mergedRanges.add(currentRange); // Завершаем текущий диапазон
      currentRange = nextRange; // Переходим к следующему
    }
  }

  // Добавляем последний диапазон
  mergedRanges.add(currentRange);

  return mergedRanges;
}