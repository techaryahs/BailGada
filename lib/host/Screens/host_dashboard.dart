import 'package:flutter/material.dart';
import 'dart:math';
import '../models/participant.dart';
import 'slots_view_screen.dart';

class HostDashboard extends StatefulWidget {
  const HostDashboard({super.key});

  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard> {
  List<Participant> participants = [
    Participant(
      id: '1',
      name: 'Arun Shetty',
      horseName1: 'Thunder',
      horseName2: 'Lightning',
    ),
    Participant(
      id: '2',
      name: 'Mahesh Nayak',
      horseName1: 'Blaze',
      horseName2: 'Storm',
    ),
    Participant(
      id: '3',
      name: 'Priya Singh',
      horseName1: 'Rocket',
      horseName2: 'Flash',
    ),
    Participant(
      id: '4',
      name: 'Rahul Kumar',
      horseName1: 'Comet',
      horseName2: 'Meteor',
    ),
    Participant(
      id: '5',
      name: 'Sneha Patel',
      horseName1: 'Phoenix',
      horseName2: 'Dragon',
    ),
    Participant(
      id: '6',
      name: 'Vikram Reddy',
      horseName1: 'Tornado',
      horseName2: 'Hurricane',
    ),
    Participant(
      id: '7',
      name: 'Anjali Sharma',
      horseName1: 'Eclipse',
      horseName2: 'Shadow',
    ),
    Participant(
      id: '8',
      name: 'Karan Mehta',
      horseName1: 'Titan',
      horseName2: 'Zeus',
    ),
    Participant(
      id: '9',
      name: 'Divya Iyer',
      horseName1: 'Vortex',
      horseName2: 'Cyclone',
    ),
    Participant(
      id: '10',
      name: 'Rohan Joshi',
      horseName1: 'Blizzard',
      horseName2: 'Avalanche',
    ),
    Participant(
      id: '11',
      name: 'Pooja Desai',
      horseName1: 'Inferno',
      horseName2: 'Ember',
    ),
    Participant(
      id: '12',
      name: 'Amit Gupta',
      horseName1: 'Sonic',
      horseName2: 'Turbo',
    ),
    Participant(
      id: '13',
      name: 'Neha Chopra',
      horseName1: 'Starfire',
      horseName2: 'Moonlight',
    ),
    Participant(
      id: '14',
      name: 'Sanjay Rao',
      horseName1: 'Nitro',
      horseName2: 'Boost',
    ),
    Participant(
      id: '15',
      name: 'Kavita Malhotra',
      horseName1: 'Wildfire',
      horseName2: 'Firestorm',
    ),
    Participant(
      id: '16',
      name: 'Deepak Verma',
      horseName1: 'Thunder Strike',
      horseName2: 'Lightning Bolt',
    ),
    Participant(
      id: '17',
      name: 'Ritu Saxena',
      horseName1: 'Swift',
      horseName2: 'Dash',
    ),
  Participant(id: '18', name: 'Arun Shetty', horseName1: 'Thunder', horseName2: 'Lightning'),
  Participant(id: '19', name: 'Mahesh Nayak', horseName1: 'Blaze', horseName2: 'Storm'),
  Participant(id: '20', name: 'Priya Singh', horseName1: 'Rocket', horseName2: 'Flash'),
  Participant(id: '21', name: 'Deepak Verma', horseName1: 'Swift', horseName2: 'Dash'),
  Participant(id: '22', name: 'Anjali Sharma', horseName1: 'Eclipse', horseName2: 'Shadow'),
  Participant(id: '23', name: 'Ravi Patil', horseName1: 'Bolt', horseName2: 'Blitz'),
  Participant(id: '24', name: 'Neha Desai', horseName1: 'Star', horseName2: 'Shine'),
  Participant(id: '25', name: 'Karan Mehta', horseName1: 'Vortex', horseName2: 'Surge'),
  Participant(id: '26', name: 'Sonia Kulkarni', horseName1: 'Falcon', horseName2: 'Wing'),
  Participant(id: '27', name: 'Amit Joshi', horseName1: 'Storm', horseName2: 'Rider'),
  Participant(id: '28', name: 'Rajesh Yadav', horseName1: 'Night', horseName2: 'Fury'),
  Participant(id: '29', name: 'Komal Jain', horseName1: 'Blizzard', horseName2: 'Frost'),
  Participant(id: '30', name: 'Vikram Rao', horseName1: 'Thunderbolt', horseName2: 'Strike'),
  ];
  int currentRound = 1;
  int selectedRound = 1;
  bool slotsAssigned = false;

  @override
  void initState() {
    super.initState();
    // Ensure all participants start in round 1
    for (int i = 0; i < participants.length; i++) {
      participants[i] = participants[i].copyWith(
        currentRound: 1,
        assignedSlot: null,
        trackNumber: null,
        isWinner: false,
      );
    }
  }

  // ✅ ASSIGN SLOTS DYNAMICALLY
  void assignSlotsRandomly() {
    final participantsInRound = participants
        .where((p) => p.currentRound == currentRound)
        .toList();

    if (participantsInRound.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No participants available for this round')),
      );
      return;
    }

    // Shuffle participants
    participantsInRound.shuffle(Random());

    int slotNumber = 1;
    int trackNumber = 1;

    // ✅ Slot size logic
    // Round 1: max 8 per slot (random assignment if >3)
    // Round 2+: max 6 per slot (three pairs per slot) when >3 participants
    // If ≤3 participants: all in one slot
    int maxParticipantsPerSlot;

    if (participantsInRound.length <= 3) {
      // All participants in one slot (direct race)
      maxParticipantsPerSlot = participantsInRound.length;
    } else if (currentRound == 1) {
      maxParticipantsPerSlot = 8;
    } else {
      maxParticipantsPerSlot = 6; // three pairs per slot after Round 1
    }

    for (int i = 0; i < participantsInRound.length; i++) {
      final participant = participantsInRound[i];
      final index = participants.indexWhere((p) => p.id == participant.id);

      participants[index] = participant.copyWith(
        assignedSlot: slotNumber,
        trackNumber: trackNumber,
      );

      trackNumber++;

      // Move to next slot if current slot is full
      if (trackNumber > maxParticipantsPerSlot) {
        trackNumber = 1;
        slotNumber++;
      }
    }

    setState(() {
      slotsAssigned = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            participantsInRound.length <= 3
                ? 'Race ready with ${participantsInRound.length} participants!'
                : 'Slots assigned successfully!'
        ),
      ),
    );
  }

  // Auto-assign participants for a given round
  void _autoAssignForRound(int round) {
    final participantsInRound = participants
        .where((p) => p.currentRound == round)
        .toList();

    if (participantsInRound.isEmpty) return;

    // Shuffle for randomness
    participantsInRound.shuffle(Random());

    int slotNumber = 1;
    int trackNumber = 1;

    // For round 2, place participants in slots of 3
    final maxPerSlot = round == 2 ? 3 : 6; // keep 6 for later rounds if needed

    for (final participant in participantsInRound) {
      final idx = participants.indexWhere((p) => p.id == participant.id);
      participants[idx] = participant.copyWith(
        assignedSlot: slotNumber,
        trackNumber: trackNumber,
      );

      trackNumber++;
      if (trackNumber > maxPerSlot) {
        trackNumber = 1;
        slotNumber++;
      }
    }
  }

  // ✅ CHECK IF ROUND IS COMPLETE AND PROGRESS
  void checkRoundCompletion() {
    final participantsInRound = participants
        .where((p) => p.currentRound == currentRound && p.assignedSlot != null)
        .toList();

    if (participantsInRound.isEmpty) return;

    // ✅ CASE 1: Direct race (≤3 participants) - Need ONE winner
    if (participantsInRound.length <= 3) {
      final winners = participantsInRound.where((p) => p.isWinner).toList();

      if (winners.length == 1) {
        // ✅ FINAL WINNER!
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('🏆 Champion Declared!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  winners[0].name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 12),
                Text('🐎 ${winners[0].horseName1}'),
                Text('🐎 ${winners[0].horseName2}'),
                const SizedBox(height: 12),
                const Text(
                  'is the FINAL WINNER!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // ✅ CASE 2: Multiple slots - Check if all slots have a winner
    final slots = <int>{};
    for (var p in participantsInRound) {
      if (p.assignedSlot != null) {
        slots.add(p.assignedSlot!);
      }
    }

    // Count how many slots have winners
    int slotsWithWinners = 0;
    for (var slot in slots) {
      final slotParticipants = participantsInRound
          .where((p) => p.assignedSlot == slot)
          .toList();

      if (slotParticipants.any((p) => p.isWinner)) {
        slotsWithWinners++;
      }
    }

    // ✅ If all slots have winners, progress to next round
    if (slotsWithWinners == slots.length && slotsWithWinners > 0) {
      final winners = participants
          .where((p) => p.currentRound == currentRound && p.isWinner)
          .toList();

      _progressToNextRound(winners);
    }
  }

  // ✅ MOVE WINNERS TO NEXT ROUND
  void _progressToNextRound(List<Participant> winners) {
    if (winners.isEmpty) return;

    // Move winners to next round and reset their state
    final nextRound = currentRound + 1;
    for (var winner in winners) {
      final index = participants.indexWhere((p) => p.id == winner.id);
      participants[index] = winner.copyWith(
        currentRound: nextRound,
        assignedSlot: null,
        trackNumber: null,
        isWinner: false, // Reset for next round
      );
    }

    // Auto-assign for round 2 into slots of 3
    if (nextRound == 2) {
      _autoAssignForRound(nextRound);
    }

    // Prepare message
    String message;
    String title;

    if (winners.length <= 3) {
      title = '🏁 Final Race Setup!';
      message = '${winners.length} winners moved to Round $nextRound\n\n'
          '⚠️ This will be a direct race!\n'
          'Winner will be the CHAMPION!';
    } else {
      title = 'Round $currentRound Complete!';
      if (nextRound == 2) {
        final expectedSlots = (winners.length / 3).ceil();
        message = '${winners.length} winners moved to Round $nextRound\n\n'
            'They have been grouped into $expectedSlots slots\n'
            '(max 3 participants per slot).';
      } else {
        final expectedSlots = (winners.length / 6).ceil();
        message = '${winners.length} winners moved to Round $nextRound\n\n'
            'They will be divided into $expectedSlots slots\n'
            '(max 6 participants per slot).';
      }
    }

    // Show dialog and update UI
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentRound = nextRound;
                selectedRound = currentRound;
                // For round 2, slots are auto-assigned; mark as assigned
                slotsAssigned = nextRound == 2 ? true : false;
              });
            },
            child: Text('Go to Round $nextRound'),
          ),
        ],
      ),
    );

    // Update state
    setState(() {});
  }

  void viewSlots() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotsViewScreen(
          participants: participants,
          currentRound: selectedRound,
          onWinnerDeclared: () {
            setState(() {
              // Refresh state
            });
            checkRoundCompletion();
          },
        ),
      ),
    ).then((_) {
      // Refresh when coming back
      setState(() {});
    });
  }

  void tryAssignSlots() {
    final participantsInRound = participants
        .where((p) => p.currentRound == currentRound)
        .toList();

    if (participantsInRound.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No participants in this round')),
      );
      return;
    }

    // Only allow manual assignment for Round 1
    if (currentRound > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slots are auto-assigned from Round 2 onwards.'),
        ),
      );
      return;
    }

    final alreadyAssigned = participantsInRound.any((p) => p.assignedSlot != null);

    if (alreadyAssigned) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Already Assigned'),
          content: const Text('Participants are already assigned to slots.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewSlots();
              },
              child: const Text('View Slots'),
            ),
          ],
        ),
      );
      return;
    }

    assignSlotsRandomly();
  }

  @override
  Widget build(BuildContext context) {
    final participantsInRound = participants
        .where((p) => p.currentRound == currentRound)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Round Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Round',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: participantsInRound.isEmpty || currentRound > 1
                        ? null
                        : tryAssignSlots,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Assign Slots'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: slotsAssigned ? viewSlots : null,
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Slots'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Participants Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Participants: ${participantsInRound.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (participantsInRound.length <= 3 && participantsInRound.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'FINAL RACE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Participants List
          Expanded(
            child: participantsInRound.isEmpty
                ? const Center(
              child: Text(
                'No participants in this round',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: participantsInRound.length,
              itemBuilder: (context, index) {
                final participant = participantsInRound[index];
                return _buildParticipantCard(participant);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(int round) {
    final isSelected = currentRound == round;
    final hasParticipants = participants.any((p) => p.currentRound == round);

    return GestureDetector(
      onTap: () {
        setState(() {
          currentRound = round;
          selectedRound = round;
          slotsAssigned = participants
              .where((p) => p.currentRound == round)
              .any((p) => p.assignedSlot != null);
        });
      },
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
                  color: isSelected ? Colors.white : Colors.black87,
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

  Widget _buildParticipantCard(Participant participant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(height: 8),
                  Text(
                    participant.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (participant.assignedSlot != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.flag,
                          size: 14,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Slot ${participant.assignedSlot} - Track ${participant.trackNumber}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (participant.isWinner) ...[
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.emoji_events, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'Winner',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
