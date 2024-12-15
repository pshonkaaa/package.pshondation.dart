import 'package:pshondation/src/library/private/features/range_cache_loader_impl.dart';
import 'package:test/test.dart';
import 'package:pshondation/library.dart';

void main() {
  group('RangeCacheLoader', () {
    late RangeCacheLoaderImpl cacheLoader;
    late List<Range> loadedRanges;
    late List<Range> removedRanges;
    late List<List<Range>> renderedRanges;

    setUpAll(() {
    });

    setUp(() {
      cacheLoader = RangeCacheLoader(
        availableRangeRef: ValueGetter(() => Range(0, 36000)),
        batchSize: 50,
        maxCacheSize: 1500,
        preloadThreshold: 50,
        loadCallback: (range) async {
          loadedRanges.add(range);
        },
        removeCallback: (range) async {
          removedRanges.add(range);
        },
        onRenderRangeUpdated: (ranges) {
          renderedRanges.add(ranges);
        }
      ) as RangeCacheLoaderImpl;

      loadedRanges = [];
      removedRanges = [];
      renderedRanges = [];
    });

    tearDown(() {
      cacheLoader.dispose();
    });

    test('Первый диапазон загружается с запасом (preloadThreshold)', () async {
      final visibleRange = Range(100, 200);
      await cacheLoader.updateVisibleRange(visibleRange);

      final expectedLoad = Range(50, 250);

      expect(loadedRanges, equals([expectedLoad]));
      expect(cacheLoader.debugCachedRanges, contains(expectedLoad));
    });

    test('Корректно обрабатывает переход к новому диапазону.', () async {
      final initialRange = Range(100, 200);
      final initialPreload = Range(50, 250);

      final jumpRange = Range(1000, 1150);
      final jumpPreload = Range(950, 1200);

      {
        await cacheLoader.updateVisibleRange(initialRange);

        expect(loadedRanges, equals([initialPreload]));
        expect(removedRanges, isEmpty);
        expect(cacheLoader.debugCachedRanges, contains(initialPreload));

        loadedRanges.clear();
        removedRanges.clear();
      }

      {
        await cacheLoader.updateVisibleRange(jumpRange);

        expect(loadedRanges, equals([jumpPreload]));
        expect(removedRanges, isEmpty);
        expect(cacheLoader.debugCachedRanges, contains(jumpPreload));

        // Старый диапазон 0-70 остается в кеше
        expect(cacheLoader.debugCachedRanges, equals([initialPreload, jumpPreload]));
        
        loadedRanges.clear();
        removedRanges.clear();
      }
    });

    test('Удаляет и обрезает самые старые диапазоны, когда размер кэша превышает максимальный', () async {
      await cacheLoader.updateVisibleRange(Range(0, 20));      // Загружаем 0-70      (70)
      await cacheLoader.updateVisibleRange(Range(300, 320));   // Загружаем 250-370   (120) = 190
      await cacheLoader.updateVisibleRange(Range(600, 620));   // Загружаем 550-670   (120) = 310
      await cacheLoader.updateVisibleRange(Range(900, 920));   // Загружаем 850-970   (120) = 430

      expect(removedRanges, isEmpty);
      
      await cacheLoader.updateVisibleRange(Range(1200, 2280)); // Загружаем 1150-2330 (1180) = 1610

      expect(removedRanges, equals([
        Range(0, 70),
        Range(250, 290),
      ]));
      
      expect(cacheLoader.debugCachedRanges, unorderedEquals([
        Range(290, 370),
        Range(550, 670),
        Range(850, 970),
        Range(1150, 2330),
      ]));
    });

    test('Корректно управляет кэшем с частично перекрывающимися диапазонами', () async {
      // Загружаем диапазон 0-70
      await cacheLoader.updateVisibleRange(Range(0, 20));
      
      // Загружаем диапазон 50-150 (частичное пересечение с предыдущим)
      await cacheLoader.updateVisibleRange(Range(70, 100));

      // Ожидаем, что общий диапазон 0-150 полностью в кеше
      final expectedRanges = [
        Range(0, 70),
        Range(70, 150),
      ];
      
      expect(loadedRanges, equals(expectedRanges));
      expect(cacheLoader.debugCachedRanges, equals(expectedRanges));
    });

    test('Корректно обновляет диапазоны рендеринга после изменения видимого диапазона', () async {
      // Начальный диапазон 200-300, с предзагрузкой 150-350
      final initialVisibleRange = Range(200, 300);
      final initialPreloadRange = Range(150, 350);

      // Новый диапазон 600-650, с предзагрузкой 550-700
      final jumpVisibleRange = Range(600, 650);
      final jumpPreloadRange = Range(550, 700);

      await cacheLoader.updateVisibleRange(initialVisibleRange);

      // Проверяем, что onRenderRangeUpdated вызван с диапазоном предзагрузки
      expect(renderedRanges, equals([[initialPreloadRange]]));
      renderedRanges.clear();

      // Обновляем видимый диапазон до jumpVisibleRange
      await cacheLoader.updateVisibleRange(jumpVisibleRange);

      // Проверяем, что onRenderRangeUpdated вызван с новым диапазоном предзагрузки
      expect(renderedRanges, equals([[jumpPreloadRange]]));
    });

    test('Корректно обрабатывает перекрывающиеся диапазоны', () async {
      // Устанавливаем видимый диапазон 200-300 с предзагрузкой 150-350
      final initialVisibleRange = Range(200, 300);
      final initialPreloadRange = Range(150, 350);

      // Новый диапазон пересекается с текущим кешем: 250-400
      final overlappingVisibleRange = Range(250, 400);
      final overlappingPreloadRange = Range(200, 450);

      // Устанавливаем начальный видимый диапазон
      await cacheLoader.updateVisibleRange(initialVisibleRange);

      // Проверяем, что onRenderRangeUpdated вызван с initialPreloadRange
      expect(renderedRanges, equals([[initialPreloadRange]]));
      renderedRanges.clear();

      // Устанавливаем перекрывающийся диапазон
      await cacheLoader.updateVisibleRange(overlappingVisibleRange);

      // Проверяем, что onRenderRangeUpdated корректно учитывает перекрытие
      expect(renderedRanges, equals([[overlappingPreloadRange]]));
    });
  });
}
