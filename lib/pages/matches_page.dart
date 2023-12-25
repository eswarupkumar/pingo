import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pingo/models/duo.dart';
import 'package:pingo/models/player.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<Player> _playersList = [];
  final List<Duo> _oneOnOneList = [];

  Player? _player1;
  Player? _player2;

  int? _player1PointCount;
  int? _player2PointCount;

  List<DropdownMenuItem<Player>> _getPlayersDropdownItem() {
    List<DropdownMenuItem<Player>> _playerDropdownItem = [];
    Player? _player1;
    Player? _player2;

    _playersList.forEach((p) {
      _playerDropdownItem.add(DropdownMenuItem(value: p, child: Text(p.name)));
    });

    return _playerDropdownItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    const Text("Match details"),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                              items: _getPlayersDropdownItem(),
                              onChanged: (val) {
                                _player1 = val;
                              }),
                        ),
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (pt) {
                            _player1PointCount = int.parse(pt);
                          },
                        ))
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("VS"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                              items: _getPlayersDropdownItem(),
                              onChanged: (val) {
                                _player2 = val;
                              }),
                        ),
                        Expanded(child: TextFormField(
                          onChanged: (pt) {
                            _player2PointCount = int.parse(pt);
                          },
                        ))
                      ],
                    ),
                    OutlinedButton(
                        onPressed: () {
                          _player1?.matches += 1;
                          _player2?.matches += 1;

                          if (_player1PointCount! > _player2PointCount!) {
                            _player1?.wins += 1;
                            _player2?.losses += 1;
                          } else {
                            _player2?.wins += 1;
                            _player1?.losses += 1;
                          }

                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text("Save"))
                  ],
                );
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "One on One",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              children: [
                                const Text("Add a One on One"),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField(
                                          items: _getPlayersDropdownItem(),
                                          onChanged: (val) {
                                            _player1 = val;
                                          }),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text("VS"),
                                    ),
                                    Expanded(
                                      child: DropdownButtonFormField(
                                          items: _getPlayersDropdownItem(),
                                          onChanged: (val) {
                                            _player2 = val;
                                          }),
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      _oneOnOneList.add(Duo(
                                          player1: _player1!,
                                          player2: _player2!,
                                          matches: []));

                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: const Text("Save"))
                              ],
                            );
                          });
                    },
                    child: const Row(
                      children: [Icon(Icons.add), Text("Create")],
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    Duo _duo = _oneOnOneList[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(_duo.player1.name),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("VS"),
                            ),
                            Text(_duo.player2.name),
                          ],
                        ),
                        Text("M: ${_duo.matches.length}"),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: _oneOnOneList.length),
            ),
          ],
        ),
      ),
    );
  }
}
