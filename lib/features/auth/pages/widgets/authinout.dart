import 'package:flutter/material.dart';

class Authinput extends StatefulWidget {
  final String hint;
  bool isPassword;
  final TextEditingController customController;
  Authinput(
      {super.key,
      required this.hint,
      required this.customController,
      this.isPassword = false});

  @override
  State<Authinput> createState() => _AuthinputState();
}

class _AuthinputState extends State<Authinput> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return widget.isPassword == false
        ? TextField(
            controller: widget.customController,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w600),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.onPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          )
        : TextField(
            obscureText: isHidden,
            controller: widget.customController,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  icon:
                      Icon(isHidden ? Icons.visibility : Icons.visibility_off)),
              hintText: widget.hint,
              hintStyle: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w600),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.onPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          );
  }
}
