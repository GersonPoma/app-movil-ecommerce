import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../application/cart_bloc/cart_bloc.dart';
import '../../domain/entities/cart/cart_item.dart';
import '../../domain/entities/product/product.dart';

class VoiceCommandButton extends StatefulWidget {
  const VoiceCommandButton({Key? key}) : super(key: key);

  @override
  _VoiceCommandButtonState createState() => _VoiceCommandButtonState();
}

class _VoiceCommandButtonState extends State<VoiceCommandButton> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          _interpretCommand(result.recognizedWords);
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _interpretCommand(String text) {
    final lower = text.toLowerCase();
    final addMatch = RegExp(r'agregar\s+(\d+)?\s*(.+)', caseSensitive: false);
    final removeMatch = RegExp(r'quitar\s+(\d+)?\s*(.+)', caseSensitive: false);

    if (addMatch.hasMatch(lower)) {
      final match = addMatch.firstMatch(lower)!;
      final cantidad = int.tryParse(match.group(1) ?? '1') ?? 1;
      final nombre = match.group(2)!.trim();

      context.read<CartBloc>().add(AddProduct(
            cartItem: CartItem(
              product: ProductEntity(
                id: 0, // Esto lo debes mapear con tu lista real de productos
                nombre: nombre,
                descripcion: '',
                precio: 0,
                stock: 0,
                imagenUrl: '',
                fechaCreacion: DateTime.now(),
              ),
              cantidad: cantidad,
            ),
          ));
    } else if (removeMatch.hasMatch(lower)) {
      final match = removeMatch.firstMatch(lower)!;
      final cantidad = int.tryParse(match.group(1) ?? '1') ?? 1;
      final nombre = match.group(2)!.trim();

      // Aquí deberías buscar el producto en el carrito por nombre
      // y reducir su cantidad o eliminarlo
      // Ejemplo: CartBloc -> AddProduct con cantidad negativa
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _isListening ? _stopListening : _startListening,
      child: Icon(_isListening ? Icons.mic_off : Icons.mic),
    );
  }
}
