import 'package:flutter/material.dart';
import '../../core/session.dart';
import '../login_page.dart';
import '../../services/manager_service.dart';
import '../add_car_page.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  final _service = ManagerService();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchStats();
  }

  Future<void> _logout() async {
    await Session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  void _refresh() {
    setState(() => _future = _service.fetchStats());
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Widget _card(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title),
      ),
    );
  }

  double _toDouble(dynamic v) => double.tryParse(v.toString()) ?? 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final d = snap.data ?? {};
          final cars = (d["cars"] ?? {}) as Map<String, dynamic>;
          final revenue = (d["revenue"] ?? {}) as Map<String, dynamic>;

          final today = _toDouble(revenue["today"]);
          final week = _toDouble(revenue["week"]);

          return RefreshIndicator(
            onRefresh: () async {
              _refresh();
              await _future;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Manager Actions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // ✅ MR-02 فتح صفحة إضافة سيارة
                _actionBtn(
                  title: "Add Car (MR-02)",
                  icon: Icons.add_circle_outline,
                  onTap: () async {
                    final ok = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddCarPage()),
                    );

                    // لو رجعت true من AddCarPage -> refresh
                    if (ok == true) _refresh();
                  },
                ),
                const SizedBox(height: 10),

                _actionBtn(
                  title: "Cars List (Coming soon)",
                  icon: Icons.directions_car_filled_outlined,
                  onTap: () => _toast("Next: manager cars list + edit"),
                ),
                const SizedBox(height: 10),

                _actionBtn(
                  title: "Accidents (Coming soon)",
                  icon: Icons.report,
                  onTap: () => _toast("Next: MR-05 accident decisions"),
                ),
                const SizedBox(height: 10),

                _actionBtn(
                  title: "Employees (Coming soon)",
                  icon: Icons.people_outline,
                  onTap: () => _toast("Next: MR-06 enable/disable employee"),
                ),
                const SizedBox(height: 18),

                const Text(
                  "Stats",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                _card(
                  "Available Cars",
                  (cars["available"] ?? 0).toString(),
                  Icons.directions_car,
                  Colors.green,
                ),
                _card(
                  "Unavailable Cars",
                  (cars["unavailable"] ?? 0).toString(),
                  Icons.block,
                  Colors.red,
                ),
                _card(
                  "In Maintenance",
                  (cars["maintenance"] ?? 0).toString(),
                  Icons.build,
                  Colors.orange,
                ),
                const SizedBox(height: 10),
                _card(
                  "New Bookings",
                  (d["new_bookings"] ?? 0).toString(),
                  Icons.receipt_long,
                  Colors.blue,
                ),
                const SizedBox(height: 10),
                _card(
                  "Revenue Today",
                  "\$${today.toStringAsFixed(2)}",
                  Icons.attach_money,
                  Colors.green,
                ),
                _card(
                  "Revenue This Week",
                  "\$${week.toStringAsFixed(2)}",
                  Icons.trending_up,
                  Colors.purple,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
