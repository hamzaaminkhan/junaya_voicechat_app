import 'package:flutter/material.dart';

class DraftsScreen extends StatelessWidget {
  const DraftsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff07070D),
      appBar: AppBar(
        backgroundColor: const Color(0xff07070D),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 22,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          'Drafts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: const _DraftsBody(),
    );
  }
}

class _DraftsBody extends StatelessWidget {
  const _DraftsBody();

  @override
  Widget build(BuildContext context) {
    // Temporary UI state.
    // Persistence will be connected during integration.
    const drafts = <_DraftItem>[];

    if (drafts.isEmpty) {
      return const _EmptyDrafts();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        30,
      ),
      itemCount: drafts.length,
      separatorBuilder: (_, __) =>
      const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _DraftCard(
          draft: drafts[index],
          onTap: () {},
          onDelete: () {},
        );
      },
    );
  }
}

class _EmptyDrafts extends StatelessWidget {
  const _EmptyDrafts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 36,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xff191923),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(.05),
                ),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: Color(0xffA855F7),
                size: 36,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No drafts yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Moments you start creating but don’t share will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff666675),
                fontSize: 13,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                  const Color(0xff8B5CF6),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(
                  Icons.add_rounded,
                  size: 19,
                ),
                label: const Text(
                  'Create a moment',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftCard extends StatelessWidget {
  final _DraftItem draft;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DraftCard({
    required this.draft,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff11111A),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _DraftThumbnail(
                path: draft.thumbnail,
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.caption.isEmpty
                          ? 'Untitled moment'
                          : draft.caption,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      draft.updatedLabel,
                      style: const TextStyle(
                        color: Color(0xff666675),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: onDelete,
                splashRadius: 20,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xff777787),
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftThumbnail extends StatelessWidget {
  final String? path;

  const _DraftThumbnail({
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xff191923),
        borderRadius: BorderRadius.circular(14),
      ),
      child: path == null || path!.isEmpty
          ? const Icon(
        Icons.auto_awesome_rounded,
        color: Color(0xff8B5CF6),
        size: 25,
      )
          : ClipRRect(
        borderRadius:
        BorderRadius.circular(14),
        child: Image.asset(
          path!,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) {
            return const Icon(
              Icons.image_outlined,
              color: Color(0xff777787),
            );
          },
        ),
      ),
    );
  }
}

class _DraftItem {
  final String? thumbnail;
  final String caption;
  final String updatedLabel;

  const _DraftItem({
    this.thumbnail,
    required this.caption,
    required this.updatedLabel,
  });
}