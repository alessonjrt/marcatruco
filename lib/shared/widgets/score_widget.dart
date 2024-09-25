import 'package:flutter/material.dart';

class ScoreWidget extends StatefulWidget {
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
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  bool _isInverted = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _isInverted = !_isInverted;
          });
        },
        child: Transform(
          alignment: Alignment.center,
          transform:
              _isInverted ? Matrix4.rotationX(3.14159) : Matrix4.identity(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                initialValue: widget.teamName,
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
                widget.score.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 62),
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
                      onPressed: widget.onSubtract),
                  IconButton(
                      color: Colors.green,
                      icon: const Icon(
                        Icons.add,
                      ),
                      onPressed: widget.onAdd),
                ],
              ),
              TextButton.icon(
                  label: const Text(
                    'truco!',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
