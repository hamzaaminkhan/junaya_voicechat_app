import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_card.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moments_tab_header.dart';

class MomentsScreen extends ConsumerStatefulWidget {
  const MomentsScreen({
    super.key,
  });

  @override
  ConsumerState<MomentsScreen> createState() =>
      _MomentsScreenState();
}

class _MomentsScreenState
    extends ConsumerState<MomentsScreen> {
  int _selectedTab = 1;

  Future<void> _refresh() async {
    await ref
        .read(momentsProvider.notifier)
        .refresh();
  }

  @override
  Widget build(BuildContext context) {
    final momentsAsync = ref.watch(momentsProvider);

    return Scaffold(
      backgroundColor: const Color(0xff07070D),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopHeader(),

            MomentsTabHeader(
              selectedIndex: _selectedTab,
              onChanged: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),

            Expanded(
              child: _buildBody(momentsAsync),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        14,
        2,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Moments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -.4,
              ),
            ),
          ),

          _HeaderButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),

          const SizedBox(width: 7),

          _HeaderButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      AsyncValue<List<Moment>> momentsAsync,
      ) {
    return RefreshIndicator(
      color: const Color(0xffA855F7),
      backgroundColor: const Color(0xff191923),
      displacement: 18,
      onRefresh: _refresh,
      child: _selectedTab == 0
          ? _followingState()
          : momentsAsync.when(
        loading: _loadingState,
        error: _errorState,
        data: _momentsState,
      ),
    );
  }

  Widget _momentsState(
      List<Moment> moments,
      ) {
    if (moments.isEmpty) {
      return _emptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 110,
      ),
      itemCount: moments.length,
      itemBuilder: (context, index) {
        return _animatedCard(
          moments[index],
          index,
        );
      },
    );
  }

  Widget _animatedCard(
      Moment moment,
      int index,
      ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: Duration(
        milliseconds: 220 + (index * 35),
      ),
      curve: Curves.easeOutCubic,
      builder: (
          context,
          value,
          child,
          ) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              10 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: MomentCard(
        moment: moment,
        onDelete: () {
          _deleteMoment(moment);
        },
        onLike: () {
          _toggleLike(moment);
        },
        onComment: () {},
        onShare: () {
          _shareMoment(moment);
        },
        onSave: () {
          _toggleSave(moment);
        },
      ),
    );
  }

  Widget _loadingState() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 100,
      ),
      itemCount: 3,
      itemBuilder: (_, index) {
        return const _MomentSkeleton();
      },
    );
  }

  Widget _emptyState() {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height * .27,
        ),

        const _EmptyIcon(
          icon: Icons.auto_awesome_rounded,
        ),

        const SizedBox(height: 18),

        const Text(
          'No moments yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Share something with your community.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff666675),
            fontSize: 13,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: _CreateButton(
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _followingState() {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height * .27,
        ),

        const _EmptyIcon(
          icon: Icons.people_outline_rounded,
        ),

        const SizedBox(height: 18),

        const Text(
          'Nothing from your following',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Moments from people you follow will '
              'appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff666675),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _errorState(
      Object error,
      StackTrace stack,
      ) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height * .27,
        ),

        const _EmptyIcon(
          icon: Icons.cloud_off_rounded,
        ),

        const SizedBox(height: 18),

        const Text(
          'Unable to load moments',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Something went wrong. Pull down to try again.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff666675),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _deleteMoment(Moment moment) {
    // Final integration pass.
  }

  void _toggleLike(Moment moment) {
    // Final integration pass.
  }

  void _toggleSave(Moment moment) {
    // Final integration pass.
  }

  void _shareMoment(Moment moment) {
    // Final integration pass.
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff11111A),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: const Color(0xffB8B8C8),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _EmptyIcon extends StatelessWidget {
  final IconData icon;

  const _EmptyIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xff151522),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white30,
          size: 29,
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff8B5CF6),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 11,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 19,
              ),
              SizedBox(width: 6),
              Text(
                'Create moment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MomentSkeleton extends StatelessWidget {
  const _MomentSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SkeletonBox(
                  width: 44,
                  height: 44,
                  radius: 22,
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(
                        width: 120,
                        height: 11,
                      ),
                      SizedBox(height: 8),
                      _SkeletonBox(
                        width: 85,
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _SkeletonBox(
              width: double.infinity,
              height: 13,
            ),
            const SizedBox(height: 8),
            const _SkeletonBox(
              width: 210,
              height: 13,
            ),
            const SizedBox(height: 18),
            const Expanded(
              child: _SkeletonBox(
                width: double.infinity,
                height: double.infinity,
                radius: 18,
              ),
            ),
          ],
        ),
      ),
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
    this.radius = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius:
        BorderRadius.circular(radius),
      ),
    );
  }
}