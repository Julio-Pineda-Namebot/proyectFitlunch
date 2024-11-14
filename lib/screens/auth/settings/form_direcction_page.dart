import 'package:fitlunch/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlunch/api/auth/form/distric_service.dart';

class DirectionPage extends StatefulWidget {
  const DirectionPage({super.key});
  @override
  DirectionPageState createState() => DirectionPageState();
}

class DirectionPageState extends State<DirectionPage> {
  String? selectedDepartment;
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedStreetType;
  bool noNumber = false;

  List<String> departments = [];
  List<String> provinces = [];
  List<String> districts = [];
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

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      final service = ProvinciaDistritoService();
      final data = await service.getDepartamentos();
      setState(() {
        departments = data.map((item) => item['nombre'] as String).toList();
      });
    } catch (error) {
    }
  }

  Future<void> _loadProvinces(String department) async {
    try {
      final service = ProvinciaDistritoService();
      final data = await service.getProvincias();
      setState(() {
        provinces = data.map((item) => item['nombre'] as String).toList();
        selectedProvince = null;
        districts = [];
        selectedDistrict = null;
      });
    } catch (error) {
    }
  }

  Future<void> _loadDistricts(String province) async {
    try {
      final service = ProvinciaDistritoService();
      final data = await service.getDistritos(1);
      setState(() {
        districts = data.map((item) => item['nombre'] as String).toList();
        selectedDistrict = null;
      });
    } catch (error) {
      
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar domicilio'),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre y apellido',
                  hintText: 'Tal cual figure en el DNI',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre y apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Departamento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: departments.map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                    _loadProvinces(value!);
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedProvince,
                decoration: InputDecoration(
                  labelText: 'Provincia o distrito',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: provinces.map((province) {
                  return DropdownMenuItem<String>(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value;
                    _loadDistricts(value!);
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDistrict,
                decoration: InputDecoration(
                  labelText: 'Distrito',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
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
                  hintText: 'Ej.: Javier Prado',
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
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono de contacto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: referenceController,
                decoration: InputDecoration(
                  labelText: 'Referencia',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Lógica de guardar dirección
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
