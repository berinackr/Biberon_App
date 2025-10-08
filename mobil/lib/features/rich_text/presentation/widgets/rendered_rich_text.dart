import 'dart:convert';

import 'package:flutter/material.dart';

class RenderedRichText extends StatefulWidget {
  const RenderedRichText({required this.deltaJson, super.key});
  final String deltaJson;

  @override
  RenderedRichTextState createState() => RenderedRichTextState();
}

class RenderedRichTextState extends State<RenderedRichText> {
  bool _isExpanded = true;
  late List<dynamic> _content;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _content = _parseContent();
  }

  @override
  void didUpdateWidget(covariant RenderedRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deltaJson != widget.deltaJson) {
      _content = _parseContent();
    }
  }

  List<dynamic> _parseContent() {
    final delta = json.decode(widget.deltaJson) as List<dynamic>;
    return delta;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
          _content = _parseContent();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: RenderDelta(_content, context).render(),
      ),
    );
  }
}

class RenderDelta {
  RenderDelta(this.delta, this.context);
  final List<dynamic> delta;
  final BuildContext context;
  final widgets = <Widget>[];
  List<TextSpan> currentLine = <TextSpan>[];
  int currentListIndex = 1;

  List<Widget> _buildWidgets() {
    for (final (op as Map<String, dynamic>) in delta) {
      if (op['insert'] != null) {
        final text = op['insert'] as String;
        final listType = _getListType(op);
        final isBlockQuote = _isBlockQoute(op);

        if (_isContainsNewLine(text) && listType == null && !isBlockQuote) {
          final lines = text.split('\n');
          for (var i = 0; i < lines.length; i++) {
            final line = lines[i];
            if (widgets.isEmpty && currentLine.isEmpty && line == '') continue;
            if (i != lines.length - 1) {
              currentLine.add(_buildTextSpan(op, line));
              _addLine();
            } else {
              currentLine.add(_buildTextSpan(op, line));
            }
          }
          continue;
        }

        if (isBlockQuote) {
          if (_isContainsNewLine(text)) {
            final lines = text.split('\n');
            for (var i = 0; i < lines.length; i++) {
              final line = lines[i];
              if (widgets.isEmpty && currentLine.isEmpty && line == '') {
                continue;
              }

              if (i < lines.length - 1) {
                currentLine.add(_buildTextSpan(op, line));
                _addQuote();
              } else {
                currentLine.add(_buildTextSpan(op, line));
              }
            }
          }

          continue;
        }

        if (listType != null) {
          if (_isContainsNewLine(text)) {
            final lines = text.split('\n');
            for (var i = 0; i < lines.length; i++) {
              final line = lines[i];
              if (widgets.isEmpty && currentLine.isEmpty && line == '') {
                continue;
              }

              if (i < lines.length - 2) {
                currentLine.add(_buildTextSpan(op, '$line\n'));
              } else {
                currentLine.add(_buildTextSpan(op, line));
              }
            }
            _addListItem(listType);
          } else {
            currentLine.add(_buildTextSpan(op, text));
            _addListItem(listType);
          }
        } else {
          currentLine.add(_buildTextSpan(op, text));
        }
      }
    }
    return widgets;
  }

  List<Widget> render() {
    return _buildWidgets();
  }

  TextSpan _buildTextSpan(Map<String, dynamic> op, String text) {
    final attributes = op['attributes'] as Map<String, dynamic>?;

    return TextSpan(
      text: text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: attributes?['bold'] == true
                ? FontWeight.bold
                : FontWeight.normal,
            decoration:
                attributes?['underline'] == true || attributes?['link'] != null
                    ? TextDecoration.underline
                    : attributes?['strike'] == true
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
            fontStyle: attributes?['italic'] == true
                ? FontStyle.italic
                : FontStyle.normal,
            color: attributes?['link'] != null
                ? Theme.of(context).colorScheme.primary
                : Colors.black,
          ),
    );
  }

  void _addLine() {
    if (currentLine.isNotEmpty) {
      if (widgets.isEmpty) {
        widgets.add(
          _buildRichText(),
        );
      } else {
        widgets.add(
          _buildRichText(),
        );
      }

      currentLine = [];
      currentListIndex = 1;
    }
  }

  void _addQuote() {
    if (widgets.isEmpty) {
      widgets.add(
        _buildQuote(),
      );
    } else {
      widgets.add(
        _buildQuote(),
      );
    }
    currentLine = [];
  }

  void _addListItem(String? listType) {
    if (listType == 'ordered') {
      if (widgets.isEmpty) {
        widgets.add(
          _buildOrderedListItem(),
        );
      } else {
        widgets.add(
          _buildOrderedListItem(),
        );
      }

      currentListIndex++;
    } else {
      if (widgets.isEmpty) {
        widgets.add(
          _buildUnorderedListItem(),
        );
      } else {
        widgets.add(
          _buildUnorderedListItem(),
        );
      }
    }
    currentLine = [];
  }

  Widget _buildRichText() {
    return RichText(
      text: TextSpan(
        children: currentLine,
      ),
    );
  }

  Widget _buildOrderedListItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$currentListIndex. ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: currentLine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnorderedListItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: currentLine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: RichText(
            text: TextSpan(
              children: currentLine,
            ),
          ),
        ),
      ],
    );
  }

  String? _getListType(Map<String, dynamic> op) {
    return (op['attributes'] != null
        ? (op['attributes'] as Map<String, dynamic>)['list']
        : null) as String?;
  }

  bool _isBlockQoute(Map<String, dynamic> op) {
    return op['attributes'] != null &&
        (op['attributes'] as Map<String, dynamic>)['blockquote'] == true;
  }

  bool _isContainsNewLine(String text) {
    return text.contains('\n');
  }
}
