import 'package:flutter/material.dart';
import 'dart:collection';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
final int size = 8;  //tamaño del tablero
final String lightSquareColor ='white'; 
final String darkSquareColor = 'black';// color de las casillas 

Map<String,String> _pieces = HashMap(); //mapa

void _addPiece(String piece, String position){
  if (_isValidPosition(position)){
    setState(() {
      _pieces[position]=piece;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:Text('Pieza $piece añadida en $position')),
      );
  }else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:Text("posicion $position no valida")),
      );
  }
}
  void _removePiece (String position){
    if (_pieces.containsKey(position)){
      setState(() {
        _pieces.remove(position);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text("pieza eliminada de $position")),
        );   
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text("no hay pieza en la $position para eliminar")),
        );
    }
  }


  bool _isValidPosition(String position){
    if (position.length !=2) return false;
    String col = position[0];
    String row = position[1];

    return col.codeUnitAt(0) >= 97&&
    col.codeUnitAt(0) <97 + size &&
    int.tryParse(row) != null &&
    int.parse(row)>= 1 &&
    int.parse(row) <= size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text("Tablero de ajedrez"),
      ),
      body: Column(
        children: [
          Expanded(child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size,             
              ), 
              itemCount: size * size,
              itemBuilder: (context,index){
                int row = size -(index ~/ size);
                int col = index % size;
                String position = "${String.fromCharCode(97+col)}$row";
                bool isLighSquare = (row + col) % 2 == 0;
                String ? piece = _pieces[position]; 
                return Container(
                  color: isLighSquare
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
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){
                    _addPiece("Knight", "b1");
                  }, 
                  child: Text("añadir caballo en b1"),
                  ),
                 ElevatedButton(
                  onPressed: (){
                    _removePiece( "b1");
                  }, 
                  child: Text("eliminar pieza en b1"),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
