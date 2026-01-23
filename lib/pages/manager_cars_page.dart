import 'package:flutter/material.dart';
import '../core/api_config.dart';
import '../services/manager_service.dart';
import '../services/car_service.dart';
import '../models/car.dart';
import 'car_details_page.dart';
import 'edit_car_page.dart';

class ManagerCarsPage extends StatefulWidget {
  const ManagerCarsPage({super.key});

  @override
  State<ManagerCarsPage> createState() => _ManagerCarsPageState();
}

class _ManagerCarsPageState extends State<ManagerCarsPage> {
  final _service = ManagerService();
  final _carService = CarService();
  final _searchCtrl = TextEditingController();
  bool _loading = false;
  List<Map<String, dynamic>> _cars = [];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCars() async {
    setState(() => _loading = true);
    try {
      final cars = await _service.getAllCars();
      setState(() => _cars = cars);
    } catch (e) {
      _toast(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _imgUrl(String? name) {
    if (name == null || name.trim().isEmpty) return "";
    if (name.startsWith("http")) return name;
    return "${ApiConfig.carsImagesBase}/$name";
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "AVAILABLE":
        return Colors.green;
      case "UNAVAILABLE":
      case "BOOKED":
        return Colors.red;
      case "MAINTENANCE":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateCarStatus(int carId, String currentStatus) async {
    final newStatus = currentStatus.toUpperCase() == "AVAILABLE" ? "UNAVAILABLE" : "AVAILABLE";
    
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Status?"),
        content: Text("Change car status to $newStatus?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _service.updateCarStatus(carId: carId, status: newStatus);
      _toast("Status updated ✅");
      _loadCars();
    } catch (e) {
      _toast(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  Future<void> _editCar(Map<String, dynamic> car) async {
    final ok = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCarPage(car: car)),
    );
    if (ok == true) _loadCars();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCars = _searchCtrl.text.isEmpty
        ? _cars
        : _cars.where((c) {
            final query = _searchCtrl.text.toLowerCase();
            final brand = (c["brand"] ?? "").toString().toLowerCase();
            final model = (c["model"] ?? "").toString().toLowerCase();
            return brand.contains(query) || model.contains(query);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Cars"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCars),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: "Search by brand/model",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() {}),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filteredCars.isEmpty
                    ? const Center(child: Text("No cars found"))
                    : ListView.builder(
                        itemCount: filteredCars.length,
                        itemBuilder: (context, i) {
                          final c = filteredCars[i];
                          final status = (c["status"] ?? "").toString();
                          final coverUrl = _imgUrl(c["cover_url"]);

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: coverUrl.isEmpty
                                    ? Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.black12,
                                        child: const Icon(Icons.directions_car),
                                      )
                                    : Image.network(
                                        coverUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                                      ),
                              ),
                              title: Text("${c["brand"]} ${c["model"]} (${c["model_year"]})"),
                              subtitle: Text("${c["type"]} • \$${c["daily_price"]}/day"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _statusColor(status).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _statusColor(status)),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: _statusColor(status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                        value: "view",
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility, size: 20),
                                            SizedBox(width: 8),
                                            Text("View Details"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: "edit",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text("Edit"),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: "toggle",
                                        child: Row(
                                          children: [
                                            Icon(Icons.swap_horiz, size: 20),
                                            SizedBox(width: 8),
                                            Text(status.toUpperCase() == "AVAILABLE" ? "Set Unavailable" : "Set Available"),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      final carId = int.tryParse(c["car_id"].toString()) ?? 0;
                                      if (value == "view") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => CarDetailsPage(carId: carId)),
                                        );
                                      } else if (value == "edit") {
                                        _editCar(c);
                                      } else if (value == "toggle") {
                                        _updateCarStatus(carId, status);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
