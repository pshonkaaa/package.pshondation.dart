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
  Range? _currentRenderedRange;

  final List<Range> _cachedRanges = [];
  final List<Range> _usageOrder = []; // Для отслеживания порядка использования

  Range get _availableRange => availableRangeRef.value;

  @override
  int size = 0;

  @override
  Future<void> updateVisibleRange(Range visibleRange) async {
    ensureNotDisposed();

    _currentVisibleRange = visibleRange;

    final batchRange = Range(
      visibleRange.start - batchSize,
      visibleRange.end + batchSize,
    ).clamp(_availableRange);

    await _manageCache(batchRange);

    if (disposed) {
      return;
    }

    _updateRenderRanges(batchRange);
  }

  Future<void> _manageCache(
    Range batchRange,
  ) async {
    // Определяем диапазоны, которые нужно загрузить
    final rangesToLoad = _calculateMissingRanges(batchRange, _cachedRanges);
    final sizeToLoad = _calculateRangesSize(rangesToLoad);

    // Удаляем лишние диапазоны, если превышен максимальный размер кеша
    while (size + sizeToLoad > maxCacheSize) {
      final sizeToDelete = sizeToLoad + size - maxCacheSize;
      final Range? oldestRange = _usageOrder.tryFirst;

      if (oldestRange != null) {
        if (sizeToDelete >= oldestRange.length) {
          _usageOrder.remove(oldestRange);
          _cachedRanges.remove(oldestRange);
          size -= oldestRange.length;

          await removeCallback(oldestRange);
        } else {
          final trimmedRange = Range(
            oldestRange.start + sizeToDelete,
            oldestRange.end,
          );

          _cachedRanges.remove(oldestRange);
          _cachedRanges.add(trimmedRange);
          _usageOrder[0] = trimmedRange;
          size -= sizeToDelete;

          await removeCallback(
            Range(oldestRange.start, trimmedRange.start),
          );
        }

        if (disposed) {
          return;
        }

      } else {
        // TODO сделать что-то при большом Range
        break;
      }

    }

    for (final range in rangesToLoad) {
      _cachedRanges.add(range);
      _usageOrder.add(range);
      size += range.length;

      await loadCallback(range);

      if (disposed) {
        return;
      }
    }
  }

  void _updateRenderRanges(Range batchRange) {
    final currentVisibleRange = _currentVisibleRange!;
    final currentRenderedRange = _currentRenderedRange;

    // final renderRange = Range(
    //   currentVisibleRange.start - preloadThreshold,
    //   currentVisibleRange.end + preloadThreshold,
    // ).clamp(_availableRange);

    if (currentRenderedRange != null) {
      final preloadRange = Range(
        currentVisibleRange.start - preloadThreshold,
        currentVisibleRange.end + preloadThreshold,
      ).clamp(_availableRange);
      
      if (currentRenderedRange.contains(preloadRange)) {
        return;
      }
    }

    final overlappingRanges = _cachedRanges
        .where((range) => range.overlapsWith(batchRange))
        .map((range) => range.clamp(batchRange))
        .toList();

    final mergedRanges = _mergeRanges(overlappingRanges);

    _currentRenderedRange = batchRange;

    onRenderRangeUpdated(mergedRanges);
  }

  @override
  void dispose() {
    super.dispose();
    _cachedRanges.clear();
    _usageOrder.clear();
  }
}

int _calculateRangesSize(List<Range> ranges) {
  return ranges.fold(0, (sum, range) => sum + range.length);
}

List<Range> _calculateMissingRanges(Range targetRange, List<Range> cachedRanges) {
  final List<Range> missingRanges = [];
  int currentStart = targetRange.start;

  for (final cachedRange in cachedRanges..sort((a, b) => a.start.compareTo(b.start))) {
    if (cachedRange.end < currentStart) {
      continue; // Диапазон позади текущего
    } else if (cachedRange.start > currentStart) {
      missingRanges.add(Range(currentStart, cachedRange.start));
    }

    if (cachedRange.end >= targetRange.end) {
      return missingRanges; // Все диапазоны покрыты
    }

    currentStart = cachedRange.end;
  }

  if (currentStart <= targetRange.end) {
    missingRanges.add(Range(currentStart, targetRange.end));
  }

  return missingRanges;
}

List<Range> _mergeRanges(List<Range> ranges) {
  if (ranges.isEmpty) return [];

  ranges.sort((a, b) => a.start.compareTo(b.start));

  final mergedRanges = <Range>[];
  var currentRange = ranges.first;

  for (var i = 1; i < ranges.length; i++) {
    final nextRange = ranges[i];

    final merged = currentRange.tryMerge(nextRange);
    if (merged != null) {
      currentRange = merged;
    } else {
      mergedRanges.add(currentRange);
      currentRange = nextRange;
    }
  }

  mergedRanges.add(currentRange);
  return mergedRanges;
}