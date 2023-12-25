import 'package:pingo/models/player.dart';
import 'package:pingo/models/match.dart';

class Duo {
  Player player1;
  Player player2;
  int matchCount;
  List<Match> matches;

  Duo({
    required this.player1,
    required this.player2,
    this.matchCount = 0,
    required this.matches,
  });
}
