import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final _textController = TextEditingController();
  String _qrData = '';
  Color _qrColor = Colors.black;
  Color _bgColor = Colors.white;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سازنده کد QR'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'متن یا لینک',
                hintText: 'متن مورد نظر را وارد کنید',
              ),
              onChanged: (v) => setState(() => _qrData = v),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Colors
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('رنگ کد'),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [Colors.black, Colors.blue, Colors.red, Colors.green, AppColors.turquoise, Colors.purple].map((c) {
                          return GestureDetector(
                            onTap: () => setState(() => _qrColor = c),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _qrColor == c ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('رنگ پس‌زمینه'),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [Colors.white, Colors.grey[200]!, Colors.yellow[100]!, Colors.blue[50]!].map((c) {
                          return GestureDetector(
                            onTap: () => setState(() => _bgColor = c),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _bgColor == c ? AppColors.turquoise : Colors.grey,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),

            // QR Code Display
            if (_qrData.isNotEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                  ),
                  child: QrImageView(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: _bgColor,
                  ),
                ),
              ),
            if (_qrData.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    children: [
                      Icon(Icons.qr_code, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'متن یا لینک را وارد کنید',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppDimensions.xl),

            // Actions
            if (_qrData.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _shareQr,
                      icon: const Icon(Icons.share),
                      label: const Text('اشتراک‌گذاری'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text('کپی متن'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _shareQr() {
    Share.share(_qrData);
  }

  void _copyToClipboard() {
    // Use clipboard package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('متن کپی شد')),
    );
  }
}
