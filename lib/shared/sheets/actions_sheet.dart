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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Histórico de Ações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Expanded(
              child: match.actions.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma ação registrada.',
                        style: Theme.of(context).textTheme.bodyLarge,
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
                          actionDescription =
                              '${team.name} adicionou ${action.points} ponto(s).';
                        } else if (action.type == ActionType.subtract) {
                          actionDescription =
                              '${team.name} removeu ${action.points} ponto(s).';
                        } else {
                          actionDescription =
                              '${action.otherTeam?.name} correu adicionando ${action.points} ponto(s) para ${action.team.name}.';
                        }

                        return ListTile(
                          leading: _getActionIcon(context, action.type),
                          title: Text(
                            actionDescription,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            _formatTimestamp(action.timestamp),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
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

Icon _getActionIcon(BuildContext context, ActionType type) {
  switch (type) {
    case ActionType.add:
      return Icon(Icons.add, color: Theme.of(context).colorScheme.primary);
    case ActionType.subtract:
      return Icon(Icons.remove, color: Theme.of(context).colorScheme.error);
    case ActionType.fold:
      return Icon(Icons.directions_run,
          color: Theme.of(context).colorScheme.secondary);
    default:
      return Icon(Icons.help_outline,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6));
  }
}
