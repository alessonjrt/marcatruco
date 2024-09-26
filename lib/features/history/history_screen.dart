import 'package:cardmate/features/history/history_controller.dart';
import 'package:cardmate/models/match.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryController _historyController;

  @override
  void initState() {
    _historyController = HistoryController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Histórico de Partidas'),
          centerTitle: true,
        ),
        body: AnimatedBuilder(
          animation: _historyController,
          builder: (context, child) {
            final matches = _historyController.matches;

            return matches.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma partida salva.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      String matchKey = matches.keys.elementAt(index);
                      final match = matches[matchKey];
                      return _buildMatchCard(match!);
                    },
                  );
          },
        ));
  }

  /// Constrói o cartão para cada partida
  Widget _buildMatchCard(Match match) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                match.teamA.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${match.teamA.score} - ${match.teamB.score}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                match.teamB.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Início: ${match.startTime}'),
                if (match.isGameOver && match.endTime != null)
                  Text('Fim: ${match.endTime}'),
              ],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(match.id),
          ),
        ));
  }

  Future<void> _confirmDelete(String id) async {
    bool delete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Deletar Partida'),
              content:
                  const Text('Tem certeza de que deseja deletar esta partida?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    'Deletar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (delete) {
      _historyController.deleteMatch(id);
    }
  }
}
