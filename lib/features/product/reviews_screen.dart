import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/visuals.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// 1q — product reviews.
class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final product = ref.watch(productProvider(widget.productId)).value;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ScreenHeader(title: l10n.reviews, subtitle: product == null ? null : context.tr(product.name)),
                Expanded(
                  child: AsyncView(
                    value: ref.watch(reviewsProvider(widget.productId)),
                    builder: (reviews) {
                      final shown = switch (_filter) {
                        1 => reviews.where((r) => r.photos > 0).toList(),
                        2 => reviews.where((r) => r.rating == 5).toList(),
                        _ => reviews,
                      };
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
                        children: [
                          _Summary(rating: product?.rating ?? 0, count: product?.reviewsCount ?? reviews.length),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            children: [
                              QChip(label: l10n.all, selected: _filter == 0, onTap: () => setState(() => _filter = 0)),
                              QChip(label: l10n.withPhoto, selected: _filter == 1, onTap: () => setState(() => _filter = 1)),
                              QChip(label: '5 ★', numeric: true, selected: _filter == 2, onTap: () => setState(() => _filter = 2)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          for (final r in shown)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _ReviewCard(review: r),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            PositionedDirectional(
              start: 16,
              end: 16,
              bottom: 16,
              child: PillButton(label: l10n.leaveReview, color: AppColors.ink, onPressed: () => showStub(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.rating, required this.count});

  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    return QCard(
      radius: 26,
      padding: const EdgeInsets.all(18),
      child: Row(
        spacing: 18,
        children: [
          Column(
            spacing: 6,
            children: [
              Text(rating.toStringAsFixed(1), style: AppText.num(44)),
              Text(
                context.l10n.basedOn(count),
                style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted),
              ),
            ],
          ),
          Expanded(
            child: Column(
              spacing: 6,
              children: [
                for (final MapEntry(key: stars, value: share) in MockData.ratingDistribution.entries)
                  Row(
                    spacing: 8,
                    children: [
                      SizedBox(
                        width: 8,
                        child: Text('$stars', style: AppText.num(11, color: AppColors.muted)),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: share,
                            minHeight: 6,
                            color: AppColors.red,
                            backgroundColor: AppColors.divider,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final tones = [
      (AppColors.tealSoft, AppColors.tealDark),
      (AppColors.redSoft, AppColors.redDark),
      (AppColors.greenSoft, AppColors.greenDark),
    ];
    final (bg, fg) = tones[review.author.codeUnitAt(0) % tones.length];
    return QCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: bg,
                child: Text(
                  review.author.characters.first,
                  style: AppText.ui(14, weight: FontWeight.w700, color: fg),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(review.author, style: AppText.ui(14, weight: FontWeight.w700)),
                    Text(
                      context.l10n.daysAgo(review.daysAgo),
                      style: AppText.ui(11, weight: FontWeight.w500, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: '${review.rating}/5',
                child: Row(
                  children: [
                    for (var i = 0; i < 5; i++)
                      Icon(Icons.star_rounded, size: 15, color: i < review.rating ? AppColors.red : AppColors.line),
                  ],
                ),
              ),
            ],
          ),
          Text(
            context.tr(review.text),
            style: AppText.ui(14, weight: FontWeight.w500, color: AppColors.inkBody, height: 1.43),
          ),
          if (review.photos > 0)
            Row(
              spacing: 8,
              children: [
                for (var i = 0; i < review.photos; i++)
                  SizedBox.square(dimension: 64, child: StripedPlaceholder(radius: BorderRadius.circular(14), stripe: 8)),
              ],
            ),
        ],
      ),
    );
  }
}
