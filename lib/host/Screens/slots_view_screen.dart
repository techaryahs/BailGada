import 'package:flutter/material.dart';
import 'dart:math';
import '../models/participant.dart';

class SlotsViewScreen extends StatefulWidget {
  final List<Participant> participants;
  final int currentRound;
  final VoidCallback? onWinnerDeclared;

  const SlotsViewScreen({
    super.key,
    required this.participants,
    required this.currentRound,
    this.onWinnerDeclared,
  });

  @override
  State<SlotsViewScreen> createState() => _SlotsViewScreenState();
}

class _SlotsViewScreenState extends State<SlotsViewScreen> {
  int selectedRound = 1;
  int? selectedSlot;

  @override
  void initState() {
    super.initState();
    selectedRound = widget.currentRound;
  }

  @override
  Widget build(BuildContext context) {
    final participantsInRound = widget.participants
        .where((p) => p.currentRound == selectedRound && p.assignedSlot != null)
        .toList();

    // ✅ Check if it's a direct race (≤3 participants total in round)
    final isDirectRace = participantsInRound.length <= 3 && participantsInRound.isNotEmpty;

    final maxSlot = participantsInRound.isEmpty
        ? 0
        : participantsInRound.map((p) => p.assignedSlot!).reduce(max);

    final slotsMap = <int, List<Participant>>{};
    for (var participant in participantsInRound) {
      slotsMap.putIfAbsent(participant.assignedSlot!, () => []).add(participant);
    }

    // Sort participants within each slot by track number
    slotsMap.forEach((key, value) {
      value.sort((a, b) => a.trackNumber!.compareTo(b.trackNumber!));
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
            isDirectRace
                ? 'Final Race - Round $selectedRound'
                : 'Race Slots - Round $selectedRound'
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Rounds Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rounds',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 1; i <= 6; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildRoundButton(i),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ Race Slots Section - ONLY shown when MORE than 3 participants
          if (!isDirectRace && maxSlot > 0)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Race Slots',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (int i = 1; i <= maxSlot; i++)
                        _buildSlotButton(i, slotsMap[i]?.length ?? 0),
                    ],
                  ),
                ],
              ),
            ),

          // ✅ Info banner for direct race (≤3 participants)
          if (isDirectRace)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🏁 FINAL RACE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          '${participantsInRound.length} participants racing - Declare ONE winner!',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Participants Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Participants',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: participantsInRound.isEmpty
                        ? const Center(
                      child: Text(
                        'No participants assigned yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                        : isDirectRace
                        ? // ✅ Direct list for ≤3 participants (NO slot selection needed)
                    ListView.builder(
                      itemCount: participantsInRound.length,
                      itemBuilder: (context, index) {
                        final participant = participantsInRound[index];
                        return _buildParticipantCard(participant);
                      },
                    )
                        : // ✅ Slot-based view for >3 participants
                    selectedSlot == null
                        ? const Center(
                      child: Text(
                        'Select a slot to view participants',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                        : slotsMap[selectedSlot] == null ||
                        slotsMap[selectedSlot]!.isEmpty
                        ? const Center(
                      child: Text(
                        'No participants in this slot',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Slot $selectedSlot (${slotsMap[selectedSlot]!.length} participants)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: slotsMap[selectedSlot]!.length,
                            itemBuilder: (context, index) {
                              final participant =
                              slotsMap[selectedSlot]![index];
                              return _buildParticipantCard(participant);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(int round) {
    final isSelected = selectedRound == round;
    final hasParticipants = widget.participants.any(
            (p) => p.currentRound == round && p.assignedSlot != null
    );

    return GestureDetector(
      onTap: hasParticipants
          ? () {
        setState(() {
          selectedRound = round;
          selectedSlot = null;
        });
      }
          : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$round',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : hasParticipants
                      ? Colors.black87
                      : Colors.grey[400]!,
                ),
              ),
            ),
            if (hasParticipants && !isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotButton(int slot, int participantCount) {
    final isSelected = selectedSlot == slot;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = slot;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$slot',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              '($participantCount)',
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _declareWinner(Participant participant) {
    final participantsInRound = widget.participants
        .where((p) => p.currentRound == selectedRound && p.assignedSlot != null)
        .toList();

    final isDirectRace = participantsInRound.length <= 3;

    if (isDirectRace) {
      // ✅ For direct race (≤3 participants), only allow ONE winner total
      final existingWinner = participantsInRound.firstWhere(
            (p) => p.isWinner,
        orElse: () => Participant(id: '', name: '', horseName1: '', horseName2: ''),
      );

      if (existingWinner.id.isNotEmpty && existingWinner.id != participant.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${existingWinner.name} is already the winner!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      // ✅ For slot-based races (>3 participants), only one winner per slot
      final slotParticipants = participantsInRound
          .where((p) => p.assignedSlot == participant.assignedSlot)
          .toList();

      final existingWinner = slotParticipants.firstWhere(
            (p) => p.isWinner,
        orElse: () => Participant(id: '', name: '', horseName1: '', horseName2: ''),
      );

      if (existingWinner.id.isNotEmpty && existingWinner.id != participant.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Slot ${participant.assignedSlot} already has a winner: ${existingWinner.name}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Winner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Declare as winner?'),
            const SizedBox(height: 12),
            Text(
              participant.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text('🐎 ${participant.horseName1}'),
            Text('🐎 ${participant.horseName2}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              setState(() {
                final idx = widget.participants.indexWhere((p) => p.id == participant.id);
                widget.participants[idx] = participant.copyWith(
                  isWinner: true,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${participant.name} declared as winner!'),
                  backgroundColor: Colors.green,
                ),
              );

              // Notify parent to check round completion
              if (widget.onWinnerDeclared != null) {
                widget.onWinnerDeclared!();
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(Participant participant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: participant.isWinner ? Colors.green : Colors.grey[200]!,
          width: participant.isWinner ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.horseName1,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    participant.horseName2,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    participant.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track ${participant.trackNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (participant.isWinner == true) ...[
                    Row(
                      children: const [
                        Icon(Icons.emoji_events, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '✓ WINNER',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: () => _declareWinner(participant),
                      icon: const Icon(Icons.emoji_events, size: 18),
                      label: const Text('Declare Winner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(140, 36),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
