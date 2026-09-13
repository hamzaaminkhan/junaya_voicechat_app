class StoreItem {


  final String name;

  /// PNG, JPG, GIF, or Lottie JSON path
  final String asset;


  /// true = Lottie JSON
  /// false = normal image
  final bool isLottie;


  final int price;

  final int duration;

  final String category;



  const StoreItem({

    required this.name,

    required this.asset,

    required this.isLottie,

    required this.price,

    required this.duration,

    required this.category,

  });


}