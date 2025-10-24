import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/racer_data.dart';
import '../widgets/racer_details_widget.dart';

class EventHostPage extends StatefulWidget {
  const EventHostPage({Key? key}) : super(key: key);

  @override
  State<EventHostPage> createState() => _EventHostPageState();
}

class _EventHostPageState extends State<EventHostPage>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _youtubeController;
  late AnimationController _animationController;
  int? selectedSlot;
  String selectedRound = 'round1';

  final Map<String, List<RacerData>> racersData = {
    'round1': [
      RacerData(
        slotNumber: 1,
        racerName: 'Rajesh Kumar',
        bullName: 'Thunder',
        village: 'Kundapura',
        experience: '5 years',
        previousWins: 12,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      RacerData(
        slotNumber: 2,
        racerName: 'Suresh Shetty',
        bullName: 'Lightning',
        village: 'Udupi',
        experience: '7 years',
        previousWins: 18,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      RacerData(
        slotNumber: 3,
        racerName: 'Manjunath Gowda',
        bullName: 'Storm',
        village: 'Brahmavara',
        experience: '4 years',
        previousWins: 9,
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final String? videoId = ModalRoute.of(context)?.settings.arguments as String?;

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId ?? 'dQw4w9WgXcQ',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFFF6B35).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildVideoSection(),
                const SizedBox(height: 30),
                _buildRoundSelector(),
                const SizedBox(height: 30),
                if (selectedRound == 'round1')
                  _buildRound1Slots()
                else
                  _buildRound2Message(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.sports_motorsports,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Bailgada Race',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                  ),
                ),
                Text(
                  'Championship 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFFFF6B35),
        ),
      ),
    );
  }

  Widget _buildRoundSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildRoundTab('Round 1', 'round1'),
          ),
          Expanded(
            child: _buildRoundTab('Round 2', 'round2'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundTab(String title, String roundId) {
    final isSelected = selectedRound == roundId;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRound = roundId;
          selectedSlot = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildRound1Slots() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Race Slots',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 20),
          ...racersData['round1']!.map((racer) => _buildSlotCard(racer)).toList(),
        ],
      ),
    );
  }

  Widget _buildSlotCard(RacerData racer) {
    final isSelected = selectedSlot == racer.slotNumber;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = isSelected ? null : racer.slotNumber;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[200]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFFF6B35).withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${racer.slotNumber}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Slot ${racer.slotNumber}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSelected ? racer.racerName : 'Tap to view details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFFFF6B35)
                                : const Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFFFF6B35),
                    size: 28,
                  ),
                ],
              ),
            ),
            if (isSelected) RacerDetailsWidget(racer: racer),
          ],
        ),
      ),
    );
  }

  Widget _buildRound2Message() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B35).withOpacity(0.1),
            const Color(0xFFFF8C42).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B35).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.schedule,
              size: 60,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Round 2',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Results Yet to be Declared',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Stay tuned for the exciting results!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
