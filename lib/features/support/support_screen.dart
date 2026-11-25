import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/utils/launch.dart';
import '../../core/widgets/visuals.dart';
import '../../data/mock/mock_data.dart';

/// Contacts (phone, WhatsApp, email from qulpynai.kz) and an FAQ.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final faq = [
      (l10n.faq1q, l10n.faq1a(formatTenge(MockData.deliveryFee), formatTenge(MockData.freeDeliveryFrom))),
      (l10n.faq2q, l10n.faq2a),
      (l10n.faq3q, l10n.faq3a),
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: l10n.support, subtitle: l10n.supportText),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.paddingOf(context).bottom),
                children: [
                  QCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        _ContactRow(
                          icon: Icons.call_outlined,
                          color: AppColors.tealDark,
                          background: AppColors.tealSoft,
                          title: l10n.call,
                          subtitle: formatPhone(Contacts.phone),
                          onTap: () => callPhone(context, Contacts.phone),
                        ),
                        const Divider(height: 1, indent: 68, color: AppColors.divider),
                        _ContactRow(
                          icon: Icons.chat_outlined,
                          color: AppColors.greenText,
                          background: AppColors.greenSoft,
                          title: l10n.whatsapp,
                          subtitle: formatPhone('+${Contacts.whatsapp}'),
                          onTap: () => openWhatsApp(context),
                        ),
                        const Divider(height: 1, indent: 68, color: AppColors.divider),
                        _ContactRow(
                          icon: Icons.mail_outline_rounded,
                          color: AppColors.redDark,
                          background: AppColors.redSoft,
                          title: l10n.writeEmail,
                          subtitle: Contacts.email,
                          onTap: () => openExternal(context, Uri(scheme: 'mailto', path: Contacts.email)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(l10n.faq, style: AppText.headline),
                  const SizedBox(height: 10),
                  QCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final (q, a) in faq)
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              shape: const Border(),
                              collapsedShape: const Border(),
                              iconColor: AppColors.ink,
                              collapsedIconColor: AppColors.muted,
                              title: Text(q, style: AppText.titleSmall),
                              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              expandedAlignment: Alignment.centerLeft,
                              children: [Text(a, style: AppText.body)],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minTileHeight: 64,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(title, style: AppText.titleSmall),
      subtitle: Text(subtitle, style: AppText.bodySmall),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.faint),
    );
  }
}
