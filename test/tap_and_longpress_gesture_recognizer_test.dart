import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_memorization_helper/widgets/tap_and_longpress_gesture_recognizer.dart';

void main() {
  testWidgets('secondary click invokes long-press callback', (tester) async {
    int tapCount = 0;
    int longPressCount = 0;
    final recognizer = TapAndLongPressGestureRecognizer(
      onTap: () => tapCount++,
      onLongPress: () => longPressCount++,
      enableFeedback: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: RichText(
            text: TextSpan(
              text: 'ayah',
              style: const TextStyle(color: Colors.black),
              recognizer: recognizer,
            ),
          ),
        ),
      ),
    );

    final position = tester.getCenter(find.byType(RichText));
    final rightClick = await tester.startGesture(
      position,
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryButton,
    );
    await rightClick.up();
    await tester.pump();

    expect(tapCount, 0);
    expect(longPressCount, 1);

    await tester.pumpWidget(const SizedBox.shrink());
    recognizer.dispose();
  });
}