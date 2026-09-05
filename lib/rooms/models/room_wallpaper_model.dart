class RoomWallpaper {
  final String id;
  final String name;
  final String assetPath;
  final bool isDefault;

  const RoomWallpaper({
    required this.id,
    required this.name,
    required this.assetPath,
    this.isDefault = false,
  });


  RoomWallpaper copyWith({
    String? id,
    String? name,
    String? assetPath,
    bool? isDefault,
  }) {
    return RoomWallpaper(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      isDefault: isDefault ?? this.isDefault,
    );
  }


  factory RoomWallpaper.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomWallpaper(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Wallpaper',
      assetPath: json['assetPath']?.toString() ?? '',
      isDefault: json['isDefault'] == true,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'assetPath': assetPath,
      'isDefault': isDefault,
    };
  }


  @override
  String toString() {
    return 'RoomWallpaper('
        'id: $id, '
        'name: $name, '
        'assetPath: $assetPath, '
        'isDefault: $isDefault'
        ')';
  }
}