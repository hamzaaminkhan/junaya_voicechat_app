import 'package:flutter/material.dart';

class LocationPickerSheet extends StatefulWidget {
  final String? selectedLocation;
  final ValueChanged<String>? onSelected;

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

  final List<String> _locations = const [
    'Current location',
    'Islamabad, Pakistan',
    'Lahore, Pakistan',
    'Karachi, Pakistan',
    'Rawalpindi, Pakistan',
  ];

  String _query = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredLocations {
    if (_query.isEmpty) {
      return _locations;
    }

    return _locations
        .where(
          (location) => location
          .toLowerCase()
          .contains(_query.toLowerCase()),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .62,
      decoration: const BoxDecoration(
        color: Color(0xff11111A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _handle(),

            _header(),

            _searchField(),

            const SizedBox(height: 8),

            Expanded(
              child: _locationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _handle() {
    return Container(
      margin: const EdgeInsets.only(top: 11),
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        16,
        14,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Add location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xff888896),
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        height: 46,
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
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xff777787),
              size: 20,
            ),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
              onPressed: () {
                _searchController.clear();
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Color(0xff777787),
                size: 17,
              ),
            )
                : null,
            hintText: 'Search location',
            hintStyle: const TextStyle(
              color: Color(0xff666675),
              fontSize: 14,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _locationList() {
    final locations = _filteredLocations;

    if (locations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              color: Colors.white24,
              size: 38,
            ),
            SizedBox(height: 12),
            Text(
              'No locations found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Try a different search.',
              style: TextStyle(
                color: Color(0xff666675),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        20,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: locations.length,
      separatorBuilder: (_, __) => const SizedBox(
        height: 4,
      ),
      itemBuilder: (context, index) {
        final location = locations[index];

        final selected =
            location == widget.selectedLocation;

        final current =
            location == 'Current location';

        return Material(
          color: selected
              ? const Color(0xffA855F7)
              .withValues(alpha: .10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () {
              widget.onSelected?.call(location);
              Navigator.of(context).pop(location);
            },
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: current
                          ? const Color(0xffA855F7)
                          .withValues(alpha: .12)
                          : const Color(0xff20202A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      current
                          ? Icons.my_location_rounded
                          : Icons.location_on_outlined,
                      color: current
                          ? const Color(0xffA855F7)
                          : const Color(0xff9999A8),
                      size: 19,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(
                        color: current
                            ? const Color(0xffC084FC)
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  if (selected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xffA855F7),
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}