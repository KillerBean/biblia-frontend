import 'package:biblia/domain/entities/verse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TextListItemsWidget extends StatefulWidget {
  const TextListItemsWidget(
      {super.key, required this.items, this.highlightedVerses});
  final List<dynamic> items;
  final List<int>? highlightedVerses;

  @override
  State<TextListItemsWidget> createState() => _TextListItemsWidgetState();
}

class _TextListItemsWidgetState extends State<TextListItemsWidget> {
  final Map<int, GlobalKey> _itemKeys = {};
  List<int>? _currentHighlightIds;

  @override
  void initState() {
    super.initState();
    _currentHighlightIds = widget.highlightedVerses;
    if (widget.highlightedVerses != null &&
        widget.highlightedVerses!.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Scroll to the first highlighted item
        _scrollToItem(widget.highlightedVerses!.first);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _currentHighlightIds = null;
            });
          }
        });
      });
    }
  }

  @override
  void didUpdateWidget(TextListItemsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightedVerses != oldWidget.highlightedVerses &&
        widget.highlightedVerses != null &&
        widget.highlightedVerses!.isNotEmpty) {
      setState(() {
        _currentHighlightIds = widget.highlightedVerses;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollToItem(widget.highlightedVerses!.first);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _currentHighlightIds = null;
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

              final isHighlighted =
                  _currentHighlightIds?.contains(verseId) ?? false;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                key: _itemKeys[verseId],
                color: isHighlighted
                    ? Theme.of(context)
                        .colorScheme
                        .tertiaryContainer
                        .withValues(
                          alpha: 0.5,
                        )
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
