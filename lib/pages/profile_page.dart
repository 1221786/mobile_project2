import 'package:flutter/material.dart';
import '../core/session.dart';
import '../services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _service = ProfileService();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  bool _saving = false;
  bool _changingPass = false;

  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadFromSession();
  }

  Future<void> _loadFromSession() async {
    final u = await Session.getUser();
    if (u == null) return;

    setState(() {
      _userId = int.tryParse(u["user_id"].toString()) ?? 0;
    });

    _nameCtrl.text = (u["full_name"] ?? "").toString();
    _emailCtrl.text = (u["email"] ?? "").toString();
    _phoneCtrl.text = (u["phone"] ?? "").toString();
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _saveProfile() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (_userId <= 0) {
      _toast("Invalid user");
      return;
    }
    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      _toast("Please fill all fields");
      return;
    }

    setState(() => _saving = true);
    try {
      final res = await _service.updateProfile(
        userId: _userId,
        fullName: name,
        email: email,
        phone: phone,
      );

      final updatedUser = Map<String, dynamic>.from(res["user"]);
      await Session.saveUser(updatedUser);

      _toast("Saved ✅");
      if (mounted) Navigator.pop(context, true); // يرجع true عشان الداشبورد يحدث لو بدك
    } catch (e) {
      _toast(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _updatePassword() async {
    final oldP = _oldPassCtrl.text;
    final newP = _newPassCtrl.text;

    if (_userId <= 0) {
      _toast("Invalid user");
      return;
    }
    if (oldP.isEmpty || newP.isEmpty) {
      _toast("Fill old & new password");
      return;
    }

    setState(() => _changingPass = true);
    try {
      await _service.changePassword(
        userId: _userId,
        oldPassword: oldP,
        newPassword: newP,
      );

      _oldPassCtrl.clear();
      _newPassCtrl.clear();

      _toast("Password updated ✅");
    } catch (e) {
      _toast(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _changingPass = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: "Name",
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(
              labelText: "Phone",
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveProfile,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Save Changes"),
            ),
          ),

          const SizedBox(height: 28),
          const Text(
            "Change Password (Optional)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _oldPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Old Password",
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "New Password",
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _changingPass ? null : _updatePassword,
              child: _changingPass
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Update Password"),
            ),
          ),
        ],
      ),
    );
  }
}
