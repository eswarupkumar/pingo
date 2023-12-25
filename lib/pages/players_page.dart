import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pingo/models/player.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _textEditingController = TextEditingController();

  final List<Player> _playersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    _playersList.clear();
    await db.collection('players').get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          _playersList.add(Player.fromFirestore(docSnapshot, null));
        }
        setState(() {});
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Players",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    Player player = _playersList[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(player.name),
                        Row(
                          children: [
                            Text("M: ${player.matches}"),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("W: ${player.wins}"),
                            ),
                            Text("L: ${player.losses}"),
                          ],
                        )
                      ],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: _playersList.length),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    const Text("Add Player"),
                    TextFormField(
                      controller: _textEditingController,
                      autofocus: true,
                    ),
                    OutlinedButton(
                        onPressed: () async {
                          await _addPlayer();
                          _textEditingController.clear();
                          Navigator.pop(context);
                          init();
                        },
                        child: const Text("Save"))
                  ],
                );
              });
        },
      ),
    );
  }

  Future<void> _addPlayer() async {
    Player _player = Player(name: _textEditingController.text);
    final docRef = db
        .collection("players")
        .withConverter(
          fromFirestore: Player.fromFirestore,
          toFirestore: (Player city, options) => city.toFirestore(),
        )
        .doc(_player.name);
    await docRef
        .set(_player)
        .then((value) => print("Successfully created the document"))
        .onError((error, stackTrace) =>
            print("Failed to create the document - ${error}"));
  }
}
