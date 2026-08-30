import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_card.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_loading.dart';
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
    if (_selectedTab == 1) {
      await ref
          .read(momentsProvider.notifier)
          .refresh();
    }
  }

  void _changeTab(int index) {
    if (_selectedTab == index) {
      return;
    }

    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final momentsAsync = ref.watch(momentsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            MomentsTabHeader(
              selectedIndex: _selectedTab,
              onChanged: _changeTab,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 220,
                ),
                reverseDuration: const Duration(
                  milliseconds: 160,
                ),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder:
                    (child, animation) {
                  final offset =
                  _selectedTab == 0
                      ? const Offset(-0.04, 0)
                      : const Offset(0.04, 0);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: offset,
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _selectedTab == 0
                    ? KeyedSubtree(
                  key: const ValueKey(
                    'following',
                  ),
                  child: _followingState(),
                )
                    : KeyedSubtree(
                  key: const ValueKey(
                    'moments',
                  ),
                  child: RefreshIndicator(
                    color:
                    const Color(0xffA855F7),
                    backgroundColor:
                    const Color(0xff151522),
                    onRefresh: _refresh,
                    child: momentsAsync.when(
                      loading: () {
                        return const MomentLoading();
                      },
                      error: (
                          error,
                          stackTrace,
                          ) {
                        return _errorState();
                      },
                      data:
                          (List<Moment> moments) {
                        if (moments.isEmpty) {
                          return _emptyState();
                        }

                        return _buildMomentFeed(
                          moments,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMomentFeed(
      List<Moment> moments,
      ) {
    return ListView.builder(
      physics:
      const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 120,
      ),
      itemCount: moments.length,
      itemBuilder: (context, index) {
        final moment = moments[index];

        return TweenAnimationBuilder<double>(
          key: ValueKey(moment.id),
          tween: Tween<double>(
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
              ref
                  .read(
                momentsProvider.notifier,
              )
                  .deleteMoment(
                moment.id,
              );
            },
            onLike: () {
              ref
                  .read(
                momentsProvider.notifier,
              )
                  .toggleLike(
                moment,
              );
            },
            onComment: () {},
            onShare: () {
              ref
                  .read(
                momentsProvider.notifier,
              )
                  .incrementShares(
                moment.id,
              );
            },
            onSave: () {
              ref
                  .read(
                momentsProvider.notifier,
              )
                  .toggleSave(
                moment,
              );
            },
          ),
        );
      },
    );
  }

  Widget _followingState() {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.only(
        bottom: 120,
      ),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height *
              .28,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 46,
                  color: Colors.white24,
                ),
                SizedBox(height: 16),
                Text(
                  'Nothing here yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Moments from people you follow will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.only(
        bottom: 120,
      ),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height *
              .28,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  size: 46,
                  color: Colors.white24,
                ),
                SizedBox(height: 16),
                Text(
                  'No moments yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Share your first moment',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorState() {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.only(
        bottom: 120,
      ),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height *
              .28,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 44,
                  color: Colors.white24,
                ),
                SizedBox(height: 14),
                Text(
                  'Unable to load moments',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pull down to try again.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}