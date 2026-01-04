import 'package:biblia/domain/entities/verse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

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
  SelectedContent? _selectedContent;

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
      onSelectionChanged: (content) {
        _selectedContent = content;
      },
      contextMenuBuilder: (context, selectableRegionState) {
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: selectableRegionState.contextMenuAnchors,
          buttonItems: [
            ContextMenuButtonItem(
              onPressed: () {
                final text = _selectedContent?.plainText;
                if (text != null) {
                  // Regex: Adiciona quebra de linha antes de números de versículo (ex: "2 - "),
                  // exceto se for o início do texto.
                  // (?<!^) -> Lookbehind negativo: garante que não é o início da string
                  // (\d+ - ) -> Captura o padrão "Número - "
                  final formattedText = text.replaceAllMapped(
                    RegExp(r'(?<!^)(\d+ - )'),
                    (match) => '\n${match.group(1)}',
                  );

                  Clipboard.setData(ClipboardData(text: formattedText));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Seleção copiada!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  selectableRegionState.hideToolbar();
                } else {
                  // Fallback para cópia padrão caso não tenhamos capturado o texto
                  Actions.maybeInvoke<CopySelectionTextIntent>(
                    context,
                    CopySelectionTextIntent.copy,
                  );
                }
              },
              label: 'Copiar',
            ),
            ContextMenuButtonItem(
              onPressed: () {
                selectableRegionState.selectAll(SelectionChangedCause.toolbar);
              },
              label: 'Selecionar tudo',
            ),
          ],
        );
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40, top: 12),
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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
