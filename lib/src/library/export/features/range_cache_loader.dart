import 'dart:async';
import 'dart:collection';

import 'package:pshondation/library.dart';
import 'package:pshondation/library_impl.dart';

import '../../private/features/range_cache_loader_impl.dart';

/// [RangeCacheLoader] предназначен для управления загрузкой и кэшированием данных,
/// которые необходимо отображать на экране.
///
/// Основные возможности:
/// - Управление диапазоном доступных элементов для загрузки.
/// - Автоматическая подгрузка данных при обновлении диапазона видимых элементов.
/// - Ограничение максимального размера кэша для предотвращения
///   избыточного потребления памяти.
/// - Поддержка предзагрузки данных (prefetch), чтобы заранее подготовить
///   элементы для отображения.
/// - Асинхронные коллбэки для загрузки и удаления данных.
///
/// Пример использования:
/// ```dart
/// final cacheLoader = RangeCacheLoader<int>(
///   availableRange: ValueGetter(() => Range(199, 1000)),
///   batchSize: 50,
///   maxCacheSize: 200,
///   prefetchThreshold: 20,
///   loadCallback: (range) async {
///     // TODO
///   },
///   removeCallback: (range) async {
///     // TODO
///   },
/// );
///
/// await cacheLoader.updateVisibleRange(Range(100, 150)); // Обновление видимого диапазона
/// cacheLoader.dispose(); // Очистка ресурсов
/// ```
abstract class RangeCacheLoader implements Disposable {
  
  /// - [availableRangeRef] — диапазон доступных элементов, которые могут быть загружены.
  /// - [batchSize] — количество элементов, запрашиваемых за одну операцию загрузки.
  /// - [maxCacheSize] — максимальное количество элементов, которые могут быть закэшированы.
  /// - [preloadThreshold] — количество элементов до конца текущего видимого диапазона,
  ///   при котором будет инициирована предзагрузка.
  /// - [loadCallback] — асинхронная функция для загрузки данных в указанный диапазон.
  /// - [removeCallback] — асинхронная функция для удаления данных из указанного диапазона.
  /// // TODO обновить описание
  factory RangeCacheLoader({
    required ValueGetter<Range> availableRangeRef,
    required int batchSize,
    required int maxCacheSize,
    required int preloadThreshold,
    required Future<void> Function(Range range) loadCallback,
    required Future<void> Function(Range range) removeCallback,
    required void Function(List<Range> ranges) onRenderRangeUpdated,
  }) = RangeCacheLoaderImpl;

  // Текущий размер кеша.
  int get size;

  Future<void> updateVisibleRange(Range range);
}