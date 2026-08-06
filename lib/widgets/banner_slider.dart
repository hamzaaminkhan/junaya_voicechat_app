import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  final List<String> banners;

  const BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  State<BannerSlider> createState() =>
      _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _controller =
  PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            physics: const PageScrollPhysics(),
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.banners[index],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
                (index) {
              return AnimatedContainer(
                duration:
                const Duration(milliseconds: 300),
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                width: currentIndex == index
                    ? 22
                    : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xFFFFC107)
                      : Colors.white
                      .withOpacity(.35),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}