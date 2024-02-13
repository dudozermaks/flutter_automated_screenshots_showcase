import 'package:automated_screenshots/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// For makeScreenshot function
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void makeScreenshot(Widget w, String testName, String fileName,
    Function(WidgetTester) actions) {
  testWidgets(testName, (WidgetTester tester) async {
    // Change size of screen
    tester.view.physicalSize = const Size(1080 / 2, 1920 / 2);

    // Make flutter to simulate Android platform
    // This is done in order to get more Android-looking screenshots
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    // Adding widget to the test
    await tester.pumpWidget(w);

    // Waiting a little, so that flutter renders it
    // Might be unnecessary in your case
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    await actions(tester);

    // The golden test: Finding our app in the test by type, and
    // comparing it with previous screenshot
    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('screenshots/$fileName.png'),
    );

    // To prevent an error, setting this to null
    debugDefaultTargetPlatformOverride = null;
  });
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // If you have something async to setup, before running your app,
  // do it in this function
  setUpAll(() async {
    // Right here.
  });

  makeScreenshot(
    const MyApp(),
    "Default page",
    "default_page",
		// No need to do anything in test, simple home page screenshot
    (tester) => null,
  );

  makeScreenshot(
    const MyApp(),
    "Incremented page",
    "incremented_page",
    (tester) async {
			// finding button by Icon and tapping on it
			await tester.tap(find.byIcon(Icons.add));
			// waiting a little bit
			await tester.pumpAndSettle();
		},
  );
}
