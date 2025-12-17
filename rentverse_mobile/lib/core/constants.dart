import 'dart:io';

// 10.0.2.2 is the special IP Android Emulators use to see your computer's localhost
// ignore: non_constant_identifier_names
String get API_URL {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:3000/api'; 
  } else {
    return 'http://localhost:3000/api';
  }
}