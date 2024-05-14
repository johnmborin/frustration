import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import './card.dart';
import './icons.dart';
import './scores.dart';

class CardModel {
  String rank;
  String suit;
  bool isSelected = false;

  CardModel(this.rank, this.suit);

  @override
  String toString() => '$rank of $suit';

  bool get isWild {
    return (rank == '2' || rank == 'Joker' || (rank == 'Jack' && (suit == 'Spades' || suit == 'Clubs')));
  }
}

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int currentPlayerTurn = 0;
  bool pickedCard = false;
  bool waitingDiscard = false;
  bool roundEnding = false;
  bool isMeldMode = false;
  bool canMeld = false;
  int totalPlayers = 2;
  List<List<CardModel>> _playerHands = [];
  List<CardModel> deck = [];
  List<CardModel> discard = [];
  List<List<CardModel>> selectedCards = [];
  List<CardModel> meldCards = [];
  @override
  void initState() {
    super.initState();
    deck = createDeck(1);
    shuffleDeck(deck);
    _playerHands = deal(deck, 2);
    discard = [deck.removeLast()];
  }

  List<CardModel> createDeck(int numDecks) {
    List<String> suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs'];
    List<String> ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'J',
      'Q',
      'K',
      'A'
    ];
    List<CardModel> deck = [];
    for (int decks = 0; decks < numDecks; decks++) {
      for (String suit in suits) {
        for (String rank in ranks) {
          deck.add(CardModel(rank, suit));
        }
      }
      deck.add(CardModel('Joker', '\0'));
      deck.add(CardModel('Joker', '\0'));
    }

    return deck;
  }

  void shuffleDeck(List<CardModel> deck) {
    var random = Random();
    deck.shuffle(random);
  }

  List<List<CardModel>> deal(List<CardModel> deck, int numPlayers) {
    List<List<CardModel>> hands = List.generate(numPlayers, (_) => []);

    for (int card = 0; card < 11; card++) {
      for (int player = 0; player < numPlayers; player++) {
        if (deck.isEmpty) {
          throw Exception('Not enough cards in deck, add more decks');
        }
        hands[player].add(deck.removeLast());
      }
    }

    return hands;
  }
  void roundPrep() {
    
      deck.clear();
    discard.clear();
    for (int i = 0; i < _playerHands.length; i++) {
      _playerHands[i].clear();
    }
    deck = createDeck(1);
    shuffleDeck(deck);
    _playerHands = deal(deck, 2);
    discard = [deck.removeLast()];
    
    
  }
  void rounders() {
    roundEnding = true;
  }

  void addCard(int index) {
    if (!pickedCard && deck.isNotEmpty && _playerHands[index].length < 12) {
      setState(() {
        _playerHands[index].add(deck.removeLast());
        pickedCard = true;
        waitingDiscard = true;
      });
      
    } else if (deck.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No More Cards'),
            content:
                Text('All cards have been dealt, no more cards in the deck.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Can't grab any more cards."),
            content: Text('You can only have 12 cards max'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void removeCard(CardModel card, int index) {
    if (pickedCard && waitingDiscard) {
    setState(() {
      _playerHands[index].remove(card);
      discard.add(card);
      waitingDiscard = false;
      nextTurn();
    });
    }
    
  }

  void pickUpDiscard(int index) {
    
    if (!pickedCard && discard.isNotEmpty && _playerHands[index].length < 12) {
      setState(() {
        _playerHands[index].add(discard.removeLast());
        pickedCard = true;
        waitingDiscard = true;
      });
     
    } else if (_playerHands[index].length >= 12) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Can't grab any more cards."),
            content: Text('You can only have 12 cards max'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void nextTurn() {
    if (!waitingDiscard) {
    setState(() {
      currentPlayerTurn = (currentPlayerTurn +1) % totalPlayers;
      pickedCard = false;
    });
    }
  }
  
  void toggleCardAction(CardModel card, int index) {
    if (isMeldMode) {
      toggleCardSelect(card);
    } else {
      removeCard(card, index);
    }
  }

  void toggleCardSelect(CardModel card) {
    setState(() {
     
      
        selectedCards.add([card]);
        card.isSelected = true;
      
    });
  }

  void toggleMeldMode() {
    setState(() {
      isMeldMode = !isMeldMode;
    });
  }

  bool checkIfSet(List<CardModel> cards) {
    print("Checking");
    if (cards.isEmpty) return false;
    List<CardModel> nonWilds = cards.where((card) => !card.isWild).toList();
    String firstRank = nonWilds.first.rank;
    return nonWilds.every((card) => card.rank == firstRank);
  }

  List<CardModel> identifyWilds(List<CardModel> cards) {
    return cards.where((card)=> card.isWild).toList();
  }

  void checkSets(List<List<CardModel>> selectedSets) {
    setState((){
      for (var set in selectedSets) {
      if (checkIfSet(set)) {
        for (var cardy in set) {
          meldCards.add(cardy);
        }
      }
    }
    });
    
  }
  
  void _showOverlay(BuildContext context) {
    
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
      children: [
        Center(
          
          child: Material(
            elevation: 4.0,
            child: Container(
              padding: EdgeInsets.all(20),
              width: 350, // Specify width for consistent sizing
              height: 650, // Specify height
              color: Colors.white,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        if (overlayEntry != null) {
                          overlayEntry.remove();
                          if (roundEnding) {
                          setState(() {
                            roundPrep();
                          });
                          }
                        }
                      },
                    ),
                  ),
                  Center(
                    child: ScorePage(playerHands: _playerHands, onRoundEnd: rounders),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
      );

      Overlay.of(context)?.insert(overlayEntry);
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 127, 33),
      appBar: AppBar(
        title: Text("Go Back"),
      ),
      body: ConstrainedBox(
     
          constraints: const BoxConstraints(minHeight: CardWidget.height),
          child: Center(
              child: Column(children: [
            //Text("${_playerHands[1].length}"),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _playerHands[1]
                  .map((card) =>
                      CardWidget(card: card, onCardTap: () => currentPlayerTurn == 1 ? toggleCardAction(card, 1) : null))
                  .toList(),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0, bottom: 100.0)),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left:10.0)),
                InkWell(
                  onTap: () => checkSets(selectedCards),
                  child: Text("Meld")/*Container(
                    color: Colors.red,
                    child: Text("Meld")
                  ),*/
                ),
                Padding(padding: EdgeInsets.only(left: 50.0)),
                InkWell(
                  onTap: () {
                    addCard(currentPlayerTurn);
                  },
                  child: CardBackAsset(),
                ),
                Padding(padding: EdgeInsets.only(left: 50.0)),
                if (discard.isNotEmpty)
                  CardWidget(card: discard.last, onCardTap:() => pickUpDiscard(currentPlayerTurn))
                else
                  CardBackAsset(),
                Padding(padding:EdgeInsets.only(left:20.0)),
                InkWell(
                  onTap: () => _showOverlay(context),
                  child: CardBackAsset(),
                ),
                Padding(padding:EdgeInsets.only(left:20.0)),
                InkWell (
                  onTap: () {
                    toggleMeldMode();
                    
                  },
                  child: Text("Select")/*Container(
                    color: Colors.red,
                    child: Text("Select")
                  ),*/
                )
                /*InkWell(
                  onTap: () {},
                  child: CardWidget(card: discard.last, onCardTap: pickUpDiscard,),
                )*/
              ],
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: meldCards.map((card) => CardWidget(card: card, onCardTap: () => currentPlayerTurn == 0 ? toggleCardAction(card, 0) : null)).toList(),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0, bottom: 20.0)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _playerHands[0]
                  .map((card) =>
                      CardWidget(card: card, onCardTap: () => currentPlayerTurn == 0 ? toggleCardAction(card, 0) : null))
                  .toList(),
            )
          ]))),
    );
    /*return Scaffold (
      appBar: AppBar(
        title: Text("Card Game"),
      ),
      body: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Sets number of items in the cross axis (horizontal).
                  childAspectRatio: 0.75, // Adjusts the ratio of the cards' width to height.
                ),
                itemBuilder: (context, cardIndex) => CardWidget(card: _playerHands[0][cardIndex]),
                itemCount: _playerHands[0].length,
                shrinkWrap: true, // Use it to nest a GridView inside a ListView or similar.
                physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              )
      
      /*ExpansionTile(
          title: Text('Player 1 Hand'),
          children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Sets number of items in the cross axis (horizontal).
                  childAspectRatio: 0.8, // Adjusts the ratio of the cards' width to height.
                ),
                itemBuilder: (context, cardIndex) => CardWidget(card: _playerHands[0][cardIndex]),
                itemCount: _playerHands[0].length,
                shrinkWrap: true, // Use it to nest a GridView inside a ListView or similar.
                physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              ),
            ],
        )*/
      
       /*ListView.builder(
        itemCount: _playerHands.length,
        itemBuilder: (context, index) {
          return ExpansionTile (
            title: Text('Player ${index+1} Hand'),
            children: _playerHands[index].map((card) => CardWidget(card: card)).toList(),
          );
        },
      )*/
    );*/
  }
}
