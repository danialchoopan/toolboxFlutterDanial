import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class NetworkToolsScreen extends StatelessWidget {
  const NetworkToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'title': 'آدرس IP', 'icon': Icons.wifi, 'color': AppColors.turquoise, 'page': const IpAddressScreen()},
      {'title': 'اطلاعات دستگاه', 'icon': Icons.phone_android, 'color': AppColors.persianBlue, 'page': const DeviceInfoScreen()},
      {'title': 'سلامت باتری', 'icon': Icons.battery_std, 'color': AppColors.mint, 'page': const BatteryScreen()},
      {'title': 'DNS Lookup', 'icon': Icons.dns, 'color': AppColors.coral, 'page': const DnsLookupScreen()},
      {'title': 'Ping', 'icon': Icons.network_check, 'color': AppColors.dailyToolsColor, 'page': const PingScreen()},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ابزارهای شبکه')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          final color = tool['color'] as Color;
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => tool['page'] as Widget)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(tool['icon'] as IconData, color: color, size: 32)),
                const SizedBox(height: 12),
                Text(tool['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ─── IP Address ───
class IpAddressScreen extends StatelessWidget {
  const IpAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('آدرس IP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _infoCard('آدرس IP محلی', _getLocalIp()),
          const SizedBox(height: 12),
          _infoCard('پلتفرم', _getPlatform()),
          const SizedBox(height: 12),
          _infoCard('نسخه OS', _getOsVersion()),
          const SizedBox(height: 24),
          ElevatedButton.icon(onPressed: () {
            Clipboard.setData(ClipboardData(text: _getLocalIp()));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کپی شد')));
          }, icon: const Icon(Icons.copy), label: const Text('کپی آدرس IP')),
        ]),
      ),
    );
  }

  String _getLocalIp() {
    try {
      final interfaces = InternetAddress.loopbackIPv4;
      return interfaces.address;
    } catch (e) {}
    return 'نامشخص';
  }

  String _getPlatform() => Platform.operatingSystem;
  String _getOsVersion() => Platform.operatingSystemVersion;

  Widget _infoCard(String label, String value) {
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(value, style: const TextStyle(fontFamily: 'monospace', color: AppColors.turquoise)),
    ])));
  }
}

// ─── Device Info ───
class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final info = [
      {'label': 'پلتفرم', 'value': Platform.operatingSystem},
      {'label': 'نسخه OS', 'value': Platform.operatingSystemVersion},
      {'label': 'نام دستگاه', 'value': Platform.localHostname},
      {'label': 'تعداد پردازنده', 'value': '${Platform.numberOfProcessors} هسته'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('اطلاعات دستگاه')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: info.length,
        itemBuilder: (context, i) => Card(
          child: ListTile(
            title: Text(info[i]['label']!, style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing: Text(info[i]['value']!, style: const TextStyle(fontFamily: 'monospace', color: AppColors.turquoise)),
          ),
        ),
      ),
    );
  }
}

// ─── Battery ───
class BatteryScreen extends StatelessWidget {
  const BatteryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سلامت باتری')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.battery_full, size: 100, color: AppColors.mint),
          const SizedBox(height: 24),
          const Text('اطلاعات باتری', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(margin: const EdgeInsets.symmetric(horizontal: 32), child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              _row('وضعیت', 'متصل به برق'),
              _row('وضعیت شارژ', 'در حال شارژ'),
              _row('نوع', 'Li-ion'),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(k, style: const TextStyle(fontWeight: FontWeight.w500)), Text(v, style: const TextStyle(color: AppColors.turquoise))]),
  );
}

// ─── DNS Lookup ───
class DnsLookupScreen extends StatefulWidget {
  const DnsLookupScreen({super.key});
  @override
  State<DnsLookupScreen> createState() => _DnsLookupScreenState();
}

class _DnsLookupScreenState extends State<DnsLookupScreen> {
  final _controller = TextEditingController();
  List<String> _results = [];

  void _lookup() async {
    try {
      final addresses = await InternetAddress.lookup(_controller.text);
      setState(() => _results = addresses.map((a) => a.address).toList());
    } catch (e) {
      setState(() => _results = ['خطا: $e']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DNS Lookup')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          TextField(controller: _controller, decoration: const InputDecoration(labelText: 'دامنه', hintText: 'example.com'), textDirection: TextDirection.ltr),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _lookup, child: const Text('جستجو')),
          const SizedBox(height: 24),
          Expanded(child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, i) => Card(child: ListTile(leading: const Icon(Icons.language), title: Text(_results[i], style: const TextStyle(fontFamily: 'monospace')))),
          )),
        ]),
      ),
    );
  }
}

// ─── Ping ───
class PingScreen extends StatefulWidget {
  const PingScreen({super.key});
  @override
  State<PingScreen> createState() => _PingScreenState();
}

class _PingScreenState extends State<PingScreen> {
  final _controller = TextEditingController();
  final List<String> _results = [];
  bool _isPinging = false;

  void _ping() async {
    setState(() { _isPinging = true; _results.clear(); });
    try {
      final result = await InternetAddress.lookup(_controller.text);
      setState(() { _results.add('پاسخ از ${result.first.address}: موفق'); _isPinging = false; });
    } catch (e) {
      setState(() { _results.add('خطا: $e'); _isPinging = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ping')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          TextField(controller: _controller, decoration: const InputDecoration(labelText: 'آدرس', hintText: 'google.com'), textDirection: TextDirection.ltr),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _isPinging ? null : _ping, child: _isPinging ? const CircularProgressIndicator() : const Text('Ping')),
          const SizedBox(height: 24),
          Expanded(child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, i) => Card(child: ListTile(leading: Icon(Icons.check_circle, color: _results[i].contains('خطا') ? Colors.red : Colors.green), title: Text(_results[i]))),
          )),
        ]),
      ),
    );
  }
}
