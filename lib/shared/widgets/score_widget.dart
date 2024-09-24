import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final String teamName;
  final int score;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;

  const ScoreWidget(
      {super.key,
      required this.teamName,
      required this.score,
      required this.onAdd,
      required this.onSubtract});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          initialValue: teamName,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        Text(
         score.toString(),
         
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 62),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: onSubtract),
            IconButton(
                color: Colors.green,
                icon: Icon(
                  Icons.add,
                ),
                onPressed: onAdd),
          ],
        ),
        TextButton.icon(
            label: Text(
              'truco!',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {},
            icon: Icon(
              Icons.local_fire_department,
              color: Colors.red,
            ))
      ],
    );
  }
}
