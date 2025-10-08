import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MentionBlockEmbed extends Embeddable {
  const MentionBlockEmbed(MentionData value) : super(mentionType, value);

  static const String mentionType = 'mention';

  MentionData get mentionData =>
      MentionData.fromJson(data as Map<String, dynamic>);
}

class MentionData {
  MentionData(this.id, this.name);

  factory MentionData.fromJson(Map<String, dynamic> json) {
    return MentionData(json['id'] as String, json['name'] as String);
  }
  final String id;
  final String name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class MentionEmbedBuilder extends EmbedBuilder {
  MentionEmbedBuilder({required this.onMentionTap});

  final void Function(BuildContext context, Map<String, dynamic> mentionData)
      onMentionTap;

  @override
  String get key => 'mention';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final mentionData = MentionData(
      (node.value.data as Map<String, dynamic>)['id']?.toString() ?? '',
      (node.value.data as Map<String, dynamic>)['name']?.toString() ?? '',
    );
    return Text(
      '@${mentionData.name}',
      style: const TextStyle(
        color: Colors.blue,
      ),
    );
  }
}
