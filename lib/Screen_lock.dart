import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:smartlightapp/ControlLight.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  var storedPasscode = '123456';
  bool isAuthenticated = false;

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Welcome to the App"),
      centerTitle: true,
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'images/USM.png',
          width: 150,
        ),
        
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  defaulpasscode(context);
                },
                child: Text("OPEN APP"),
              ),
              SizedBox(height: 20),
              _buildPasscodeRestoreButton(),
            ],
          ),
        ),
      ],
    ),
  );
}


  void defaulpasscode(BuildContext context) {
    _showLockScreen(
      context,
      opaque: false,
      cancelButton: Text(
        'Cancel',
        style: const TextStyle(fontSize: 16, color: Colors.white),
        semanticsLabel: 'Cancel',
      ),
    );
  }

  void _showLockScreen(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
          title: Text(
            'Enter App Passcode',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          circleUIConfig: circleUIConfig,
          keyboardUIConfig: keyboardUIConfig,
          passwordEnteredCallback: _onPasscodeEntered,
          cancelButton: cancelButton,
          deleteButton: Text(
            'Delete',
            style: const TextStyle(fontSize: 16, color: Colors.white),
            semanticsLabel: 'Delete',
          ),
          shouldTriggerVerification: _verificationNotifier.stream,
          backgroundColor: Colors.black.withOpacity(0.8),
          cancelCallback: _onPasscodeCancelled,
          digits: digits,
          passwordDigits: 6,
          bottomWidget: _buildPasscodeRestoreButton(),
        ),
      ),
    );
  }

  _onPasscodeEntered(String enteredPasscode) async {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });

      // Delay the navigation to allow screen transition to complete
      await Future.delayed(Duration(milliseconds: 500)); // Adjust the duration as needed

      // Navigate to the desired screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ControlLight(),
        ),
      );
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  _buildPasscodeRestoreButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5.0, top: 20.0),
          child: TextButton(
            child: Text(""),
            onPressed: _resetAppPassword,
          ),
        ),
      );

  _resetAppPassword() {
    // Implementation for resetting app password
  }
}
