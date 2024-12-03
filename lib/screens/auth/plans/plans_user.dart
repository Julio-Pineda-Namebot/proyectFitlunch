import 'package:flutter/material.dart';
import 'package:fitlunch/api/plans/plans_service.dart';

class PlansUser extends StatefulWidget {
  const PlansUser({super.key});

  @override
  State<PlansUser> createState() => PlansUserState();
}

class PlansUserState extends State<PlansUser> {
  final PlansService _plansService = PlansService();
  Map<String, dynamic>? _planDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlanDetails();
  }

  Future<void> _fetchPlanDetails() async {
    try {
      final planDetails = await _plansService.getPlanDetails();
      setState(() {
        _planDetails = planDetails;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildNoPlansView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'No tienes un plan activo',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Actualmente no estás inscrito en ningún plan.\nCuando te suscribas a uno, aparecerá aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2BC155), // Fondo verde
        foregroundColor: Colors.white, // Letras blancas
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : (_planDetails != null && _planDetails!.isNotEmpty)
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen del plan
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              _planDetails!['planImage'] ??
                                  'https://via.placeholder.com/300', // Imagen por defecto
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Nombre del plan
                      Text(
                        _planDetails!['planTitle'] ?? 'Sin título',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Descripción del plan
                      Text(
                        _planDetails!['planDescription'] ?? 'Sin descripción',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      // Duración del plan
                      Text(
                        'Duración: ${_planDetails!['planDuration'] ?? 'Desconocida'} días',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      // Tiempo restante
                      Text(
                        'Plan finaliza en ${_planDetails!['timeRemaining'] ?? '0'} días',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      // Fecha de finalización
                      Text(
                        'Fecha de finalización: ${formatDate(_planDetails!['timeRemaining'] ?? 0)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ): _buildNoPlansView(),
    );
  }

  String formatDate(int daysRemaining) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: daysRemaining));
    return '${endDate.year}/${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}';
  }
}
