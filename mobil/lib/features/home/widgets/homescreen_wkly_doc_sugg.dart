import 'package:flutter/material.dart';

class WeeklyDoctorSuggestion extends StatefulWidget {
  const WeeklyDoctorSuggestion({
    required this.viewportConstraints,
    this.imageSize = 30,
    super.key,
  });

  final BoxConstraints viewportConstraints;
  final double imageSize;

  @override
  State<WeeklyDoctorSuggestion> createState() => _WeeklyDoctorSuggestionState();
}

class _WeeklyDoctorSuggestionState extends State<WeeklyDoctorSuggestion> {
  bool isShowingFullText = false;
  int height = 3;
  void _toggleText() {
    setState(() {
      isShowingFullText = !isShowingFullText;
      height = isShowingFullText ? 100 : 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.imageSize;
    const s = 100.0;
    final k = widget.imageSize / 2;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20 / 2,
              ),
              child: Text(
                'Haftanın Doktor Önerisi',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            SizedBox(
              height: k,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20 / 2,
              ),
              child: Container(
                width: widget.viewportConstraints.maxWidth,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: widget.viewportConstraints.maxWidth * 0.7,
                      child: Text(
                        'Doç. Dr. İbrahim BAYLAV',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    Divider(
                      height: t,
                    ),
                    Text(
                      '''Gebeler son aya kadar ayda bir kez, son ay ise 15 günde bir kez kontrol için doktoruna gitmelidir. Gebelik sürecinde 9 ile 11 kg arası kilo almak sağlıklıdır. Gebeler son aya kadar ayda bir kez, son ay ise 15 günde bir kez kontrol için doktoruna gitmelidir. Gebelik sürecinde 9 ile 11 kg arası kilo almak sağlıklıdır.Gebeler son aya kadar ayda bir kez, son ay ise 15 günde bir kez kontrol için doktoruna gitmelidir. Gebelik sürecinde 9 ile 11 kg arası kilo almak sağlıklıdır.Gebeler son aya kadar ayda bir kez, son ay ise 15 günde bir kez kontrol için doktoruna gitmelidir. Gebelik sürecinde 9 ile 11 kg arası kilo almak sağlıklıdır.''',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: height,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _toggleText,
                            child: Text(
                              isShowingFullText
                                  ? 'Daha Az Göster'
                                  : 'Devamını Oku',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                highlightColor: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                                style: const ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: Icon(
                                  Icons.favorite,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                highlightColor: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                                style: const ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: Icon(
                                  Icons.volume_up_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                highlightColor: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                                style: const ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: Icon(
                                  Icons.bookmark_border_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: k - 10,
          right: s / 2 - 10,
          child: SizedBox(
            width: s,
            height: s,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: CircleAvatar(
                    radius: t + 5,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                Positioned(
                  child: CircleAvatar(
                    radius: t,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage('assets/icon.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
