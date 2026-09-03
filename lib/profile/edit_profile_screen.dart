import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/backgrounds/space_bg.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: .35)),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        _avatarSection(),
                        const SizedBox(height: 14),
                        _tabs(),
                        const SizedBox(height: 14),
                        _profileDetails(),
                        const SizedBox(height: 20),
                        _supporterSection(),
                        const SizedBox(height: 22),
                        _relationshipSection(),
                        const SizedBox(height: 22),
                        _medalSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Text(
                "Edit Profile",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              width: 58,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    color: Colors.amber,
                    fontSize: 14,
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

  Widget _avatarSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.purpleAccent, width: 2.5),
          ),
          child: const CircleAvatar(
            radius: 46,
            backgroundColor: Color(0xff21152E),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          "Change Avatar",
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 42,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .30),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: .5)),
      ),
      child: Row(
        children: [
          Expanded(child: _tab("Profile", true)),
          Expanded(child: _tab("Props", false)),
          Expanded(child: _tab("Post", false)),
        ],
      ),
    );
  }

  Widget _tab(String title, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: active ? Colors.white : Colors.white54,
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 3),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 2.5,
          width: active ? 30 : 0,
          decoration: BoxDecoration(
            color: active ? Colors.purpleAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _profileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 7,
            runSpacing: 7,
            children: [
              Text(
                "MR. ALEX",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.male, color: Colors.blueAccent, size: 21),
              _smallBadge(Icons.workspace_premium, "0", Colors.orange),
              _smallBadge(Icons.diamond, "0", Colors.pinkAccent),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 7,
            runSpacing: 5,
            children: [
              Text(
                "ID:137804327",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
              const Icon(Icons.copy, color: Colors.white70, size: 16),
              const Text(
                "|",
                style: TextStyle(color: Colors.white38, fontSize: 17),
              ),
              const Text(
                "🇵🇰  Pakistan",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .28),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: Colors.purpleAccent.withValues(alpha: .8),
                  ),
                ),
                child: const Icon(
                  Icons.monitor_weight,
                  color: Colors.white70,
                  size: 17,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                "64 kg",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _supporterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Supporter", style: _sectionTitleStyle()),
              Row(
                children: [
                  Text(
                    "Ranking",
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white60,
                    size: 13,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _medalItem(Colors.amber, Icons.weekend),
              _medalItem(Colors.grey, Icons.weekend),
              _medalItem(Colors.orange, Icons.weekend),
              _medalItem(Colors.deepOrange, Icons.weekend),
            ],
          ),
        ],
      ),
    );
  }

  Widget _medalItem(Color color, IconData icon) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [color, color.withValues(alpha: .5)]),
        border: Border.all(color: Colors.white24, width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: .25), blurRadius: 8),
        ],
      ),
      child: Icon(icon, color: Colors.white70, size: 27),
    );
  }

  Widget _relationshipSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Special Relationship", style: _sectionTitleStyle()),
          const SizedBox(height: 11),
          Container(
            height: 126,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff7A123E).withValues(alpha: .70),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber, width: 1.5),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 29,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 31,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "MR. ALEX",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.favorite, color: Colors.pinkAccent, size: 30),
                Positioned(
                  right: 35,
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                      color: Colors.black26,
                    ),
                    child: const Icon(
                      Icons.question_mark,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_emptyPropBox(), _emptyPropBox(), _emptyPropBox()],
          ),
        ],
      ),
    );
  }

  Widget _emptyPropBox() {
    return Container(
      height: 88,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: .55)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            height: 20,
            width: 53,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.purpleAccent),
            ),
            child: const Icon(Icons.add, color: Colors.white70, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _medalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Medal", style: _sectionTitleStyle()),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .25),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.purpleAccent.withValues(alpha: .45),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _medalInfo("0", "Medal Score"),
                    Container(height: 35, width: 1, color: Colors.white24),
                    _medalInfo("0", "Rank"),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 58,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .05),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    "Haven't got a medal yet~",
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _medalInfo(String number, String title) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  TextStyle _sectionTitleStyle() {
    return GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
  }
}
