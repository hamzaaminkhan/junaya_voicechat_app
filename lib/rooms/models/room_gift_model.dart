class RoomGift {
  final String id;
  final String name;
  final String? assetPath;

  /// Gift value / coin cost.
  final int price;

  /// Optional animation asset.
  final String? animationPath;

  final int order;
  final bool isActive;


  const RoomGift({
    this.id = '',
    required this.name,
    this.assetPath,
    this.price = 0,
    this.animationPath,
    this.order = 0,
    this.isActive = true,
  });


  // ============================================================
  // HELPERS
  // ============================================================

  bool get hasAsset {
    return assetPath != null &&
        assetPath!.trim().isNotEmpty;
  }

  bool get hasAnimation {
    return animationPath != null &&
        animationPath!.trim().isNotEmpty;
  }


  // ============================================================
  // COPY
  // ============================================================

  RoomGift copyWith({
    String? id,
    String? name,
    String? assetPath,
    int? price,
    String? animationPath,
    int? order,
    bool? isActive,
  }) {
    return RoomGift(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      price: price ?? this.price,
      animationPath:
      animationPath ?? this.animationPath,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }


  // ============================================================
  // JSON
  // ============================================================

  factory RoomGift.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoomGift(
      id:
      json['_id']?.toString() ??
          json['id']?.toString() ??
          '',

      name:
      json['name']?.toString() ??
          'Gift',

      assetPath:
      json['assetPath']?.toString(),

      price:
      _parseInt(
        json['price'],
      ),

      animationPath:
      json['animationPath']?.toString(),

      order:
      _parseInt(
        json['order'],
      ),

      isActive:
      json['isActive'] != false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'assetPath': assetPath,
      'price': price,
      'animationPath': animationPath,
      'order': order,
      'isActive': isActive,
    };
  }


  @override
  String toString() {
    return 'RoomGift('
        'id: $id, '
        'name: $name, '
        'price: $price, '
        'assetPath: $assetPath, '
        'animationPath: $animationPath, '
        'order: $order, '
        'isActive: $isActive'
        ')';
  }
}


int _parseInt(
    dynamic value, {
      int fallback = 0,
    }) {
  if (value is int) {
    return value;
  }

  return int.tryParse(
    value?.toString() ?? '',
  ) ??
      fallback;
}