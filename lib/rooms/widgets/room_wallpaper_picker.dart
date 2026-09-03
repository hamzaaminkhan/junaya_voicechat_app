import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomWallpaper {
  final String id;
  final String assetPath;
  final String name;

  const RoomWallpaper({
    required this.id,
    required this.assetPath,
    required this.name,
  });
}


// ============================================================
// ROOM WALLPAPER COLLECTION
// ============================================================

const List<RoomWallpaper> roomWallpapers = [
  RoomWallpaper(
    id: 'mralex',
    assetPath: 'assets/rooms/mralex.jpeg',
    name: 'Mr Alex',
  ),

  RoomWallpaper(
    id: 'room1',
    assetPath: 'assets/rooms/room1.jpeg',
    name: 'Royal',
  ),

  RoomWallpaper(
    id: 'room2',
    assetPath: 'assets/rooms/room2.jpeg',
    name: 'Luxury',
  ),

  RoomWallpaper(
    id: 'room3',
    assetPath: 'assets/rooms/room3.jpeg',
    name: 'Party',
  ),

  RoomWallpaper(
    id: 'room4',
    assetPath: 'assets/rooms/room4.jpeg',
    name: 'Romance',
  ),

  RoomWallpaper(
    id: 'room5',
    assetPath: 'assets/rooms/room5.jpeg',
    name: 'Cute',
  ),

  RoomWallpaper(
    id: 'room6',
    assetPath: 'assets/rooms/room6.jpeg',
    name: 'Cars',
  ),

  RoomWallpaper(
    id: 'room7',
    assetPath: 'assets/rooms/room7.jpeg',
    name: 'Palace',
  ),

  RoomWallpaper(
    id: 'room8',
    assetPath: 'assets/rooms/room8.jpeg',
    name: 'Sunset',
  ),
];


// ============================================================
// WALLPAPER PICKER
// ============================================================

class RoomWallpaperPicker extends StatelessWidget {
  final String selectedWallpaperId;

  final ValueChanged<RoomWallpaper> onWallpaperSelected;

  const RoomWallpaperPicker({
    super.key,
    required this.selectedWallpaperId,
    required this.onWallpaperSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF160523),

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      child: SafeArea(
        top: false,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            18,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              // ==================================================
              // HANDLE
              // ==================================================

              Container(
                width: 42,
                height: 4,

                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // TITLE
              // ==================================================

              Row(
                children: [

                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: const Color(0xFF7B2BFF)
                          .withValues(alpha: .18),

                      borderRadius:
                      BorderRadius.circular(13),

                      border: Border.all(
                        color: const Color(0xFF9E55FF)
                            .withValues(alpha: .35),
                      ),
                    ),

                    child: const Icon(
                      Icons.wallpaper_rounded,
                      color: Color(0xFFD49AFF),
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Room Wallpaper',

                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          'Choose a background for your room',

                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ==================================================
              // WALLPAPER GRID
              // ==================================================

              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,

                  physics:
                  const BouncingScrollPhysics(),

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,

                    crossAxisSpacing: 12,

                    mainAxisSpacing: 14,

                    childAspectRatio: .56,
                  ),

                  itemCount: roomWallpapers.length,

                  itemBuilder:
                      (context, index) {

                    final wallpaper =
                    roomWallpapers[index];

                    final selected =
                        wallpaper.id ==
                            selectedWallpaperId;

                    return _WallpaperTile(
                      wallpaper: wallpaper,

                      selected: selected,

                      onTap: () {
                        onWallpaperSelected(
                          wallpaper,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// WALLPAPER TILE
// ============================================================

class _WallpaperTile extends StatelessWidget {
  final RoomWallpaper wallpaper;

  final bool selected;

  final VoidCallback onTap;

  const _WallpaperTile({
    required this.wallpaper,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),

        curve: Curves.easeOut,

        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(15),

          border: Border.all(
            color: selected
                ? const Color(0xFFD05CFF)
                : Colors.white.withValues(
              alpha: .12,
            ),

            width: selected ? 2.2 : 1,
          ),

          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFFB12CFF)
                  .withValues(alpha: .35),

              blurRadius: 12,

              spreadRadius: 1,
            ),
          ]
              : null,
        ),

        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(13),

          child: Stack(
            fit: StackFit.expand,

            children: [

              // =================================================
              // WALLPAPER
              // =================================================

              Image.asset(
                wallpaper.assetPath,

                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF2B123F),

                    alignment:
                    Alignment.center,

                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white38,
                      size: 30,
                    ),
                  );
                },
              ),

              // =================================================
              // BOTTOM GRADIENT
              // =================================================

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,

                child: Container(
                  height: 60,

                  decoration: BoxDecoration(
                    gradient:
                    LinearGradient(
                      begin:
                      Alignment.topCenter,

                      end:
                      Alignment.bottomCenter,

                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(
                          alpha: .82,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // =================================================
              // NAME
              // =================================================

              Positioned(
                left: 9,
                right: 8,
                bottom: 9,

                child: Text(
                  wallpaper.name,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  GoogleFonts.poppins(
                    color: Colors.white,

                    fontSize: 11.5,

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

              // =================================================
              // SELECTED CHECK
              // =================================================

              if (selected)
                Positioned(
                  top: 8,
                  right: 8,

                  child: Container(
                    width: 27,
                    height: 27,

                    decoration:
                    const BoxDecoration(
                      shape: BoxShape.circle,

                      gradient:
                      LinearGradient(
                        colors: [
                          Color(0xFFE95DFF),
                          Color(0xFF7D32FF),
                        ],
                      ),
                    ),

                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}