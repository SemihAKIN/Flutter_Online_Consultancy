import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../product/utility/agora_video_call_settings.dart';

class VideoCallService {
  Future<void> handleCameraAndMic(Permission permission) async {
    final status = permission.request();
    log(status.toString());
  }

  Future<String> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url = '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}';

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      return newToken;
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception('Failed to fetch a token. Make sure that your server URL is valid');
    }
  }
}
