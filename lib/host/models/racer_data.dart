class Participant {
  final String name;
  final int trackNumber;
  final String bull1Name;
  final String bull2Name;
  final String bull1Image;
  final String bull2Image;

  Participant({
    required this.name,
    required this.trackNumber,
    required this.bull1Name,
    required this.bull2Name,
    required this.bull1Image,
    required this.bull2Image,
  });
}


class RacerData {
  final int slotNumber;
  final String racerName;
  final String bullName;
  final String village;
  final String experience;
  final int previousWins;
  final String imageUrl;
  final List<Participant> participants;

  RacerData({
    required this.slotNumber,
    required this.racerName,
    required this.bullName,
    required this.village,
    required this.experience,
    required this.previousWins,
    required this.imageUrl,
    this.participants = const [],
  });
}
