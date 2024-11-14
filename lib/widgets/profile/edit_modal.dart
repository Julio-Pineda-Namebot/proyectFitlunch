import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditModal extends StatefulWidget {
  final String title;
  final String currentValue;
  final bool isDropdown;
  final bool isDate;

  const EditModal({
    super.key,
    required this.title,
    required this.currentValue,
    this.isDropdown = false,
    this.isDate = false,
  });

  @override
  EditModalState createState() => EditModalState();
}

class EditModalState extends State<EditModal> {
  String? selectedValue;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentValue;
    controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return AlertDialog(
      title: Text(widget.title, style: const TextStyle(color: Colors.black)),
      content: widget.isDropdown
          ? DropdownButton<String>(
              isExpanded: true,
              value: (selectedValue != null && selectedValue!.isNotEmpty)
                  ? selectedValue
                  : null,
              hint: const Text("Selecciona una opción"),
              items: const [
                DropdownMenuItem(value: "Hombre", child: Text("Hombre")),
                DropdownMenuItem(value: "Mujer", child: Text("Mujer")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
              },
            )
          : widget.isDate
              ? TextField(
                  controller: controller,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: 'Selecciona la fecha',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                )
              : TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Escribe aquí',
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            if (widget.isDropdown) {
              Navigator.of(context).pop(selectedValue);
            } else {
              Navigator.of(context).pop(controller.text);
            }
          },
          child: const Text('Guardar', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
