// Startup watchdog (2026-10-20 "stuck on splash" fix).
//
// The pre-runApp sequence in lib/main.dart is time-boxed; when a step never
// answers, the user must see a screen that names the step instead of the
// native splash forever. These tests pin the two screens that replace the
// splash and the exception text that carries the step name.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fkss_app/main.dart';

void main() {
  testWidgets('StartupStallApp names the stuck step and offers Retry',
      (tester) async {
    await tester.pumpWidget(const StartupStallApp(step: 'audio_service'));
    await tester.pump();

    expect(find.text('The app is taking too long to start'), findsOneWidget);
    expect(find.textContaining('Stuck at startup step: audio_service'),
        findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    // The reassurance every recovery screen in this app carries.
    expect(find.textContaining('has NOT been deleted'), findsOneWidget);
  });

  testWidgets('OfflineDataProtectionFailureApp switches copy when stalled',
      (tester) async {
    await tester.pumpWidget(const OfflineDataProtectionFailureApp(
      detail: 'Startup step "session_bootstrap" did not finish within 25s',
      stalled: true,
    ));
    await tester.pump();

    expect(find.text('The app could not finish starting'), findsOneWidget);
    expect(find.text('Offline storage could not be opened'), findsNothing);
    expect(find.textContaining('session_bootstrap'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
  });

  testWidgets('OfflineDataProtectionFailureApp keeps the storage copy otherwise',
      (tester) async {
    await tester.pumpWidget(const OfflineDataProtectionFailureApp(
      detail: 'DatabaseException(disk I/O error)',
    ));
    await tester.pump();

    expect(find.text('Offline storage could not be opened'), findsOneWidget);
    expect(find.text('The app could not finish starting'), findsNothing);
  });

  test('StartupStallException message carries step and limit', () {
    const e = StartupStallException('local_database', Duration(seconds: 20));
    expect(e.toString(),
        'Startup step "local_database" did not finish within 20s');
  });
}
