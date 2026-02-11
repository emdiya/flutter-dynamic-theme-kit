import 'package:dynamic_theme_kit_app/app/core/config/base_url.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/presentation/widgets/themed_icon.dart';
import 'package:flutter/material.dart';

class KhmerBankingAtmosphere extends StatelessWidget {
  const KhmerBankingAtmosphere({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE6EEFF), Color(0xFFF7FAFF), Color(0xFFFFFFFF)],
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.12,
            child: CustomPaint(painter: SkylinePainter()),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.07,
            child: CustomPaint(painter: EdgePatternPainter()),
          ),
        ),
        Positioned(
          top: 110,
          left: 26,
          child: Icon(
            Icons.account_balance,
            size: 48,
            color: Colors.blueGrey.withOpacity(0.1),
          ),
        ),
        Positioned(
          top: 170,
          right: 34,
          child: Icon(
            Icons.credit_card,
            size: 40,
            color: Colors.blueGrey.withOpacity(0.1),
          ),
        ),
        Positioned(
          bottom: 210,
          left: 30,
          child: Icon(
            Icons.account_balance_wallet,
            size: 44,
            color: Colors.blueGrey.withOpacity(0.1),
          ),
        ),
        Positioned(
          bottom: 260,
          right: 32,
          child: Icon(
            Icons.show_chart,
            size: 46,
            color: Colors.blueGrey.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}

class SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF2E5FAF).withOpacity(0.35);
    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width * 0.1, size.height * 0.68)
      ..lineTo(size.width * 0.18, size.height * 0.7)
      ..lineTo(size.width * 0.24, size.height * 0.63)
      ..lineTo(size.width * 0.36, size.height * 0.67)
      ..lineTo(size.width * 0.44, size.height * 0.6)
      ..lineTo(size.width * 0.56, size.height * 0.66)
      ..lineTo(size.width * 0.65, size.height * 0.62)
      ..lineTo(size.width * 0.78, size.height * 0.69)
      ..lineTo(size.width * 0.88, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EdgePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3A8A).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final left = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.08,
        0,
        size.height * 0.16,
      )
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.24,
        0,
        size.height * 0.32,
      )
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.4,
        0,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.56,
        0,
        size.height * 0.64,
      )
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.72,
        0,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.88,
        0,
        size.height,
      );

    final right = Path()
      ..moveTo(size.width, 0)
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.08,
        size.width,
        size.height * 0.16,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.24,
        size.width,
        size.height * 0.32,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.4,
        size.width,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.56,
        size.width,
        size.height * 0.64,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.72,
        size.width,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.88,
        size.width,
        size.height,
      );

    canvas.drawPath(left, paint);
    canvas.drawPath(right, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DemoHeader extends StatelessWidget {
  const DemoHeader({
    super.key,
    required this.textPrimary,
    required this.activePackId,
  });

  final Color textPrimary;
  final String? activePackId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: TextStyle(
                  color: textPrimary.withOpacity(0.75),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Khmer Banking Demo',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (activePackId != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Active theme: $activePackId',
                  style: TextStyle(color: textPrimary.withOpacity(0.7)),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }
}

class BalanceCardWidget extends StatelessWidget {
  const BalanceCardWidget({super.key, required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 42,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '\$12,480.50',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key, required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QuickActionItemWidget(
            label: 'Home',
            icon: const ThemedIcon('home', size: 60),
            color: primary,
          ),
          QuickActionItemWidget(
            label: 'Transfer',
            icon: const ThemedIcon('transfer', size: 60),
            color: primary,
          ),
          QuickActionItemWidget(
            label: 'Scan',
            icon: const ThemedIcon('scan', size: 60),
            color: primary,
          ),
        ],
      ),
    );
  }
}

class QuickActionItemWidget extends StatelessWidget {
  const QuickActionItemWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: icon,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class ServiceStrip extends StatelessWidget {
  const ServiceStrip({
    super.key,
    required this.primary,
    required this.textPrimary,
  });

  final Color primary;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    final items = <ServiceItem>[
      const ServiceItem('Pay Bills', Icons.receipt_long_rounded),
      const ServiceItem('Top Up', Icons.sim_card_download_rounded),
      const ServiceItem('QR Pay', Icons.qr_code_scanner_rounded),
      const ServiceItem('Savings', Icons.savings_rounded),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items
            .map(
              (item) => Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: primary, size: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: textPrimary.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class ServiceItem {
  const ServiceItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

class InsightPanel extends StatelessWidget {
  const InsightPanel({super.key, required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Insights',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Income',
                  value: '+\$1,840',
                  valueColor: Colors.green.shade600,
                  bg: Colors.green.withOpacity(0.09),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricTile(
                  label: 'Expense',
                  value: '-\$920',
                  valueColor: Colors.red.shade600,
                  bg: Colors.red.withOpacity(0.09),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricTile(
                  label: 'Growth',
                  value: '12.4%',
                  valueColor: primary,
                  bg: primary.withOpacity(0.09),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.bg,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    required this.primary,
    required this.textPrimary,
  });

  final Color primary;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('View all')),
            ],
          ),
          TxnRow(
            icon: const ThemedIcon('transfer', size: 24),
            title: 'Transfer to Sok Dara',
            subtitle: 'Today, 08:20 AM',
            amount: '-\$120.00',
            amountColor: Colors.red.shade600,
            accent: primary,
          ),
          const Divider(height: 16),
          TxnRow(
            icon: const Icon(Icons.account_balance_wallet_rounded, size: 22),
            title: 'Salary Deposit',
            subtitle: 'Yesterday, 05:32 PM',
            amount: '+\$950.00',
            amountColor: Colors.green.shade600,
            accent: primary,
          ),
          const Divider(height: 16),
          TxnRow(
            icon: const ThemedIcon('scan', size: 24),
            title: 'QR Merchant Payment',
            subtitle: 'Yesterday, 12:14 PM',
            amount: '-\$12.50',
            amountColor: Colors.red.shade600,
            accent: primary,
          ),
        ],
      ),
    );
  }
}

class TxnRow extends StatelessWidget {
  const TxnRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.accent,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: icon,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.w700, color: amountColor),
        ),
      ],
    );
  }
}

class ThemePackTile extends StatelessWidget {
  const ThemePackTile({
    super.key,
    required this.name,
    required this.version,
    required this.id,
    required this.preview,
    required this.selected,
    required this.active,
    this.onTap,
    required this.onSelect,
    required this.onActivate,
  });

  final String name;
  final int version;
  final String id;
  final String? preview;
  final bool selected;
  final bool active;
  final VoidCallback? onTap;
  final VoidCallback onSelect;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    final borderColor = active
        ? const Color(0xFF1E40AF)
        : selected
        ? const Color(0xFF3B82F6)
        : const Color(0xFFD7DFEE);

    return GestureDetector(
      onTap: onTap ?? () => _showThemeBottomSheet(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
          color: Colors.white.withOpacity(0.92),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: ThemePreviewImage(preview: preview)),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'v$version',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (active)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemePackBottomSheet(
        name: name,
        version: version,
        id: id,
        preview: preview,
        active: active,
        onSelect: onSelect,
        onActivate: onActivate,
      ),
      isScrollControlled: true,
    );
  }
}

class ThemePackBottomSheet extends StatelessWidget {
  const ThemePackBottomSheet({
    super.key,
    required this.name,
    required this.version,
    required this.id,
    required this.preview,
    required this.active,
    required this.onSelect,
    required this.onActivate,
  });

  final String name;
  final int version;
  final String id;
  final String? preview;
  final bool active;
  final VoidCallback onSelect;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFE8EEF9),
              ),
              child: ThemePreviewImage(preview: preview),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Version: $version | ID: $id',
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            if (active)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✓ This theme is currently active',
                  style: TextStyle(
                    color: Color(0xFF1E40AF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: active
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          onActivate();
                        },
                  child: const Text('Activate Theme'),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ThemePreviewImage extends StatelessWidget {
  const ThemePreviewImage({
    super.key,
    required this.preview,
    this.height = 66,
    this.width = 66,
  });

  final String? preview;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final url = _resolvePreviewUrl(preview);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFFE8EEF9),
        child: url == null
            ? const Icon(
                Icons.image_not_supported_outlined,
                color: Color(0xFF6B7280),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  color: Color(0xFF6B7280),
                ),
              ),
      ),
    );
  }

  String? _resolvePreviewUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    final cleanBase = BaseUrl.theme.endsWith('/')
        ? BaseUrl.theme.substring(0, BaseUrl.theme.length - 1)
        : BaseUrl.theme;
    final cleanPath = raw.startsWith('/') ? raw.substring(1) : raw;
    return '$cleanBase/$cleanPath';
  }
}

class EmptyThemeState extends StatelessWidget {
  const EmptyThemeState({
    super.key,
    required this.textPrimary,
    this.message =
        'Pull to refresh after uploading theme packs to your theme URL.',
  });

  final Color textPrimary;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: textPrimary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No Theme Packs',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
