import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEmojiPicker extends StatelessWidget {
  const CustomEmojiPicker(
      {super.key, required this.emojiShowing, required this.onEmojiSelect});

  final bool emojiShowing;
  final Function(Emoji emoji) onEmojiSelect;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
          height: 180.h,
          child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                onEmojiSelect(emoji);
              },
              config: Config(
                height: 256,

                // bgColor: const Color(0xFFF2F2F2),

                checkPlatformCompatibility: true,

                emojiViewConfig: EmojiViewConfig(
                  // Issue: https://github.com/flutter/flutter/issues/28894

                  emojiSizeMax: 28 *
                      (defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.20
                          : 1.0),
                ),

                swapCategoryAndBottomBar: false,

                skinToneConfig: const SkinToneConfig(),

                categoryViewConfig: const CategoryViewConfig(),

                bottomActionBarConfig: const BottomActionBarConfig(
                  showSearchViewButton: false,
                  enabled: false,
                ),
              )
              // config: Config(
              //     columns: 7,
              //     // Issue: https://github.com/flutter/flutter/issues/28894
              //     emojiSizeMax: 32 *
              //         (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
              //     verticalSpacing: 0,
              //     horizontalSpacing: 0,
              //     gridPadding: EdgeInsets.zero,
              //     bgColor: const Color(0xFFF2F2F2),
              //     indicatorColor: Colors.blue,
              //     iconColor: Colors.grey,
              //     iconColorSelected: Colors.blue,
              //     backspaceColor: Colors.blue,
              //     skinToneDialogBgColor: Colors.white,
              //     skinToneIndicatorColor: Colors.grey,
              //     enableSkinTones: true,
              //     recentTabBehavior: RecentTabBehavior.RECENT,
              //     recentsLimit: 28,
              //     replaceEmojiOnLimitExceed: false,
              //     noRecents: const Text(
              //       'No Recents',
              //       style: TextStyle(fontSize: 20, color: Colors.black26),
              //       textAlign: TextAlign.center,
              //     ),
              //     loadingIndicator: const SizedBox.shrink(),
              //     tabIndicatorAnimDuration: kTabScrollDuration,
              //     categoryIcons: const CategoryIcons(),
              //     buttonMode: ButtonMode.MATERIAL,
              //     checkPlatformCompatibility: true,
              //     emojiTextStyle:
              //         const TextStyle(fontFamily: FontFamily.notoEmoji)),
              )),
    );
  }
}
