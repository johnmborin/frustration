import 'package:flutter/material.dart';

import './deck.dart';

class CardWidget extends StatelessWidget {
  static const double width = 50.0;

  static const double height = 80.0;
  final CardModel card;
  final VoidCallback onCardTap;

  CardWidget({required this.card, required this.onCardTap});

  Color getTextColorForSuit(String suit) {
    // Define suits that should display text in red
    const redSuits = ['Hearts', 'Diamonds'];
    return redSuits.contains(suit) ? Colors.red : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    if (card.rank == 'Joker') {
      return InkWell(
          onTap: onCardTap,
          child: Container(
            width: width,
            height: height,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/joker.png',
                    width: 40), // Assume special images for Jokers
                Text('Joker',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none)),
              ],
            ),
          ));
    } else {
      return InkWell(
          onTap: onCardTap,
          child: Container(
            width: width,
            height: height,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(card.rank,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              color: getTextColorForSuit(card.suit))),
                      Image.asset('assets/${card.suit.toLowerCase()}.png',
                          width: 10,
                          height: 10), // Assuming you have suit images
                    ],
                  ),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(card.rank,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                color: getTextColorForSuit(card.suit))),
                        Image.asset('assets/${card.suit.toLowerCase()}.png',
                            width: 10, height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
