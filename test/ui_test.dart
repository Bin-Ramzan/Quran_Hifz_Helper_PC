// ignore_for_file: avoid_print
import "dart:io";

import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_memorization_helper/pages/main_page.dart';
import 'package:quran_memorization_helper/pages/marked_ayahs_page.dart';
import 'package:flutter/services.dart';
import 'package:quran_memorization_helper/quran_data/pages.dart';
import 'package:quran_memorization_helper/main.dart';
import 'package:quran_memorization_helper/models/settings.dart';
import 'package:quran_memorization_helper/widgets/read_quran.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = FakePath();
    wakelockPlusPlatformInstance = FakeWakelock();
    FakePath.deleteFiles();
  });

  tearDownAll(() {
    FakePath.deleteFiles();
  });

  testWidgets('Ui_Unit_Test', (tester) async {
    await tester.runAsync(() async {
      await tester.binding.setSurfaceSize(Size(600, 800));

      await tester.pumpWidget(const MyApp());

      final mainPageFinder = find.byType(MainPage);
      expect(mainPageFinder, findsOneWidget);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.byTooltip('Next page (Left Arrow)'), findsOneWidget);
      expect(find.byTooltip('Previous page (Right Arrow)'), findsOneWidget);
      expect(find.byTooltip(RegExp('Ctrl\\+D')), findsOneWidget);

      final state = tester.state<MainPageState>(mainPageFinder);
      print("Start await");
      await state.initialLoadFuture;
      print("End await");

      expect(state.model.bookmarks, isEmpty);
      expect(state.model.ayahs, isEmpty);
      expect(Settings.instance.mushaf, equals(Mushaf.Indopak16Line));

      await tester.pumpAndSettle();

      expect(Settings.instance.temporaryState.dualPage, equals(false));

      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);
      final pageView = tester.widget<PageView>(pageViewFinder);
      expect(pageView.controller, isNotNull);
      expect(pageView.controller!.page!.floor(), equals(0));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(1));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(0));

      const double speed = 8800;
      const double distance = 200;

      // swipe page
      print("Swipe forward 2 pages");
      await tester.fling(pageViewFinder, Offset((distance), 0), speed);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(1));

      await tester.fling(pageViewFinder, Offset((distance), 0), speed);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(2));

      print("Swipe back now");

      // swipe back
      print("swipe back to page 0");
      await tester.fling(pageViewFinder, Offset(-(distance), 0), speed);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(1));

      await tester.fling(pageViewFinder, Offset(-(distance), 0), speed);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(0));

      print("swipe back, go to last page");
      await tester.fling(pageViewFinder, Offset(-(distance), 0), speed);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(547));

      print("swipe forward again, go to page 0");
      await tester.fling(pageViewFinder, Offset((distance), 0), speed);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(0));

      print("Swipe forward 2 pages, test taping");
      await tester.fling(pageViewFinder, Offset((distance), 0), speed);
      await tester.pumpAndSettle();
      await tester.fling(pageViewFinder, Offset((distance), 0), speed);
      await tester.pumpAndSettle();
      expect(pageView.controller!.page!.floor(), equals(2));

      // tap once, should have a mistake
      Offset offset = Offset(200, 200);
      for (int i = 200; i < 500; i++) {
        offset = Offset(i.toDouble(), i.toDouble());
        await tester.tapAt(offset);
        if (state.model.ayahs.isNotEmpty) {
          print("Match at $i");
          break;
        }
      }
      expect(state.model.ayahs, isNotEmpty);

      // tap once more, mistake is removed
      await tester.tapAt(offset);
      expect(state.model.ayahs, isEmpty);

      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      expect(find.byType(PopupMenuItem<String>), findsAtLeast(7));
      expect(find.text('Settings (Ctrl+,)'), findsOneWidget);
      await tester.tap(find.text('Settings (Ctrl+,)'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsNothing);

      final rightClick = await tester.startGesture(
        offset,
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryButton,
      );
      await rightClick.up();
      await tester.pumpAndSettle();
      expect(find.byType(LongPressActionSheet), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(LongPressActionSheet), findsNothing);

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show Marked Ayahs'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.select_all));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byType(MarkedAyahsPage), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      pageView.controller!.jumpToPage(0);
      await tester.pumpAndSettle();

      print("Scroll through all pages");
      for (int i = 0; i < pageCount(Mushaf.Indopak16Line); ++i) {
        pageView.controller!.jumpToPage(i);
        await tester.pumpAndSettle();
        expect(pageView.controller!.page!.floor(), i);
      }

      await tester.binding.setSurfaceSize(Size(800, 500));
      await tester.pumpAndSettle();
      expect(Settings.instance.temporaryState.dualPage, equals(true));
      expect(find.byType(BottomAppBar), findsNothing);

      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.byType(BottomAppBar), findsOneWidget);
      final verticalScrollables = tester
          .stateList<ScrollableState>(find.byType(Scrollable))
          .where(
            (scrollable) =>
                scrollable.position.axisDirection == AxisDirection.down,
          );
      expect(verticalScrollables, isNotEmpty);
      expect(
        verticalScrollables.every(
          (scrollable) => scrollable.position.maxScrollExtent == 0,
        ),
        isTrue,
      );
      debugDefaultTargetPlatformOverride = null;

      print("Ui_Unit_Test Ok");
      state.model.timer?.cancel();
      await state.model.saveToDisk();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  });

  FakePath.deleteFiles();
}

class FakeWakelock extends WakelockPlusPlatformInterface {
  @override
  Future<void> toggle({required bool enable}) async {}

  @override
  Future<bool> get enabled async => false;
}

class FakePath extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return Directory.current.path;
  }

  static void deleteFiles() {
    final basePath = "${Directory.current.path}${Platform.pathSeparator}";
    void deleteFile(String path) {
      if (File(path).existsSync()) {
        File(path).deleteSync();
      }
    }

    print(basePath);
    deleteFile("${basePath}ayatsdb.json");
    deleteFile("${basePath}ayatsdb_new.json");
    deleteFile("${basePath}ayatsdb_bck.json");
  }
}
