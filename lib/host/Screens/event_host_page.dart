import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/racer_data.dart';
import '../../widgets/racer_details_widget.dart';

class EventHostPage extends StatefulWidget {
  const EventHostPage({Key? key}) : super(key: key);

  @override
  State<EventHostPage> createState() => _EventHostPageState();
}

class _EventHostPageState extends State<EventHostPage> {
  late YoutubePlayerController _youtubeController;
  bool showAllRounds = false;
  int? selectedSlot;
  String selectedRound = '1';

  final List<String> rounds = List.generate(10, (i) => '${i + 1}');

  final Map<String, List<RacerData>> racersData = {
    '1': [
      RacerData(
        slotNumber: 1,
        racerName: 'Rajesh Kumar',
        bullName: 'Thunder',
        village: 'Kundapura',
        experience: '5 years',
        previousWins: 12,
        imageUrl: 'https://via.placeholder.com/150',
        participants: [
          Participant(
            name: 'Arun Shetty',
            trackNumber: 1,
            bull1Name: 'Thunder',
            bull2Name: 'Lightning',
            bull1Image: 'assets/images/bailgada_poster.png',
            bull2Image: 'assets/images/bailgada_poster.png',
          ),
          Participant(
            name: 'Mahesh Nayak',
            trackNumber: 2,
            bull1Name: 'Blaze',
            bull2Name: 'Storm',
            bull1Image: 'assets/images/bailgada_poster.png',
            bull2Image: 'assets/images/bailgada_poster.png',
          ),
        ],
      ),
      RacerData(
        slotNumber: 2,
        racerName: 'Suresh Shetty',
        bullName: 'Lightning',
        village: 'Udupi',
        experience: '7 years',
        previousWins: 18,
        imageUrl: 'https://via.placeholder.com/150',
        participants: [
          Participant(
            name: 'Arun Shetty',
            trackNumber: 1,
            bull1Name: 'Thunder',
            bull2Name: 'Lightning',
            bull1Image: 'assets/images/bailgada_poster.png',
            bull2Image: 'assets/images/bailgada_poster.png',
          ),
          Participant(
            name: 'Mahesh Nayak',
            trackNumber: 2,
            bull1Name: 'Blaze',
            bull2Name: 'Storm',
            bull1Image: 'assets/images/bailgada_poster.png',
            bull2Image: 'assets/images/bailgada_poster.png',
          ),
        ],

      ),
    ],
  };


  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ',
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 🎥 1. LIVE VIDEO
            SizedBox(
              height: screenHeight * 0.35,
              width: double.infinity,
              child: YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: const Color(0xFFFF6B35),
              ),
            ),

            /// 🏁 2. TITLE BELOW VIDEO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.sports_motorsports,
                    color: Color(0xFFFF6B35),
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Bailgada Race - Championship 2025',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Live from Kundapura, Karnataka',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.grey),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.grey),

            /// 🏆 3. CONTENT AREA
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ⚪ ROUNDS SECTION
                    const Text(
                      'Rounds',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Stack used to make "ALL" sticky at right edge
                    SizedBox(
                      height: 50,
                      child: Stack(
                        children: [
                          // Scrollable row of rounds
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: rounds.length,
                            itemBuilder: (context, index) {
                              return _buildRoundBox(rounds[index]);
                            },
                          ),

                          // Sticky "ALL" button on right edge
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.white.withOpacity(0),
                                    Colors.white,
                                  ],
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAllRounds = !showAllRounds;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF6B35).withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: const Offset(-3, 2), // 👈 pushes shadow slightly left & down
                                      ),
                                    ],

                                  ),
                                  child: const Center(
                                    child: Text(
                                      'ALL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (showAllRounds)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: rounds.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.4,
                            ),
                        itemBuilder: (context, index) {
                          return _buildRoundBox(rounds[index]);
                        },
                      ),

                    const SizedBox(height: 10),

                    if (racersData[selectedRound] != null && racersData[selectedRound]!.isNotEmpty)
                      _buildSlotGrid()
                    else
                      _buildSlotsToBeDeclaredMessage(),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundBox(String round) {
    final bool isSelected = selectedRound == round;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRound = round;
          showAllRounds = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B35)
                : Colors.grey.withOpacity(0.4),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Center(
          child: Text(
            round,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotGrid() {
    final slots = racersData[selectedRound] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Race Slots',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 12),

        // Grid view for slots
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: slots.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final slot = slots[index];
            final bool isSelected = selectedSlot == slot.slotNumber;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSlot = isSelected ? null : slot.slotNumber;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF6B35)
                        : Colors.grey.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    slot.slotNumber.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Show participants below selected slot
        if (selectedSlot != null)
          _buildParticipantsSection(slots
              .firstWhere((r) => r.slotNumber == selectedSlot)
              .participants),
      ],
    );
  }

  Widget _buildParticipantsSection(List<Participant> participants) {
    if (participants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "No participants available for this slot.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Participants",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 10),

        Column(
          children: participants.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🐃 Bull Pair Section
                  _buildBullRow(p.bull1Name, p.bull1Image),
                  const SizedBox(height: 8),
                  _buildBullRow(p.bull2Name, p.bull2Image),
                  const SizedBox(height: 12),

                  // 👤 Participant Info (bottom row)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.flag, size: 16, color: Color(0xFFFF6B35)),
                          const SizedBox(width: 5),
                          Text(
                            "Track ${p.trackNumber}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBullRow(String bullName, String bullImage) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            bullImage,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          bullName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF6B35),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotsToBeDeclaredMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B35).withOpacity(0.06),
            const Color(0xFFFF8C42).withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B35).withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.access_time,
              size: 36,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Slots Yet to be Declared',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Stay tuned for the next exciting round!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


}
