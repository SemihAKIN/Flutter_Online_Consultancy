// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/video_call_service.dart';

import '../../../core/locater.dart';
import '../../../product/utility/agora_video_call_settings.dart';

class VideoCallPage extends StatefulWidget {
  final String channelName;
  const VideoCallPage({
    Key? key,
    required this.channelName,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final _users = <int>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;
  final VideoCallService _videoCallService = getIt<VideoCallService>();
  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        debugPrint("APP_ID is missing");
        debugPrint("Agora Engine is not starting");
      });
      return;
    }
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(appId: appId));
    await _engine.enableVideo();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileCommunication);
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    _addAgoraEventHandlers();
    final token =
        await _videoCallService.fetchToken(0, widget.channelName, tokenRole);
    await _engine.joinChannel(
        token: token,
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions());
  }

  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (err, msg) {
        setState(() {
          debugPrint('Error $err');
        });
      },
      onJoinChannelSuccess: (connection, elapsed) {
        setState(() {
          debugPrint('Local user Joined channel: ${connection.localUid}');
        });
      },
      onLeaveChannel: (connection, stats) {
        setState(() {
          debugPrint('Leave channel');
        });
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        setState(() {
          debugPrint("Remote user uid:$remoteUid joined the channel");
          _users.add(remoteUid);
        });
      },
      onUserOffline: (connection, remoteUid, reason) {
        setState(() {
          debugPrint("Remote user uid:$remoteUid left the channel");
          _users.remove(remoteUid);
        });
      },
      onFirstRemoteVideoFrame: (connection, remoteUid, width, height, elapsed) {
        setState(() {
          debugPrint("First Remote Video: $remoteUid $width x $height");
        });
      },
    ));
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    list.add(AgoraVideoView(
        controller: VideoViewController.remote(
      rtcEngine: _engine,
      canvas: const VideoCanvas(uid: 0),
      connection: RtcConnection(channelId: widget.channelName),
    )));
    for (var uid in _users) {
      list.add(AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      ));
    }
    return Column(
      children:
          List.generate(list.length, (index) => Expanded(child: list[index])),
    );
  }

  Widget _toolbar() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  muted = !muted;
                });
                _engine.muteLocalAudioStream(muted);
              },
              shape: const CircleBorder(),
              elevation: 2,
              fillColor: muted ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12),
              child: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: muted ? Colors.white : Colors.blueAccent,
                size: 20,
              ),
            ),
            RawMaterialButton(
              onPressed: () => Navigator.pop(context),
              shape: const CircleBorder(),
              elevation: 2,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  !muted;
                });
                _engine.switchCamera();
              },
              shape: const CircleBorder(),
              elevation: 2,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  viewPanel = !viewPanel;
                });
              },
              icon: const Icon(Icons.info_outline)),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Stack(
        children: [
          _viewRows(),
          _toolbar(),
        ],
      )),
    );
  }
}
