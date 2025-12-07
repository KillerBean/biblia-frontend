import 'package:biblia/domain/entities/verse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TextListItemsWidget extends StatefulWidget {
  const TextListItemsWidget(
      {super.key, required this.items, this.highlightVerseId});
  final List<dynamic> items;
  final int? highlightVerseId;

  @override
  State<TextListItemsWidget> createState() => _TextListItemsWidgetState();
}

class _TextListItemsWidgetState extends State<TextListItemsWidget> {
  final Map<int, GlobalKey> _itemKeys = {};
  int? _currentHighlightId;

  @override
  void initState() {
    super.initState();
    _currentHighlightId = widget.highlightVerseId;
    if (widget.highlightVerseId != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollToItem(widget.highlightVerseId!);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _currentHighlightId = null;
            });
          }
        });
      });
    }
  }

  @override
  void didUpdateWidget(TextListItemsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightVerseId != oldWidget.highlightVerseId &&
        widget.highlightVerseId != null) {
      setState(() {
        _currentHighlightId = widget.highlightVerseId;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollToItem(widget.highlightVerseId!);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _currentHighlightId = null;
            });
          }
        });
      });
    }
  }

  void _scrollToItem(int id) {
    final key = _itemKeys[id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.items.map((item) {
              final verse = item as Verse;
              final verseId = verse.verse;

              if (!_itemKeys.containsKey(verseId)) {
                _itemKeys[verseId] = GlobalKey();
              }

              final isHighlighted = _currentHighlightId == verseId;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                key: _itemKeys[verseId],
                color: isHighlighted
                    ? Theme.of(context)
                        .colorScheme
                        .tertiaryContainer
                        .withOpacity(0.5)
                    : Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "${verse.verse} - ${verse.text}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        height: 1.5,
                      ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}