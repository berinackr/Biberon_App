part of 'feed_bloc.dart';

enum SortType {
  createdAt('createdAt', 'Oluşturulma Tarihi'),
  voteCount('voteCount', 'Oy Sayısı'),
  commentCount('commentCount', 'Yorum Sayısı'),
  lastActivity('lastActivity', 'Son Aktivite');

  const SortType(this.name, this.turkishName);
  final String name;
  final String turkishName;

  static SortType? fromName(String name) {
    for (final field in SortType.values) {
      if (field.name == name) {
        return field;
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'Field{name: $name, turkishName: $turkishName}';
  }
}

enum EnumTags {
  hepsi(0, 'Hepsi', Colors.white),
  saglik(1, 'Sağlık', Color.fromARGB(255, 255, 37, 110)),
  dogum(2, 'Doğum', Color.fromARGB(255, 176, 2, 207)),
  dogumHikayeleri(3, 'Doğum Hikayeleri', Colors.deepPurple),
  beslenme(4, 'Beslenme', Color.fromARGB(255, 83, 105, 230)),
  gebelik(5, 'Gebelik', Color.fromARGB(255, 54, 164, 255)),
  doktorHastane(6, 'Doktor & Hastane', Colors.lightBlue),
  urunDegerlendirme(7, 'Ürün Değerlendirme', Colors.cyan),
  kisiselBakim(8, 'Kişisel Bakım', Colors.teal),
  cinsellik(9, 'Cinsellik', Color.fromARGB(255, 255, 0, 0)),
  isimler(10, 'İsimler', Color.fromARGB(255, 181, 255, 97)),
  spor(11, 'Spor', Color.fromARGB(255, 46, 0, 249)),
  kadinHastaliklari(12, 'Kadın Hastalıkları', Color.fromARGB(255, 124, 162, 0)),
  cogulGebelik(13, 'Çoğul Gebelik', Colors.amber),
  anket(14, 'Anket', Colors.orange),
  oneri(15, 'Öneri', Color.fromARGB(255, 204, 50, 3)),
  gundem(16, 'Gündem', Color.fromARGB(255, 231, 62, 0)),
  alisveris(17, 'Alışveriş', Color.fromARGB(255, 0, 97, 145));

  const EnumTags(this.id, this.name, this.color);
  final int id;
  final String name;
  final Color color;

  static EnumTags? fromId(int id) {
    for (final category in EnumTags.values) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  static EnumTags? fromName(String name) {
    for (final category in EnumTags.values) {
      if (category.name == name) {
        return category;
      }
    }
    return null;
  }
}

class FeedState extends Equatable {
  const FeedState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.posts = const [],
    this.bookmarkedPosts = const [],
    this.sortDesc = false,
    this.tagId = 0,
    this.sortType = 'lastActivity',
    this.searchedPosts = const [],
    this.searchText = '',
    // UI states
    this.bookmarks = const [],
    this.isBookmarksCheckedBefore = false,
    this.selectedPost,
  });

  final FormzSubmissionStatus status;
  final String? errorMessage;
  final List<Post> posts;
  final Post? selectedPost;
  final List<Post> bookmarkedPosts;
  final bool sortDesc;
  final int tagId;
  final String sortType;
  final List<Post> searchedPosts;
  final String searchText;
  // UI states
  final List<Post> bookmarks;
  final bool isBookmarksCheckedBefore;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        posts,
        bookmarkedPosts,
        sortDesc,
        tagId,
        sortType,
        searchedPosts,
        searchText,
        bookmarks,
        isBookmarksCheckedBefore,
        selectedPost,
      ];

  FeedState copyWith({
    FormzSubmissionStatus? status,
    ValueGetter<String?>? errorMessage,
    List<Post>? posts,
    List<Post>? bookmarkedPosts,
    bool? sortDesc,
    int? tagId,
    String? sortType,
    List<Post>? searchedPosts,
    String? searchText,
    List<Post>? bookmarks,
    bool? isBookmarksCheckedBefore,
    Post? selectedPost,
  }) {
    return FeedState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      posts: posts ?? this.posts,
      bookmarkedPosts: bookmarkedPosts ?? this.bookmarkedPosts,
      sortDesc: sortDesc ?? this.sortDesc,
      tagId: tagId ?? this.tagId,
      sortType: sortType ?? this.sortType,
      searchedPosts: searchedPosts ?? this.searchedPosts,
      searchText: searchText ?? this.searchText,
      bookmarks: bookmarks ?? this.bookmarks,
      isBookmarksCheckedBefore:
          isBookmarksCheckedBefore ?? this.isBookmarksCheckedBefore,
      selectedPost: selectedPost ?? this.selectedPost,
    );
  }
}
