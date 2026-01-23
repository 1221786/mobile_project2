import 'package:flutter/material.dart';
import '../services/manager_service.dart';

class EditCarPage extends StatefulWidget {
  final Map<String, dynamic> car;

  const EditCarPage({super.key, required this.car});

  @override
  State<EditCarPage> createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final _service = ManagerService();
  final _dailyPriceCtrl = TextEditingController();
  final _statusCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _dailyPriceCtrl.text = (widget.car["daily_price"] ?? 0).toString();
    _statusCtrl.text = (widget.car["status"] ?? "AVAILABLE").toString();
  }

  @override
  void dispose() {
    _dailyPriceCtrl.dispose();
    _statusCtrl.dispose();
    super.dispose();
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _save() async {
    final carId = int.tryParse(widget.car["car_id"].toString()) ?? 0;
    if (carId <= 0) {
      _toast("Invalid car ID");
      return;
    }

    final status = _statusCtrl.text.trim().toUpperCase();
    if (!["AVAILABLE", "UNAVAILABLE", "MAINTENANCE"].contains(status)) {
      _toast("Invalid status. Use: AVAILABLE, UNAVAILABLE, or MAINTENANCE");
      return;
    }

    setState(() => _loading = true);
    try {
      await _service.updateCarStatus(carId: carId, status: status);
      _toast("Updated ✅");
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _toast(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Car")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "${widget.car["brand"]} ${widget.car["model"]} (${widget.car["model_year"]})",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _dailyPriceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Daily Price",
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            enabled: false, // Price editing can be added later if needed
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _statusCtrl.text,
            decoration: const InputDecoration(
              labelText: "Status",
              prefixIcon: Icon(Icons.info),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "AVAILABLE", child: Text("Available")),
              DropdownMenuItem(value: "UNAVAILABLE", child: Text("Unavailable")),
              DropdownMenuItem(value: "MAINTENANCE", child: Text("Maintenance")),
            ],
            onChanged: (v) => setState(() => _statusCtrl.text = v ?? "AVAILABLE"),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Save Changes"),
            ),
          ),
        ],
      ),
    );
  }
}
