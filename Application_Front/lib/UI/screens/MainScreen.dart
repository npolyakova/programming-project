import 'package:application_front/UI/widgets/MapWidgets/InteractiveMap.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  DraggableScrollableController _dragController = DraggableScrollableController();

  String _selectedRoomName = 'Откуда';

  void _handleRoomTap(String roomName, int roomId) {
   // setState(() {
    _selectedRoomName = roomName;
   // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Карта на весь экран
          Container(
            height: double.infinity,
            color: Colors.grey[200], // Временный фон для карты
            child: InteractiveMap(onRoomTap: _handleRoomTap)
          ),

          DraggableScrollableSheet(
            controller: _dragController,
            initialChildSize: 0.35, // Начальная высота (35% экрана)
            minChildSize: 0.04, // Минимальная высота (4% экрана)
            maxChildSize: 0.9, // Максимальная высота (90% экрана)
            snapAnimationDuration: const Duration(milliseconds: 300),
            snap: true,
            snapSizes: const [0.04, 0.35, 0.9],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const Text('Маршрут',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Поля выбора маршрута (пока заглушки)
                     Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              _selectedRoomName,
                              style: TextStyle(
                                color: _selectedRoomName == 'Откуда' 
                                  ? Colors.grey 
                                  : Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),

                    Container(
                      height: 40, // Уменьшенная высота
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Row(
                        children: [
                          Icon(Icons.location_on, size: 20),
                          SizedBox(width: 8),
                          Text('Куда', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text('Информация о маршруте',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Неинтерактивные информационные поля
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text('Дистанция',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text('Время',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}