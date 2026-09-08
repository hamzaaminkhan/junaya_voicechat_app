import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// ============================================================
// ROOM SEAT LIMITS
// ============================================================

class RoomSeatLimits {
  static const int min = 1;

  static const int defaultCount = 15;

  static const int max = 25;


  static int normalize(int? value) {
    final count =
        value ?? defaultCount;

    return count.clamp(
      min,
      max,
    );
  }
}


// ============================================================
// ROOM SEAT COUNT PICKER
// ============================================================

class RoomSeatCountPicker
    extends StatefulWidget {

  final int initialValue;

  const RoomSeatCountPicker({
    super.key,
    required this.initialValue,
  });


  @override
  State<RoomSeatCountPicker> createState() {
    return _RoomSeatCountPickerState();
  }
}


// ============================================================
// STATE
// ============================================================

class _RoomSeatCountPickerState
    extends State<RoomSeatCountPicker> {

  static const Color _purple =
  Color(0xFFA84CF4);

  static const Color _gold =
  Color(0xFFFFD84D);

  late int _value;


  @override
  void initState() {
    super.initState();

    _value =
        RoomSeatLimits.normalize(
          widget.initialValue,
        );
  }


  // ==========================================================
  // CHANGE VALUE
  // ==========================================================

  void _setValue(int value) {

    final normalized =
    value.clamp(
      RoomSeatLimits.min,
      RoomSeatLimits.max,
    );


    if (normalized == _value) {
      return;
    }


    setState(() {
      _value = normalized;
    });
  }


  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        24,
      ),

      decoration: const BoxDecoration(
        color: Color(0xFF210444),

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),

      child: SafeArea(
        top: false,

        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [

            // --------------------------------------------------
            // HANDLE
            // --------------------------------------------------

            Container(
              width: 42,
              height: 4,

              decoration:
              BoxDecoration(
                color: Colors.white24,

                borderRadius:
                BorderRadius.circular(10),
              ),
            ),


            const SizedBox(
              height: 18,
            ),


            // --------------------------------------------------
            // TITLE
            // --------------------------------------------------

            Text(
              'Number of Mic Seats',

              style:
              GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight:
                FontWeight.w600,
              ),
            ),


            const SizedBox(
              height: 6,
            ),


            Text(
              'Choose between 1 and 25 seats',

              style:
              GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 11,
              ),
            ),


            const SizedBox(
              height: 24,
            ),


            // --------------------------------------------------
            // MINUS / NUMBER / PLUS
            // --------------------------------------------------

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                _roundButton(
                  icon:
                  Icons.remove_rounded,

                  enabled:
                  _value >
                      RoomSeatLimits.min,

                  onTap: () {
                    _setValue(
                      _value - 1,
                    );
                  },
                ),


                const SizedBox(
                  width: 28,
                ),


                // ----------------------------------------------
                // CURRENT VALUE
                // ----------------------------------------------

                Column(
                  children: [

                    Text(
                      '$_value',

                      style:
                      GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),


                    Text(
                      'MIC SEATS',

                      style:
                      GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),


                    if (_value ==
                        RoomSeatLimits
                            .defaultCount)

                      Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 4,
                        ),

                        child: Text(
                          'DEFAULT',

                          style:
                          GoogleFonts.poppins(
                            color: _gold,
                            fontSize: 9,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),


                const SizedBox(
                  width: 28,
                ),


                _roundButton(
                  icon:
                  Icons.add_rounded,

                  enabled:
                  _value <
                      RoomSeatLimits.max,

                  onTap: () {
                    _setValue(
                      _value + 1,
                    );
                  },
                ),
              ],
            ),


            const SizedBox(
              height: 22,
            ),


            // --------------------------------------------------
            // SLIDER
            // --------------------------------------------------

            Slider(
              value:
              _value.toDouble(),

              min:
              RoomSeatLimits.min
                  .toDouble(),

              max:
              RoomSeatLimits.max
                  .toDouble(),

              divisions:
              RoomSeatLimits.max -
                  RoomSeatLimits.min,

              activeColor:
              _purple,

              inactiveColor:
              Colors.white12,

              thumbColor:
              Colors.white,

              onChanged: (value) {
                _setValue(
                  value.round(),
                );
              },
            ),


            // --------------------------------------------------
            // RANGE LABELS
            // --------------------------------------------------

            Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

              children: [

                _rangeLabel('1'),

                _rangeLabel('15'),

                _rangeLabel('25'),
              ],
            ),


            const SizedBox(
              height: 20,
            ),


            // --------------------------------------------------
            // APPLY
            // --------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 48,

              child:
              ElevatedButton(
                onPressed: () {

                  Navigator.pop(
                    context,
                    _value,
                  );
                },

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  _purple,

                  foregroundColor:
                  Colors.white,

                  elevation: 0,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                child: Text(
                  'Apply',

                  style:
                  GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ==========================================================
  // ROUND BUTTON
  // ==========================================================

  Widget _roundButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap:
        enabled
            ? onTap
            : null,

        borderRadius:
        BorderRadius.circular(28),

        child: Container(
          width: 52,
          height: 52,

          decoration:
          BoxDecoration(
            shape: BoxShape.circle,

            color:
            _purple.withValues(
              alpha:
              enabled
                  ? .18
                  : .07,
            ),

            border:
            Border.all(
              color:
              _purple.withValues(
                alpha:
                enabled
                    ? .45
                    : .15,
              ),
            ),
          ),

          child: Icon(
            icon,

            color:
            enabled
                ? Colors.white
                : Colors.white24,

            size: 22,
          ),
        ),
      ),
    );
  }


  // ==========================================================
  // RANGE LABEL
  // ==========================================================

  Widget _rangeLabel(
      String text,
      ) {

    return Text(
      text,

      style:
      GoogleFonts.poppins(
        color: Colors.white38,
        fontSize: 10,
      ),
    );
  }
}