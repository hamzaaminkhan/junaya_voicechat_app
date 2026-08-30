import 'package:flutter/material.dart';

class LocationPickerSheet extends StatefulWidget {
  final String? selectedLocation;
  final ValueChanged<String?>? onSelected;

  const LocationPickerSheet({
    super.key,
    this.selectedLocation,
    this.onSelected,
  });

  @override
  State<LocationPickerSheet> createState() =>
      _LocationPickerSheetState();
}

class _LocationPickerSheetState
    extends State<LocationPickerSheet> {
  final TextEditingController _searchController =
  TextEditingController();

  final List<_LocationItem> _locations = const [
    _LocationItem(
      name: 'Dubai',
      subtitle: 'Dubai, United Arab Emirates',
      icon: Icons.location_city_outlined,
    ),
    _LocationItem(
      name: 'Abu Dhabi',
      subtitle: 'Abu Dhabi, United Arab Emirates',
      icon: Icons.location_city_outlined,
    ),
    _LocationItem(
      name: 'Sharjah',
      subtitle: 'Sharjah, United Arab Emirates',
      icon: Icons.location_city_outlined,
    ),
    _LocationItem(
      name: 'Downtown Dubai',
      subtitle: 'Dubai, United Arab Emirates',
      icon: Icons.place_outlined,
    ),
  ];

  List<_LocationItem> _filtered = [];

  @override
  void initState() {
    super.initState();

    _filtered = List.from(_locations);

    _searchController.addListener(
      _filterLocations,
    );
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_filterLocations)
      ..dispose();

    super.dispose();
  }

  void _filterLocations() {
    final query =
    _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filtered = List.from(_locations);
      } else {
        _filtered = _locations
            .where(
              (location) =>
          location.name
              .toLowerCase()
              .contains(query) ||
              location.subtitle
                  .toLowerCase()
                  .contains(query),
        )
            .toList();
      }
    });
  }

  void _select(String location) {
    widget.onSelected?.call(location);
    Navigator.of(context).pop(location);
  }

  void _clear() {
    widget.onSelected?.call(null);
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
      MediaQuery.of(context).size.height * .72,
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),

            _handle(),

            const SizedBox(height: 18),

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.selectedLocation !=
                      null)
                    GestureDetector(
                      onTap: _clear,
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color:
                          Color(0xffA855F7),
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: _searchField(),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView(
                physics:
                const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                children: [
                  _currentLocationButton(),

                  const SizedBox(height: 22),

                  if (_searchController.text
                      .isEmpty)
                    const _SectionTitle(
                      title: 'Recent',
                    ),

                  if (_searchController.text
                      .isEmpty)
                    ..._recentLocations(),

                  if (_searchController.text
                      .isNotEmpty &&
                      _filtered.isNotEmpty)
                    const _SectionTitle(
                      title: 'Results',
                    ),

                  if (_searchController.text
                      .isNotEmpty)
                    ..._filtered.map(
                          (location) =>
                          _locationTile(location),
                    ),

                  if (_filtered.isEmpty)
                    _emptyState(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xff20202A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search location',
          hintStyle: const TextStyle(
            color: Color(0xff666675),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xff777787),
            size: 21,
          ),
          suffixIcon:
          _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
            },
            icon: const Icon(
              Icons.close_rounded,
              color:
              Color(0xff777787),
              size: 18,
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _currentLocationButton() {
    return Material(
      color: const Color(0xff191923),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          _select('Current location');
        },
        borderRadius: BorderRadius.circular(16),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          child: Row(
            children: [
              _IconCircle(
                icon:
                Icons.my_location_rounded,
                highlighted: true,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Use current location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Find places near you',
                      style: TextStyle(
                        color:
                        Color(0xff777787),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Color(0xff5F5F6D),
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _recentLocations() {
    return _locations
        .take(3)
        .map(
          (location) =>
          _locationTile(location),
    )
        .toList();
  }

  Widget _locationTile(
      _LocationItem location,
      ) {
    final selected =
        widget.selectedLocation ==
            location.name;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius:
        BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            _select(location.name);
          },
          borderRadius:
          BorderRadius.circular(14),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 11,
            ),
            child: Row(
              children: [
                _IconCircle(
                  icon: location.icon,
                  highlighted: selected,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        location.subtitle,
                        style: const TextStyle(
                          color:
                          Color(0xff777787),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color:
                    Color(0xffA855F7),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 70,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.location_off_outlined,
            color: Colors.white24,
            size: 42,
          ),
          const SizedBox(height: 14),
          const Text(
            'No locations found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Try a different search.',
            style: TextStyle(
              color: Color(0xff666675),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff777787),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final bool highlighted;

  const _IconCircle({
    required this.icon,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: highlighted
            ? const Color(0xffA855F7)
            .withValues(alpha: .13)
            : const Color(0xff20202A),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: highlighted
            ? const Color(0xffA855F7)
            : const Color(0xff9999A8),
        size: 20,
      ),
    );
  }
}

class _LocationItem {
  final String name;
  final String subtitle;
  final IconData icon;

  const _LocationItem({
    required this.name,
    required this.subtitle,
    required this.icon,
  });
}