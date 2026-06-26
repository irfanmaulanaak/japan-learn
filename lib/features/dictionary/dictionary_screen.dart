import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/bookmark.dart';
import '../../data/models/kanji.dart';
import '../../data/models/vocabulary.dart';
import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import '../kanji/kanji_detail_screen.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  final _controller = TextEditingController();
  List<Vocabulary> _words = const [];
  List<Kanji> _kanji = const [];
  bool _busy = false;
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    setState(() {
      _busy = true;
      _query = q;
    });
    final vocabRepo = ref.read(vocabularyRepositoryProvider);
    final kanjiRepo = ref.read(kanjiRepositoryProvider);
    final results = await Future.wait([
      vocabRepo.search(q),
      kanjiRepo.search(q),
    ]);
    if (!mounted) return;
    setState(() {
      _words = results[0] as List<Vocabulary>;
      _kanji = results[1] as List<Kanji>;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dictionary')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: TextField(
                controller: _controller,
                onChanged: (v) {
                  if (v.trim().isEmpty) {
                    setState(() {
                      _words = const [];
                      _kanji = const [];
                      _query = '';
                    });
                    return;
                  }
                  _search(v);
                },
                decoration: InputDecoration(
                  hintText: 'Search Japanese, romaji, or English',
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.inkMuted,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_busy) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }
    if (_query.isEmpty) return const _Empty();
    if (_words.isEmpty && _kanji.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No results for "$_query".',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      children: [
        if (_words.isNotEmpty) ...[
          const _SectionLabel('Vocabulary'),
          const SizedBox(height: 8),
          ..._words.map((w) => _VocabRow(word: w, ref: ref)),
        ],
        if (_kanji.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionLabel('Kanji'),
          const SizedBox(height: 8),
          ..._kanji.map((k) => _KanjiRow(kanji: k, ref: ref)),
        ],
      ],
    );
  }
}

class _Empty extends ConsumerWidget {
  const _Empty();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        const _SectionLabel('Bookmarks'),
        const SizedBox(height: 8),
        bookmarksAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No bookmarks yet. Tap the star on any search result to save it.',
                  style: TextStyle(
                    color: AppColors.inkMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return Column(
              children: items.map((b) => _BookmarkRow(bookmark: b)).toList(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _VocabRow extends StatelessWidget {
  final Vocabulary word;
  final WidgetRef ref;
  const _VocabRow({required this.word, required this.ref});

  @override
  Widget build(BuildContext context) {
    return _ResultRow(
      headline: word.word,
      subtitle: word.reading,
      meaning: word.meaning,
      meta: '${word.partOfSpeech} · ${word.level}',
      kind: Bookmark.kindVocab,
      itemId: word.id!,
      ref: ref,
    );
  }
}

class _KanjiRow extends StatelessWidget {
  final Kanji kanji;
  final WidgetRef ref;
  const _KanjiRow({required this.kanji, required this.ref});

  @override
  Widget build(BuildContext context) {
    final reading = [
      if (kanji.onyomi.isNotEmpty) '音 ${kanji.onyomi}',
      if (kanji.kunyomi.isNotEmpty) '訓 ${kanji.kunyomi}',
    ].join('  ');
    return _ResultRow(
      headline: kanji.character,
      subtitle: reading,
      meaning: kanji.meaning,
      meta: '${kanji.strokes} strokes · ${kanji.level}',
      kind: Bookmark.kindKanji,
      itemId: kanji.id!,
      ref: ref,
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => KanjiDetailScreen(kanji: kanji)),
          ),
    );
  }
}

class _ResultRow extends StatefulWidget {
  final String headline;
  final String subtitle;
  final String meaning;
  final String meta;
  final String kind;
  final int itemId;
  final WidgetRef ref;
  final VoidCallback? onTap;
  const _ResultRow({
    required this.headline,
    required this.subtitle,
    required this.meaning,
    required this.meta,
    required this.kind,
    required this.itemId,
    required this.ref,
    this.onTap,
  });

  @override
  State<_ResultRow> createState() => _ResultRowState();
}

class _ResultRowState extends State<_ResultRow> {
  bool _saved = false;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final repo = widget.ref.read(bookmarkRepositoryProvider);
    final exists = await repo.exists(kind: widget.kind, itemId: widget.itemId);
    if (!mounted) return;
    setState(() {
      _saved = exists;
      _checked = true;
    });
  }

  Future<void> _toggle() async {
    final repo = widget.ref.read(bookmarkRepositoryProvider);
    await repo.toggle(kind: widget.kind, itemId: widget.itemId);
    widget.ref.invalidate(bookmarksProvider);
    if (!mounted) return;
    setState(() => _saved = !_saved);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Text(
                widget.headline,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  height: 1.05,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.subtitle.isNotEmpty)
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.inkSoft,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  Text(
                    widget.meaning,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.meta,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _checked ? _toggle : null,
              icon: Icon(
                _saved ? Icons.star_rounded : Icons.star_outline_rounded,
                color: _saved ? AppColors.accent : AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 220.ms);
  }
}

class _BookmarkRow extends ConsumerWidget {
  final Bookmark bookmark;
  const _BookmarkRow({required this.bookmark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<_BookmarkPayload?>(
      future: _resolve(ref),
      builder: (context, snapshot) {
        final payload = snapshot.data;
        if (payload == null) return const SizedBox.shrink();
        return _ResultRow(
          headline: payload.headline,
          subtitle: payload.subtitle,
          meaning: payload.meaning,
          meta: payload.meta,
          kind: bookmark.kind,
          itemId: bookmark.itemId,
          ref: ref,
        );
      },
    );
  }

  Future<_BookmarkPayload?> _resolve(WidgetRef ref) async {
    if (bookmark.kind == Bookmark.kindVocab) {
      final v = await ref
          .read(vocabularyRepositoryProvider)
          .byId(bookmark.itemId);
      if (v == null) return null;
      return _BookmarkPayload(
        headline: v.word,
        subtitle: v.reading,
        meaning: v.meaning,
        meta: '${v.partOfSpeech} · ${v.level}',
      );
    }
    final k = await ref.read(kanjiRepositoryProvider).byId(bookmark.itemId);
    if (k == null) return null;
    final reading = [
      if (k.onyomi.isNotEmpty) '音 ${k.onyomi}',
      if (k.kunyomi.isNotEmpty) '訓 ${k.kunyomi}',
    ].join('  ');
    return _BookmarkPayload(
      headline: k.character,
      subtitle: reading,
      meaning: k.meaning,
      meta: '${k.strokes} strokes · ${k.level}',
    );
  }
}

class _BookmarkPayload {
  final String headline;
  final String subtitle;
  final String meaning;
  final String meta;
  const _BookmarkPayload({
    required this.headline,
    required this.subtitle,
    required this.meaning,
    required this.meta,
  });
}
