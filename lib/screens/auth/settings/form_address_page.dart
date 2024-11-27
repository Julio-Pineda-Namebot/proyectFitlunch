import 'package:fitlunch/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlunch/api/forms/distric_service.dart';
import 'package:fitlunch/api/auth/settings/api_address.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';
import 'package:flutter/services.dart';

class DirectionPage extends StatefulWidget {
  final Map<String, dynamic>? initialData; 
  
  const DirectionPage({super.key, this.initialData});
  
  @override
  DirectionPageState createState() => DirectionPageState();
}

class DirectionPageState extends State<DirectionPage> {
  Map<String, dynamic>? selectedDepartment;
  Map<String, dynamic>? selectedProvince;
  Map<String, dynamic>? selectedDistrict;
  String? selectedStreetType;
  bool noNumber = false;
  bool isWork = false;
  
  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> districts = [];
  List<String> streetTypes  = ['Avenida','Calle','Jiron'];
  
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController streetTypeController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

  final colorScheme = AppTheme.lightTheme.colorScheme;
  final ApiDireccion apiDireccion = ApiDireccion();
  
  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadDepartments();

    if (widget.initialData != null) {
      final data = widget.initialData!;
      nameController.text = data['nombre'] ?? '';
      selectedStreetType = data['tipo_calle'];
      streetNameController.text = data['nombre_calle'] ?? '';
      numberController.text = data['numero'] ?? '';
      floorController.text = data['piso_departamento'] ?? '';
      phoneController.text = data['telefono_contacto'] ?? '';
      referenceController.text = data['referencias'] ?? '';
      isWork = data['tipo_direccion'] == 'Trabajo';
      noNumber = data['numero'] == null;

      // Encuentra el departamento por nombre y asígnalo a selectedDepartment
      selectedDepartment = departments.firstWhere(
        (dept) => dept['nombre'] == data['departamento']['nombre'],
        orElse: () => {}, 
      );

      if (selectedDepartment != null) { 
        await _loadProvinces(selectedDepartment!['id']); 

        // Encuentra la provincia por nombre y asígnalo a selectedProvince
        selectedProvince = provinces.firstWhere(
          (prov) => prov['nombre'] == data['provincia']['nombre'],
          orElse: () => {},
        );

        if (selectedProvince != null) {
          await _loadDistricts(selectedProvince!['id']);

          // Encuentra el distrito por nombre y asígnalo a selectedDistrict
          selectedDistrict = districts.firstWhere(
            (dist) => dist['nombre'] == data['distrito']['nombre'],
            orElse: () => {},
          );
        }
      }

      setState(() {}); 
    }
  }

  Future<void> _loadDepartments() async {
    try {
      final service = ProvinciaDistritoService();
      final data = await service.getDepartamentos();
      setState(() {
        departments = data.map((item) => {'nombre': item['nombre'], 'id': item['id']}).toList();
      });
    } catch (error) {
       if (mounted) {
          FlashMessage.showError(context, "Error al guardar la dirección: $error");
        }
    }
  }

  Future<void> _loadProvinces(int departmentId) async {
    try {
      final service = ProvinciaDistritoService();
      final data = await service.getProvincias(departmentId);
      setState(() {
        provinces = data.map((item) => {'nombre': item['nombre'], 'id': item['id']}).toList();
        selectedProvince = null;
        districts = [];
        selectedDistrict = null;
      });
    } catch (error) {
       if (mounted) {
          FlashMessage.showError(context, "Error al guardar la dirección: $error");
        }
    }
  }

  Future<void> _loadDistricts(int provinceId) async {
    try {
      final service = ProvinciaDistritoService();
      final data = await service.getDistritos(provinceId);
      setState(() {
        districts = data.map((item) => {'nombre': item['nombre'], 'id': item['id']}).toList();
        selectedDistrict = null;
      });
    } catch (error) {
       if (mounted) {
          FlashMessage.showError(context, "Error al guardar la dirección: $error");
        }
    }
  }
  
  // Guardar dirección
  Future<void> _saveDirection() async {
    if (_formKey.currentState!.validate()) {
      try {

        final direccionData = {
          'nombre': nameController.text,
          'departamentoId': selectedDepartment!['id'], 
          'provinciaId': selectedProvince!['id'], 
          'distritoId': selectedDistrict!['id'],
          'tipo_calle': selectedStreetType,
          'nombre_calle': streetNameController.text,
          'numero': noNumber ? null : numberController.text,
          'piso_departamento': floorController.text,
          'tipo_direccion': isWork ? 'Trabajo' : 'Casa',
          'telefono_contacto': phoneController.text,
          'referencias': referenceController.text,
        };

        final apiDireccion = ApiDireccion();

        if (widget.initialData != null && widget.initialData!['N_ID_DIRECCION'] != null) {
          // Actualizar dirección existente
          await apiDireccion.updateDireccion(widget.initialData!['N_ID_DIRECCION'], direccionData);
          if (mounted) {

            FlashMessage.showSuccess(context, "Dirección actualizada correctamente");
          }
        } else {
          // Agregar nueva dirección
          await apiDireccion.addDireccion(direccionData);
          if (mounted) {
            FlashMessage.showSuccess(context, "Dirección guardada correctamente");
          }
        }

        // Reiniciar formulario
        _formKey.currentState?.reset();
        setState(() {
          selectedDepartment = null;
          selectedProvince = null;
          selectedDistrict = null;
          selectedStreetType = null;
          noNumber = false;
        });
      } catch (error) {
        if (mounted) {
          FlashMessage.showError(context, "Error al guardar la dirección: $error");
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agregar domicilio', style: TextStyle(color: Colors.white) ),
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre y apellido',
                  labelStyle: const TextStyle(fontSize: 16),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre y apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Map<String, dynamic>>(
                value: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Departamento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: departments.map((department) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: department,
                    child: Text(department['nombre'], style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                    _loadProvinces(value!['id']);
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Map<String, dynamic>>(
                value: selectedProvince,
                decoration: InputDecoration(
                  labelText: 'Provincia',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: provinces.map((province) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: province,
                    child: Text(province['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value;
                    _loadDistricts(value!['id']);
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Map<String, dynamic>>(
                value: selectedDistrict,
                decoration: InputDecoration(
                  labelText: 'Distrito',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: districts.map((district) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: district,
                    child: Text(district['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStreetType,
                decoration: InputDecoration(
                  labelText: 'Tipo de calle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: streetTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStreetType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: streetNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la calle',
                  hintText: 'Ej.: Calle Lima',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: numberController,
                      enabled: !noNumber,
                      decoration: InputDecoration(
                        labelText: 'Número',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, 
                      ],
                      validator: (value) {
                        if (!noNumber && (value == null || value.isEmpty)) {
                          return 'Por favor ingrese el número';
                        }
                        if (!noNumber && int.tryParse(value!) == null) {
                          return 'Ingrese solo números';
                        }
                        return null;
                      },
                    ),
                  ),
                  Checkbox(
                    value: noNumber,
                    activeColor: colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        noNumber = value!;
                        if (noNumber) numberController.clear();
                      });
                    },
                  ),
                  const Text("Sin número"),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: floorController,
                decoration: InputDecoration(
                  labelText: 'Piso/Departamento (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Selecciona el tipo de dirección:",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isWork,
                    onChanged: (value) {
                      setState(() {
                        isWork = value!;
                      });
                    },
                  ),
                  const Icon(Icons.work), 
                  const Text("Trabajo"),
                ],
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: isWork,
                    onChanged: (value) {
                      setState(() {
                        isWork = value!;
                      });
                    },
                  ),
                  const Icon(Icons.home),
                  const Text("Casa"),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono de contacto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, 
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un teléfono de contacto';
                  }
                  if (value.length != 9) {
                    return 'El teléfono debe tener 9 digitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: referenceController,
                decoration: InputDecoration(
                  labelText: 'Referencia',
                  hintText: 'Referencia de la fachadada',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLength: 120, 
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una referencia';
                  }
                  if (value.split(' ').length > 120) {
                    return 'La referencia no puede superar las 120 palabras';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveDirection();
                    //Regresar al apartado de direccion
                    if (context.mounted) { // Verifica si el widget todavía está en el árbol
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: const Text(
                  'Guardar dirección',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
