import 'package:flutter/material.dart';

class VoiceNoteTile extends StatefulWidget {
  const VoiceNoteTile({
    super.key,
  });

  @override
  State<VoiceNoteTile> createState() =>
      _VoiceNoteTileState();
}

class _VoiceNoteTileState
    extends State<VoiceNoteTile> {

  bool _recording = false;
  Duration _duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top:12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        children: [

          Row(
            children: [

              Container(
                width:42,
                height:42,
                decoration: BoxDecoration(
                  color: const Color(0xffA855F7)
                      .withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Color(0xffA855F7),
                  size:22,
                ),
              ),

              const SizedBox(width:12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Voice note",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:15,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    SizedBox(height:3),

                    Text(
                      "Add your voice to this moment",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize:13,
                      ),
                    ),

                  ],
                ),
              ),

              GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds:200,
                  ),
                  width:44,
                  height:44,
                  decoration: BoxDecoration(
                    color: _recording
                        ? const Color(0xffFF3B7A)
                        : const Color(0xffA855F7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _recording
                        ? Icons.stop_rounded
                        : Icons.mic_rounded,
                    color: Colors.white,
                    size:22,
                  ),
                ),
              ),

            ],
          ),

          if(_recording ||
              _duration.inSeconds > 0)
            Padding(
              padding:
              const EdgeInsets.only(
                top:16,
              ),
              child: Row(
                children: [

                  Text(
                    _formatDuration(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize:13,
                    ),
                  ),

                  const SizedBox(width:12),

                  Expanded(
                    child: _waveform(),
                  ),

                ],
              ),
            ),

        ],
      ),
    );
  }


  void _toggleRecording() {
    setState(() {
      _recording = !_recording;

      if(_recording) {
        _duration =
        const Duration(seconds:1);
      }
    });

    // Audio recording implementation later
  }


  String _formatDuration() {
    final seconds =
    _duration.inSeconds
        .toString()
        .padLeft(2,'0');

    return "00:$seconds";
  }


  Widget _waveform() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: List.generate(
        22,
            (index) {
          return Container(
            width:3,
            height:
            8 + (index % 5) * 4,
            decoration: BoxDecoration(
              color:
              const Color(0xffA855F7),
              borderRadius:
              BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}