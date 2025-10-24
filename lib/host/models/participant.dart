class Participant {
  final String id;
  final String name;
  final String horseName1;
  final String horseName2;
  int currentRound;
  int? assignedSlot;
  int? trackNumber;
  bool isWinner;

  Participant({
    required this.id,
    required this.name,
    required this.horseName1,
    required this.horseName2,
    this.currentRound = 1,
    this.assignedSlot,
    this.trackNumber,
    this.isWinner = false,
  });

  Participant copyWith({
    int? currentRound,
    int? assignedSlot,
    int? trackNumber,
    bool? isWinner,
  }) {
    return Participant(
      id: id,
      name: name,
      horseName1: horseName1,
      horseName2: horseName2,
      currentRound: currentRound ?? this.currentRound,
      assignedSlot: assignedSlot ?? this.assignedSlot,
      trackNumber: trackNumber ?? this.trackNumber,
      isWinner: isWinner ?? this.isWinner,
    );
  }
}
