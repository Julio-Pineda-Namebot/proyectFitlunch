import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/components/location_section.dart';
import 'package:fitlunch/widgets/day_button.dart';
import 'package:fitlunch/widgets/menu_item.dart';
import 'package:fitlunch/api/program/program_api.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fitlunch/screens/pages/program/program_modal.dart';

class ProgramaPage extends StatefulWidget {
  const ProgramaPage({super.key});

  @override
  State<ProgramaPage> createState() => ProgramaPageState();
}

class ProgramaPageState extends State<ProgramaPage> {
  final ProgramApi _paymentApi = ProgramApi();
  List<dynamic> _meals = [];
  String _selectedDay = '';

  @override
  void initState() {
    super.initState();

    // Obtener el día actual
    _initializeLocaleAndFetchMeals();
  }

  Future<void> _fetchMeals(String day) async {
    try {
      final meals = await _paymentApi.fetchUserMeals(day);
      setState(() {
        _meals = meals;
        _selectedDay = day;
      });
    } catch (error) {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener las comidas: $error')),
        );
      }
    }
  }

    Map<String, List<dynamic>> _groupMealsByType(List<dynamic> meals) {
    final Map<String, List<dynamic>> groupedMeals = {};
  
    for (var meal in meals) {
      final type = meal['type'] ?? 'Otros';
      if (!groupedMeals.containsKey(type)) {
        groupedMeals[type] = [];
      }
      groupedMeals[type]?.add(meal);
    }
  
    return groupedMeals;
  }

  Future<void> _initializeLocaleAndFetchMeals() async {
    await initializeDateFormatting('es_ES', null);
    final currentDay = DateFormat.EEEE('en_US').format(DateTime.now()); 
    _selectedDay = _convertDayToSpanish(currentDay); 
    _fetchMeals(_selectedDay); 
  }

  String _convertDayToSpanish(String englishDay) {
    switch (englishDay.toLowerCase()) {
      case 'monday':
        return 'Lunes';
      case 'tuesday':
        return 'Martes';
      case 'wednesday':
        return 'Miercoles';
      case 'thursday':
        return 'Jueves';
      case 'friday':
        return 'Viernes';
      case 'saturday':
        return 'Sabado';
      case 'sunday':
        return 'Domingo';
      default:
        return 'Lunes';
    }
  }

  Widget _buildNoMealsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.no_meals,
              size: 30,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'No tienes comidas disponibles',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.grey,
              ),
              SizedBox(width: 4.0),
              Text(
                'para este día',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Mejora tu plan para habilitar este día y acceder a nuestro menú completo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedMeals = _groupMealsByType(_meals);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white, 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de Ubicación
              const LocationSection(),

              // Botones de Días de la Semana
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      DayButton(
                        day: 'Lunes',
                        isSelected: _selectedDay == 'Lunes',
                        onPressed: () {
                          _fetchMeals('Lunes');
                        },
                      ),
                      DayButton(
                        day: 'Martes',
                        isSelected: _selectedDay == 'Martes',
                        onPressed: () {
                          _fetchMeals('Martes');
                        },
                      ),
                      DayButton(
                        day: 'Miércoles',
                        isSelected: _selectedDay == 'Miercoles',
                        onPressed: () {
                          _fetchMeals('Miercoles');
                        },
                      ),
                      DayButton(
                        day: 'Jueves',
                        isSelected: _selectedDay == 'Jueves',
                        onPressed: () {
                          _fetchMeals('Jueves');
                        },
                      ),
                      DayButton(
                        day: 'Viernes',
                        isSelected: _selectedDay == 'Viernes',
                        onPressed: () {
                          _fetchMeals('Viernes');
                        },
                      ),
                      DayButton(
                        day: 'Sabado',
                        isSelected: _selectedDay == 'Sabado',
                        onPressed: () {
                          _fetchMeals('Sabado');
                        },
                      ),
                      DayButton(
                        day: 'Domingo',
                        isSelected: _selectedDay == 'Domingo',
                        onPressed: () {
                          _fetchMeals('Domingo');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Tarjeta de Rastrear Pedido
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FFF7C),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.motorcycle, color: Colors.white, size: 85),
                      SizedBox(width: 10),
                      Text(
                        'RASTREAR\nPEDIDO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Sección de Comidas por Tipo
              if (_meals.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: _buildNoMealsView(),
                )
              else
               ...groupedMeals.entries.map((entry) {
                final type = entry.key;
                final meals = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...meals.map((meal) {
                      return MenuItem(
                        imagePath: meal['image'] ?? 'https://via.placeholder.com/150',
                        title: meal['name'] ?? 'Comida desconocida',
                        calories: '${meal['calories'] ?? 'N/A'} Cal',
                        onTap: () {
                          showMealModal(context, meal, _selectedDay);
                        },
                      );
                    })
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
