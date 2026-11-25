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

  Future<void> _leaveReview(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final thanks = context.l10n.reviewThanks;
    final review = await showModalBottomSheet<Review>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (_) => const _ReviewForm(),
    );
    if (review == null) return;
    await ref.read(catalogRepositoryProvider).addReview(widget.productId, review);
    ref.invalidate(reviewsProvider(widget.productId));
    messenger.showSnackBar(SnackBar(content: Text(thanks)));
  }

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
              child: PillButton(label: l10n.leaveReview, color: AppColors.ink, onPressed: () => _leaveReview(context)),
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
    final author = review.author.isEmpty ? context.l10n.you : review.author;
    final (bg, fg) = tones[author.codeUnitAt(0) % tones.length];
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
                  author.characters.first,
                  style: AppText.ui(14, weight: FontWeight.w700, color: fg),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(author, style: AppText.ui(14, weight: FontWeight.w700)),
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

class _ReviewForm extends StatefulWidget {
  const _ReviewForm();

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  final _text = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(l10n.reviewTitle, style: AppText.title),
          Semantics(
            label: l10n.rating,
            value: _rating == 0 ? null : l10n.starsLabel('$_rating'),
            child: Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    tooltip: l10n.starsLabel('$i'),
                    iconSize: 34,
                    onPressed: () => setState(() => _rating = i),
                    icon: Icon(
                      i <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: i <= _rating ? AppColors.orange : AppColors.outline,
                    ),
                  ),
              ],
            ),
          ),
          if (_rating == 0) Text(l10n.reviewRateFirst, style: AppText.caption),
          TextField(
            controller: _text,
            minLines: 3,
            maxLines: 6,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l10n.reviewHint,
              filled: true,
              fillColor: AppColors.bg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          PillButton(
            label: l10n.send,
            onPressed: _rating == 0
                ? null
                : () =>
                      Navigator.of(context)
                          .pop(Review(author: '', rating: _rating, daysAgo: 0, text: LocalizedText.same(_text.text.trim()))),
          ),
        ],
      ),
    );
  }
}
