import 'package:pingo/models/player.dart';

class Match {
  Player player1;
  Player player2;
  int player1Score;
  int player2Score;
  DateTime date;

  Match({
    required this.player1,
    required this.player2,
    required this.player1Score,
    required this.player2Score,
    required this.date,
  });
}
