import 'package:marcatruco/features/history/history_controller.dart';
import 'package:marcatruco/models/match.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/shared/sheets/actions_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryController _historyController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<MapEntry<String, Match>> _matchesList = [];

  @override
  void initState() {
    super.initState();
    _historyController = HistoryController();
    _historyController.addListener(_updateMatches);
    _matchesList = _historyController.matches.entries.toList();
  }

  @override
  void dispose() {
    _historyController.removeListener(_updateMatches);
    super.dispose();
  }

  void _updateMatches() {
    // Atualiza a lista local com possíveis mudanças no controlador
    setState(() {
      _matchesList = _historyController.matches.entries.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Histórico de Partidas'),
        centerTitle: true,
      ),
      body: _matchesList.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma partida salva.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : AnimatedList(
              key: _listKey,
              initialItemCount: _matchesList.length,
              itemBuilder: (context, index, animation) {
                final matchEntry = _matchesList[index];
                return _buildMatchCard(
                    matchEntry.value, matchEntry.key, animation, index);
              },
            ),
    );
  }

  Widget _buildMatchCard(
      Match match, String matchKey, Animation<double> animation, int index) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final String formattedStartTime = dateFormat.format(match.startTime);

    bool teamAWins = match.teamA.score > match.teamB.score;
    bool isTie = match.teamA.score == match.teamB.score;

    final Team firstTeam = teamAWins ? match.teamA : match.teamB;
    final Team secondTeam = teamAWins ? match.teamB : match.teamA;

    TextStyle firstTeamStyle = firstTeam.score == 12
        ? const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          )
        : const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          );

    TextStyle secondTeamStyle = secondTeam.score == 12
        ? const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          )
        : const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          );

    return SizeTransition(
      sizeFactor: animation,
      child: GestureDetector(
        onTap: () => showMatchActionsSheet(context, match),
        child: Card(
          color: const Color.fromARGB(255, 22, 22, 22),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedStartTime),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${firstTeam.name} ${firstTeam.score}',
                              style: firstTeamStyle,
                            ),
                            if (!isTie && firstTeam.hasWon) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                              ),
                            ]
                          ],
                        ),
                        Text(
                          '${secondTeam.name} ${secondTeam.score}',
                          style: secondTeamStyle,
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          bool response =
                              await _showDeleteDialog(matchKey, index);

                          if (response) {
                            _removeMatch(matchKey, index);
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(String matchKey, int index) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Excluir Partida'),
              content: const Text(
                  'Você tem certeza que deseja excluir esta partida?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Fecha o diálogo
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Fecha o diálogo
                  },
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _removeMatch(String matchKey, int index) {
    final removedMatch = _matchesList.removeAt(index);
    _historyController.deleteMatch(matchKey);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildMatchCard(
          removedMatch.value, removedMatch.key, animation, index),
      duration: const Duration(
          milliseconds:
              130), // Aumentei a duração para 300ms para uma animação mais suave
    );
  }
}
