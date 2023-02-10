import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

ButtonState stateOnlyText = ButtonState.idle;
ButtonState stateTextWithIcon = ButtonState.idle;

ProgressButton AnimatedBtn(String? idleText, onPressedIconWithText) {
  return ProgressButton.icon(iconedButtons: {
    ButtonState.idle: IconedButton(text: idleText, icon: Icon(Icons.send, color: Colors.white), color: Colors.deepPurple.shade500),
    ButtonState.loading: IconedButton(text: 'Loading', color: Colors.deepPurple.shade700),
    ButtonState.fail: IconedButton(text: 'Failed', icon: Icon(Icons.cancel, color: Colors.white), color: Colors.red.shade300),
    ButtonState.success: IconedButton(
        text: 'Success',
        icon: Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
        color: Colors.green.shade400)
  }, onPressed: onPressedIconWithText, state: stateTextWithIcon);
}
