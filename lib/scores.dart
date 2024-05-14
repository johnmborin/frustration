import 'package:flutter/material.dart';
import './deck.dart';
import './card.dart';
import 'dart:math';

class ScorePage extends StatefulWidget {
  final List<List<CardModel>> playerHands;
  final Function onRoundEnd;

  ScorePage({required this.playerHands, required this.onRoundEnd});

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List <List<int>> playerScores = [];


  @override
  void initState() {
    super.initState();
    setState(() {
      if (playerScores.isEmpty) {
        playerScores = List.generate(widget.playerHands.length, (_) => <int>[]);
      }
    });
  }

  void calculateScores() {
    setState(() {
      
      for (int i = 0; i < widget.playerHands.length; i++) {
        int roundScore = widget.playerHands[i].fold(0, (prev, card) => prev + scoreForCard(card));
        playerScores[i].add(roundScore);
      }
    });
  }

  int scoreForCard(CardModel card) {
    if (card.rank == '2' || card.rank == 'Joker' || (card.rank == 'J' && (card.suit == 'Spades' || card.suit == 'Clubs'))) {
      return 20;
    } else if (card.rank == '10' || card.rank == 'J' || card.rank == 'Q' || card.rank == 'K') {
      return 10;
    } else if (card.rank == 'A') {
      return 15;
    } else {
      return 5;
    }
  }

  List<TableRow> _buildScoreRows() {
    print("Working");
    roundEndCheck();
    int maxRounds = playerScores.map((scores) => scores.length).reduce(max);
    return List.generate(maxRounds, (roundIndex) {
      return TableRow(
        children: playerScores.map((scores) => TableCell(child: Center(child: Text('${scores[roundIndex]}')))).toList(),
      );
    });
  }

  void roundEndCheck() {
    for (int i = 0; i < widget.playerHands.length; i++) {
      if (widget.playerHands[i].isEmpty) {
        endRound(i);
        break;
      }
    }
  }

  void endRound(int playerIndex) {
    
    calculateScores();
    widget.onRoundEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: FixedColumnWidth(120.0),
          border: TableBorder(
            verticalInside: BorderSide(width: 1, color: Colors.black),
            horizontalInside: BorderSide(width:1, color: Colors.black)
            
            ),
          children: [
            TableRow(
            
              children: [
               // Empty top-left cell for alignment
                ...List.generate(widget.playerHands.length, (index) => TableCell(
                  child: Center(child: Text('Player ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)))
                )),
              ],
            ),
            ..._buildScoreRows(),
          ],
        ),
      )
    );
  }


}