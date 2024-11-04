import 'package:flutter/material.dart';

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
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentValue;
    dateController.text = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: dateController,
                  decoration: const InputDecoration(
                    hintText: 'Selecciona la fecha',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                )
              : TextField(
                  controller: TextEditingController(text: widget.currentValue),
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
            Navigator.of(context).pop(selectedValue ?? dateController.text);
          },
          child: const Text('Guardar', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
