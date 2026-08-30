import 'package:flutter/material.dart';

class MediaPreview extends StatefulWidget {
  final List<String> media;
  final int maxMedia;
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;
  final ValueChanged<List<String>>? onReorder;

  const MediaPreview({
    super.key,
    required this.media,
    this.maxMedia = 10,
    this.onAdd,
    this.onRemove,
    this.onReorder,
  });

  @override
  State<MediaPreview> createState() =>
      _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(
      covariant MediaPreview oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (widget.media.isEmpty) {
      _selectedIndex = 0;
      return;
    }

    if (_selectedIndex >= widget.media.length) {
      _selectedIndex =
          widget.media.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) {
      return _emptyState();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _mainPreview(),

        const SizedBox(height: 10),

        _thumbnailList(),
      ],
    );
  }

  Widget _mainPreview() {
    final selected =
    widget.media[_selectedIndex];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMedia(selected),

            Positioned(
              top: 12,
              right: 12,
              child: _removeButton(
                _selectedIndex,
              ),
            ),

            if (widget.media.length > 1)
              Positioned(
                left: 12,
                bottom: 12,
                child: _countBadge(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailList() {
    final itemCount =
        widget.media.length +
            (widget.media.length <
                widget.maxMedia
                ? 1
                : 0);

    return SizedBox(
      height: 72,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        physics:
        const BouncingScrollPhysics(),
        itemCount: itemCount,
        onReorder: _reorder,
        proxyDecorator:
            (child, index, animation) {
          return Material(
            color: Colors.transparent,
            child: child,
          );
        },
        itemBuilder: (context, index) {
          if (index ==
              widget.media.length) {
            return SizedBox(
              key: const ValueKey(
                'add-media',
              ),
              width: 72,
              child: _addButton(),
            );
          }

          return Padding(
            key: ValueKey(
              '${widget.media[index]}-$index',
            ),
            padding:
            const EdgeInsets.only(
              right: 8,
            ),
            child: ReorderableDragStartListener(
              index: index,
              child: _thumbnail(index),
            ),
          );
        },
      ),
    );
  }

  Widget _thumbnail(int index) {
    final selected =
        index == _selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? const Color(0xffA855F7)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(11),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildThumbnail(
                widget.media[index],
              ),

              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    widget.onRemove?.call(
                      index,
                    );
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration:
                    const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 12,
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

  Widget _addButton() {
    return GestureDetector(
      onTap: widget.onAdd,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xff0D0D14),
          borderRadius:
          BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xff8B5CF6)
                .withOpacity(.5),
          ),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Color(0xffA855F7),
          size: 27,
        ),
      ),
    );
  }

  Widget _removeButton(int index) {
    return GestureDetector(
      onTap: () {
        widget.onRemove?.call(index);
      },
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.65),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 19,
        ),
      ),
    );
  }

  Widget _countBadge() {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.6),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Text(
        '${_selectedIndex + 1}/${widget.media.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: .05),
        ),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffA855F7)
                  .withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: Color(0xffA855F7),
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add photos or videos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Up to 10 items',
            style: TextStyle(
              color: Color(0xff666675),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: widget.onAdd,
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffA855F7),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: const Text(
                'Add media',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia(String path) {
    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _mediaPlaceholder();
        },
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _mediaPlaceholder();
      },
    );
  }

  Widget _buildThumbnail(String path) {
    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _mediaPlaceholder();
        },
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _mediaPlaceholder();
      },
    );
  }

  Widget _mediaPlaceholder() {
    return Container(
      color: const Color(0xff20202A),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.white30,
        size: 28,
      ),
    );
  }

  void _reorder(
      int oldIndex,
      int newIndex,
      ) {
    if (oldIndex >= widget.media.length) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex--;
    }

    final reordered =
    List<String>.from(widget.media);

    final item =
    reordered.removeAt(oldIndex);

    reordered.insert(newIndex, item);

    setState(() {
      _selectedIndex = newIndex;
    });

    widget.onReorder?.call(reordered);
  }
}