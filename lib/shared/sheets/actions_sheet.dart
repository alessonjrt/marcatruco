import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marcatruco/models/match.dart';
import 'package:marcatruco/models/match_action.dart';

void showMatchActionsSheet(BuildContext context, Match match) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Histórico de Ações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Expanded(
              child: match.actions.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma ação registrada.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: match.actions.length,
                      itemBuilder: (context, index) {
                        final action = match.actions[index];
                        final team = action.team.id == match.teamA.id
                            ? match.teamA
                            : match.teamB;
                            

                        String actionDescription;
                        if (action.type == ActionType.add) {
                          actionDescription = '${team.name} adicionou ${action.points} ponto(s).';
                        } else if (action.type == ActionType.subtract) {
                          actionDescription = '${team.name} removeu ${action.points} ponto(s).';
                        } else {
                          actionDescription = '${action.otherTeam?.name} correu adicionando ${action.points} ponto(s) para ${action.team.name}.';
                        }

                        return ListTile(
                          leading: _getActionIcon(action.type),
                          title: Text(
                            actionDescription,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            _formatTimestamp(action.timestamp),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}

String _formatTimestamp(DateTime timestamp) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
  return formatter.format(timestamp);
}

Icon _getActionIcon(ActionType type) {
  switch (type) {
    case ActionType.add:
      return const Icon(Icons.add, color: Colors.green);
    case ActionType.subtract:
      return const Icon(Icons.remove, color: Colors.red);
    case ActionType.fold:
      return const Icon(Icons.directions_run, color: Colors.purple);
    default:
      return const Icon(Icons.help_outline, color: Colors.grey);
  }
}
