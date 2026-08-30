// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MomentLoading extends StatelessWidget {
  const MomentLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 120,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(
            12,
            8,
            12,
            10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xff0D0D14),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(.05),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  12,
                ),
                child: Row(
                  children: [
                    _SkeletonBox(
                      width: 48,
                      height: 48,
                      radius: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _SkeletonBox(
                            width: 110,
                            height: 12,
                            radius: 6,
                          ),
                          const SizedBox(height: 8),
                          _SkeletonBox(
                            width: 82,
                            height: 9,
                            radius: 5,
                          ),
                        ],
                      ),
                    ),
                    _SkeletonBox(
                      width: 24,
                      height: 24,
                      radius: 12,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  2,
                  16,
                  14,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(
                      width: double.infinity,
                      height: 10,
                      radius: 5,
                    ),
                    const SizedBox(height: 7),
                    _SkeletonBox(
                      width: 210,
                      height: 10,
                      radius: 5,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(22),
                  child: const AspectRatio(
                    aspectRatio: 1.15,
                    child: _SkeletonBox(
                      width: double.infinity,
                      height: double.infinity,
                      radius: 0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  18,
                ),
                child: Row(
                  children: [
                    _SkeletonBox(
                      width: 58,
                      height: 20,
                      radius: 10,
                    ),
                    const SizedBox(width: 24),
                    _SkeletonBox(
                      width: 58,
                      height: 20,
                      radius: 10,
                    ),
                    const SizedBox(width: 24),
                    _SkeletonBox(
                      width: 58,
                      height: 20,
                      radius: 10,
                    ),
                    const Spacer(),
                    _SkeletonBox(
                      width: 25,
                      height: 25,
                      radius: 12,
                    ),
                    const SizedBox(width: 22),
                    _SkeletonBox(
                      width: 25,
                      height: 25,
                      radius: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xff20202B),
        borderRadius:
        BorderRadius.circular(radius),
      ),
    );
  }
}