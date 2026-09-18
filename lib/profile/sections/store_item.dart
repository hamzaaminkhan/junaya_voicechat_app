class StoreItem {

  final String name;

  /// Local asset path or network URL.
  final String asset;

  /// Asset type:
  /// SVGA, Lottie, SVG, PNG, JPG, JPEG
  final String assetType;

  final int price;

  final int duration;

  final String category;


  const StoreItem({

    required this.name,

    required this.asset,

    required this.assetType,

    required this.price,

    required this.duration,

    required this.category,

  });

}