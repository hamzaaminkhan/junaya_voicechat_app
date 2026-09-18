import 'store_item.dart';


class StoreData {

  static const List<StoreItem> items = [


    // ======================================================
    // ENTRANCE
    // ======================================================

    StoreItem(
      name: 'Royal Entry',
      asset: 'assets/store/entrance/entrance_1.json',
      assetType: 'Lottie',
      price: 120000,
      duration: 7,
      category: 'Entrance',
    ),


    // ======================================================
    // FRAMES
    // ======================================================

    StoreItem(
      name: 'Frame',
      asset: 'assets/store/frames/frame1.svga',
      assetType: 'SVGA',
      price: 15000,
      duration: 7,
      category: 'Frame',
    ),

    StoreItem(
      name: 'Rich Man',
      asset: 'assets/store/frames/frame2.svga',
      assetType: 'SVGA',
      price: 250000,
      duration: 7,
      category: 'Frame',
    ),

    StoreItem(
      name: 'Blue Shield',
      asset: 'assets/store/frames/frame3.svga',
      assetType: 'SVGA',
      price: 300000,
      duration: 7,
      category: 'Frame',
    ),

    StoreItem(
      name: 'Golden Frame',
      asset: 'assets/store/frames/frame4.svga',
      assetType: 'SVGA',
      price: 98000,
      duration: 7,
      category: 'Frame',
    ),


    // ======================================================
    // BUBBLE CHAT
    // ======================================================

    StoreItem(
      name: 'Love Bubble',
      asset: 'assets/store/bubbles/bubble1.json',
      assetType: 'Lottie',
      price: 30000,
      duration: 7,
      category: 'Bubble Chat',
    ),

    StoreItem(
      name: 'VIP Bubble',
      asset: 'assets/store/bubbles/bubble2.json',
      assetType: 'Lottie',
      price: 90000,
      duration: 7,
      category: 'Bubble Chat',
    ),


    // ======================================================
    // THEMES
    // ======================================================

    StoreItem(
      name: 'Galaxy',
      asset: 'assets/store/themes/theme1.png',
      assetType: 'PNG',
      price: 50000,
      duration: 30,
      category: 'Theme',
    ),

    StoreItem(
      name: 'Royal Theme',
      asset: 'assets/store/themes/theme2.png',
      assetType: 'PNG',
      price: 150000,
      duration: 30,
      category: 'Theme',
    ),

  ];

}