import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(AudioBoosterApp());
}

class AudioBoosterApp extends StatefulWidget {
  @override
  _AudioBoosterAppState createState() => _AudioBoosterAppState();
}

class _AudioBoosterAppState extends State<AudioBoosterApp> {
  static const platform = MethodChannel('com.mmarciano.nobs_audio_booster/dsp');
  double boostLevel = 1000;
  bool isBoostActive = false;

  final Uri _url = Uri.parse('https://buymeacoffee.com/mmarciano');

  Future<void> launchDonationPage() async {
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }

  Future<void> setBoostLevel(double level) async {
    try {
      await platform.invokeMethod('setBoostLevel', {'level': level.toInt()});
    } on PlatformException catch (e) {}
  }

  Future<void> toggleBoost(bool isActive) async {
    try {
      if (isActive) {
        await setBoostLevel(boostLevel);
      } else {
        await platform.invokeMethod('resetBoost');
      }
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoBS Audio Booster',
      home: Scaffold(
        appBar: AppBar(title: Text('NoBS Audio Booster')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Volume boost level"),
              Slider(
                value: boostLevel,
                min: 0,
                max: 8000,
                divisions: 40,
                onChanged: (value) {
                  setState(() {
                    boostLevel = value;
                  });
                  if (isBoostActive) {
                    setBoostLevel(value);
                  }
                },
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text('Enable/Disable boost'),
                value: isBoostActive,
                onChanged: (value) {
                  setState(() {
                    isBoostActive = value;
                  });
                  toggleBoost(value);
                },
              ),
              Spacer(),
              Text(
                'This app is completely free for use, it will never have any ads or paid feature. If you want to show some support, feel free to click the link below. Simple software should be free  🏴‍☠️',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: launchDonationPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.amber, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.coffee, color: Colors.white), // Icona di caffè
                    SizedBox(width: 8),
                    Text(
                      'Buy Me a Coffee',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
