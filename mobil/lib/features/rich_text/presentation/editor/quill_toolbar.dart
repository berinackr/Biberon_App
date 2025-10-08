import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MyQuillToolbar extends StatelessWidget {
  const MyQuillToolbar({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  final QuillController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return QuillToolbar.simple(
      configurations: QuillSimpleToolbarConfigurations(
        controller: controller,
        showBackgroundColorButton: false,
        showFontFamily: false,
        showFontSize: false,
        showCodeBlock: false,
        showInlineCode: false,
        showSubscript: false,
        showSuperscript: false,
        showHeaderStyle: false,
        showColorButton: false,
        showDividers: false,
        showClearFormat: false,
        showListCheck: false,
        showIndent: false,
        showSearchButton: false,
        showClipboardCopy: false,
        showClipboardCut: false,
        showClipboardPaste: false,
        multiRowsDisplay: false,
        buttonOptions: QuillSimpleToolbarButtonOptions(
          base: QuillToolbarBaseButtonOptions(
            iconSize: 12,
            iconTheme: QuillIconTheme(
              iconButtonSelectedData: IconButtonData(
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // ignore: use_named_constants
                  minimumSize: const Size(0, 0),
                  padding: const EdgeInsets.all(4),
                ),
              ),
              iconButtonUnselectedData: IconButtonData(
                style: IconButton.styleFrom(
                  // ignore: use_named_constants
                  minimumSize: const Size(0, 0),
                  padding: const EdgeInsets.all(4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
