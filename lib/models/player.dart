import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String name;
  int matches;
  int wins;
  int losses;

  Player({
    required this.name,
    this.matches = 0,
    this.wins = 0,
    this.losses = 0,
  });

  factory Player.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Player(
      name: data?['name'],
      matches: data?['matches'],
      wins: data?['wins'],
      losses: data?['losses'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "matches": matches,
      "wins": wins,
      "losses": losses,
    };
  }
}
