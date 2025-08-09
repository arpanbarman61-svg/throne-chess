import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess/chess.dart' as chesslib;

void main() {
  runApp(ThroneChessApp());
}

class ThroneChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Throne Chess - Web',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChessHome(),
    );
  }
}

class ChessHome extends StatefulWidget {
  @override
  _ChessHomeState createState() => _ChessHomeState();
}

class _ChessHomeState extends State<ChessHome> {
  final ChessBoardController controller = ChessBoardController();
  chesslib.Chess game = chesslib.Chess();

  void makeAIMove() {
    final moves = game.generate_moves();
    if (moves.isEmpty) return;
    moves.shuffle();
    final chosen = moves.first;
    game.move({
      'from': chosen.fromAlgebraic,
      'to': chosen.toAlgebraic,
      'promotion': chosen.promotion
    });
    controller.makeMove(chosen.fromAlgebraic, chosen.toAlgebraic);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Throne Chess - Web')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ChessBoard(
              controller: controller,
              boardColor: BoardColor.brownGreen,
              onMove: (move) {
                final ok = game.move({
                  'from': move.from,
                  'to': move.to,
                  'promotion': move.promotion
                });
                if (!ok) {
                  controller.resetBoard();
                } else {
                  if (game.turn == chesslib.Color.BLACK) {
                    Future.delayed(Duration(milliseconds: 300), makeAIMove);
                  }
                }
                setState(() {});
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                game = chesslib.Chess();
                controller.resetBoard();
                setState(() {});
              },
              child: Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
