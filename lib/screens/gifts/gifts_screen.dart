import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/space_background.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  static const List<Map<String, dynamic>> gifts = [
    {
      'name': 'Rose',
      'icon': Icons.local_florist_rounded,
      'price': 10,
      'color': Color(0xFFFF5B72),
    },
    {
      'name': 'Heart',
      'icon': Icons.favorite_rounded,
      'price': 25,
      'color': Color(0xFFFF4F9A),
    },
    {
      'name': 'Cake',
      'icon': Icons.cake_rounded,
      'price': 80,
      'color': Color(0xFFFFA23A),
    },
    {
      'name': 'Car',
      'icon': Icons.directions_car_rounded,
      'price': 500,
      'color': Color(0xFF47B9FF),
    },
    {
      'name': 'Castle',
      'icon': Icons.castle_rounded,
      'price': 1200,
      'color': Color(0xFF8E63FF),
    },
    {
      'name': 'Crown',
      'icon': Icons.workspace_premium_rounded,
      'price': 2500,
      'color': Color(0xFFFFC83D),
    },
    {
      'name': 'Rocket',
      'icon': Icons.rocket_launch_rounded,
      'price': 5000,
      'color': Color(0xFF56E39F),
    },
    {
      'name': 'Diamond',
      'icon': Icons.diamond_rounded,
      'price': 10000,
      'color': Color(0xFF4DE1FF),
    },
  ];

  void _showGiftAction(BuildContext context, String giftName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$giftName selected. Recipient flow can be connected next.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPurchaseHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase history is ready for backend integration.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRecharge(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recharge flow can be connected to Wallet.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SpaceBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: Column(
                  children: [
                    _buildBalanceCard(context),
                    _buildSectionHeader(),
                    Expanded(child: _buildGiftGrid()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: SizedBox(
        height: 46,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            Expanded(
              child: Text(
                'Store',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Purchase history',
              onPressed: () => _showPurchaseHistory(context),
              icon: const Icon(
                Icons.receipt_long_outlined,
                color: Colors.white70,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .09)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC83D).withValues(alpha: .14),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: const Color(0xFFFFC83D).withValues(alpha: .24),
              ),
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: Color(0xFFFFC83D),
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available balance',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '128,540 coins',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 34,
            child: OutlinedButton(
              onPressed: () => _showRecharge(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFFC83D),
                side: BorderSide(
                  color: const Color(0xFFFFC83D).withValues(alpha: .55),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Text(
                'Recharge',
                style: GoogleFonts.poppins(
                  fontSize: 10.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 9),
      child: Row(
        children: [
          Text(
            'Choose a gift',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${gifts.length} gifts',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns = constraints.maxWidth < 300 ? 1 : 2;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 26),
          itemCount: gifts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,

            // Fixed height = no RenderFlex overflow on different phones.
            mainAxisExtent: 156,
          ),
          itemBuilder: (context, index) {
            final gift = gifts[index];

            return _GiftCard(
              name: gift['name'] as String,
              icon: gift['icon'] as IconData,
              price: gift['price'] as int,
              color: gift['color'] as Color,
              onSend: () => _showGiftAction(context, gift['name'] as String),
            );
          },
        );
      },
    );
  }
}

class _GiftCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final int price;
  final Color color;
  final VoidCallback onSend;

  const _GiftCard({
    required this.name,
    required this.icon,
    required this.price,
    required this.color,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSend,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 11, 11, 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: Colors.white.withValues(alpha: .08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .11),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: color.withValues(alpha: .26)),
                    ),
                    child: Icon(icon, color: color, size: 23),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .045),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_rounded,
                          color: Color(0xFFFFC83D),
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '$price',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFFFC83D),
                            fontSize: 9.8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.2,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Send to someone special',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 9.5,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 30,
                child: OutlinedButton(
                  onPressed: onSend,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFC83D),
                    padding: EdgeInsets.zero,
                    side: BorderSide(
                      color: const Color(0xFFFFC83D).withValues(alpha: .34),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Send gift',
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
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
