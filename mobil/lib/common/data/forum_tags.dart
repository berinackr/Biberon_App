import 'package:biberon/features/forum/domain/models/forum_tag_model.dart';

class ForumTags {
  static List<Tag> tags = [
    Tag(id: 1, name: 'Sağlık'),
    Tag(id: 2, name: 'Doğum'),
    Tag(id: 3, name: 'Doğum Hikayeleri'),
    Tag(id: 4, name: 'Beslenme'),
    Tag(id: 5, name: 'Gebelik'),
    Tag(id: 6, name: 'Doktor & Hastane'),
    Tag(id: 7, name: 'Ürün Değerlendirme'),
    Tag(id: 8, name: 'Kişisel Bakım'),
    Tag(id: 9, name: 'Cinsellik'),
    Tag(id: 10, name: 'İsimler'),
    Tag(id: 11, name: 'Spor'),
    Tag(id: 12, name: 'Kadın Hastalıkları'),
    Tag(id: 13, name: 'Çoğul Gebelik'),
    Tag(id: 14, name: 'Anket'),
    Tag(id: 15, name: 'Öneri'),
    Tag(id: 16, name: 'Gündem'),
    Tag(id: 17, name: 'Alışveriş'),
  ];

  static List<Tag> getTags() {
    return tags;
  }

  static String getTagNameById(int id) {
    return tags.firstWhere((element) => element.id == id).name!;
  }

  static List<Tag> filterTagsByName(String name) {
    return tags
        .where(
          (element) => element.name!.toLowerCase().contains(name.toLowerCase()),
        )
        .toList();
  }
}
