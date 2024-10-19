import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marcatruco/features/history/history_controller.dart';
import 'package:marcatruco/models/match.dart';
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
    setState(() {
      _matchesList = _historyController.matches.entries.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico de Partidas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: _matchesList.isEmpty
          ? Center(
              child: Text(
                'Nenhuma partida salva.',
                style: Theme.of(context).textTheme.bodyLarge,
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

    TextStyle firstTeamStyle = (firstTeam.score == 12
            ? Theme.of(context).textTheme.titleLarge
            : Theme.of(context).textTheme.titleMedium)!
        .copyWith(
      fontWeight: FontWeight.bold,
      color: firstTeam.score == 12 ? Colors.amber : null,
    );

    TextStyle secondTeamStyle = (secondTeam.score == 12
            ? Theme.of(context).textTheme.titleLarge
            : Theme.of(context).textTheme.titleMedium)!
        .copyWith(
      fontWeight: FontWeight.bold,
      color: secondTeam.score == 12 ? Colors.amber : null,
    );

    return SizeTransition(
      sizeFactor: animation,
      child: GestureDetector(
        onTap: () => showMatchActionsSheet(context, match),
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedStartTime,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
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
              title: Text(
                'Excluir Partida',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                'Você tem certeza que deseja excluir esta partida?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Fecha o diálogo
                  },
                  child: Text(
                    'Cancelar',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Fecha o diálogo
                  },
                  child: Text(
                    'Excluir',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
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
      duration: const Duration(milliseconds: 130),
    );
  }
}
