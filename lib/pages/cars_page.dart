import 'package:flutter/material.dart';
import '../models/car.dart';
import '../services/car_service.dart';
import 'car_details_page.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({super.key});

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final _service = CarService();
  final _searchCtrl = TextEditingController();

  final _types = const ["ALL", "SUV", "SEDAN", "HATCHBACK", "VAN", "PICKUP", "LUXURY"];
  String _selectedType = "ALL";

  RangeValues _priceRange = const RangeValues(0, 200);
  bool _loading = false;
  List<Car> _cars = [];

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
      final cars = await _service.fetchCars(
        type: _selectedType,
        query: _searchCtrl.text,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
      );
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

  Widget _statusBadge(String status) {
    final s = status.toUpperCase();
    final isBooked = (s == "BOOKED");

    final text = isBooked ? "محجوزة" : "متاحة";
    final color = isBooked ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cars")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                        onChanged: (v) {
                          setState(() => _selectedType = v!);
                          _loadCars();
                        },
                        decoration: const InputDecoration(
                          labelText: "Type",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _loadCars,
                      icon: const Icon(Icons.refresh),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    labelText: "Search brand/model",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _loadCars,
                    ),
                  ),
                  onSubmitted: (_) => _loadCars(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Price Range"),
                    const SizedBox(width: 10),
                    Text("\$${_priceRange.start.toStringAsFixed(0)} - \$${_priceRange.end.toStringAsFixed(0)}"),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 200,
                  divisions: 20,
                  labels: RangeLabels(
                    _priceRange.start.toStringAsFixed(0),
                    _priceRange.end.toStringAsFixed(0),
                  ),
                  onChanged: (v) => setState(() => _priceRange = v),
                  onChangeEnd: (_) => _loadCars(),
                ),
              ],
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _cars.isEmpty
                    ? const Center(child: Text("No cars found"))
                    : ListView.builder(
                        itemCount: _cars.length,
                        itemBuilder: (context, i) {
                          final c = _cars[i];
                          final isBooked = c.status.toUpperCase() == "BOOKED";

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  c.coverUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                                ),
                              ),
                              title: Text("${c.brand} ${c.model} (${c.year})"),
                              subtitle: Text("${c.type} • ${c.transmission} • \$${c.dailyPrice}/day"),
                              trailing: _statusBadge(c.status),

                              // ✅ منع فتح التفاصيل إذا السيارة محجوزة الآن
                              onTap: () {
                                if (isBooked) {
                                  _toast("هاي السيارة محجوزة حالياً ✅ جرّب سيارة ثانية");
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => CarDetailsPage(carId: c.id)),
                                );
                              },
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
