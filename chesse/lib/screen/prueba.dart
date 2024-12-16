import 'package:flutter/material.dart';
import 'dart:collection';

class ChessBoard {
  final int size;
  final String lightSquareColor;
  final String darkSquareColor;
  final Map<String, String> pieces;

  ChessBoard({
    this.size = 8,
    this.lightSquareColor = "white",
    this.darkSquareColor = "black",
  }) : pieces = HashMap();

  bool isValidPosition(String position) {
    if (position.length != 2) return false;

    String col = position[0];
    String row = position[1];

    return col.codeUnitAt(0) >= 97 &&
        col.codeUnitAt(0) < 97 + size && // Columna entre 'a' y 'h'
        int.tryParse(row) != null &&
        int.parse(row) >= 1 &&
        int.parse(row) <= size; // Fila entre 1 y tamaño
  }

  void addPiece(String piece, String position) {
    if (isValidPosition(position)) {
      pieces[position] = piece;
    } else {
      throw Exception("Posición $position no válida.");
    }
  }

  void removePiece(String position) {
    if (pieces.containsKey(position)) {
      pieces.remove(position);
    } else {
      throw Exception("No hay pieza en $position para eliminar.");
    }
  }

  String displayBoard() {
    // Representación textual del tablero
    List<String> rows = [];
    for (int row = size; row >= 1; row--) {
      String currentRow = "";
      for (int col = 0; col < size; col++) {
        String position = "${String.fromCharCode(97 + col)}$row";
        currentRow += pieces[position] != null
            ? "[${pieces[position]}]"
            : "[ ]";
      }
      rows.add(currentRow);
    }
    return rows.join("\n");
  }
}

class ChessBoardWidget extends StatefulWidget {
  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  final ChessBoard chessBoard = ChessBoard();

  void _addPiece(String piece, String position) {
    try {
      setState(() {
        chessBoard.addPiece(piece, position);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pieza $piece añadida en $position.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _removePiece(String position) {
    try {
      setState(() {
        chessBoard.removePiece(position);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pieza eliminada de $position.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tablero de Ajedrez"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: chessBoard.size,
              ),
              itemCount: chessBoard.size * chessBoard.size,
              itemBuilder: (context, index) {
                int row = chessBoard.size - (index ~/ chessBoard.size);
                int col = index % chessBoard.size;
                String position = "${String.fromCharCode(97 + col)}$row";
                bool isLightSquare = (row + col) % 2 == 0;
                String? piece = chessBoard.pieces[position];

                return Container(
                  color: isLightSquare
                      ? Colors.white
                      : Colors.grey,
                  child: Center(
                    child: Text(
                      piece ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addPiece("Knight", "b1");
                  },
                  child: Text("Añadir Caballo en b1"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _removePiece("b1");
                  },
                  child: Text("Eliminar pieza en b1"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChessBoardWidget(),
  ));
}