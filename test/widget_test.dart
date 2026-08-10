import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

void main() {
  test('auth palette keeps the Junaya gold accent', () {
    expect(AuthUi.gold, const Color(0xFFFFC94D));
    expect(AuthUi.goldButton, const Color(0xFFFFC83D));
  });
}
