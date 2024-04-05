import 'package:core_util/util.dart';
import 'package:flutter/material.dart';
import 'package:tool_clind_component/component.dart';
import 'package:tool_clind_theme/gen/gen.dart';
import 'package:tool_clind_theme/theme.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final ValueNotifier<String> _channelNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _titleNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _contentNotifier = ValueNotifier<String>('');

  @override
  void dispose() {
    _channelNotifier.dispose();
    _titleNotifier.dispose();
    _contentNotifier.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    final List<FocusNode> focusNodes = [
      FocusScope.of(context),
      FocusManager.instance.primaryFocus,
    ].whereType<FocusNode>().toList();

    for (final FocusNode focusNode in focusNodes) {
      focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.bg2,
      appBar: ClindAppBar(
        context: context,
        leading: ClindAppBarTextButton(
          text: '취소',
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          color: context.colorScheme.gray100,
          onTap: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 56.0,
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: _channelNotifier,
            builder: (context, channel, child) => ValueListenableBuilder<String>(
              valueListenable: _titleNotifier,
              builder: (context, title, child) => ValueListenableBuilder<String>(
                valueListenable: _contentNotifier,
                builder: (context, content, child) {
                  final bool isActive = channel.isNotEmpty && title.isNotEmpty && content.isNotEmpty;
                  return ClindAppBarTextButton(
                    text: '등록',
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(
                      right: 20.0,
                    ),
                    color: isActive ? ColorName.blue : context.colorScheme.gray600,
                    onTap: () {
                      if (!isActive) return;
                      ClindDialog.showConfirm(
                        context,
                        title: "'$channel'에 글을 등록하시겠습니까?",
                        onConfirm: () {
                          // TODO: API
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => _hideKeyboard(),
        behavior: HitTestBehavior.translucent,
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    if (_channelNotifier.value.isEmpty) {
                      _channelNotifier.value = '회사생활';
                    } else {
                      _channelNotifier.value = '';
                    }
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 38.0,
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 16.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ValueListenableBuilder<String>(
                              valueListenable: _channelNotifier,
                              builder: (context, value, child) => Text(
                                value.isEmpty ? '등록 위치를 선택하세요' : value,
                                style: context.textTheme.default16SemiBold.copyWith(
                                  color: context.colorScheme.gray100,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          ClindIcon.expandMore(
                            color: context.colorScheme.gray400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ClindDivider.horizontal(),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: _channelNotifier,
                        builder: (context, value, child) {
                          if (value.isNotEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                            ),
                            child: Text(
                              '작성자: 설계사D · 서울건설',
                              style: context.textTheme.default12Regular.copyWith(
                                color: context.colorScheme.gray600,
                              ),
                            ),
                          );
                        },
                      ),
                      CoreTextField(
                        cursorColor: context.colorScheme.white,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '제목을 입력해주세요.',
                          hintStyle: context.textTheme.default17SemiBold.copyWith(
                            color: context.colorScheme.gray600,
                          ),
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: context.textTheme.default17SemiBold.copyWith(
                          color: context.colorScheme.gray100,
                        ),
                        keyboardAppearance: context.colorScheme.brightness,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          _titleNotifier.value = value;
                        },
                        onSubmitted: (value) {
                          _titleNotifier.value = value;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      CoreTextField(
                        cursorColor: context.colorScheme.white,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '내용을 입력해주세요.',
                          hintStyle: context.textTheme.default15Medium.copyWith(
                            color: context.colorScheme.gray600,
                          ),
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: context.textTheme.default15Medium.copyWith(
                          color: context.colorScheme.gray100,
                        ),
                        keyboardAppearance: context.colorScheme.brightness,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value) {
                          _contentNotifier.value = value;
                        },
                        onSubmitted: (value) {
                          _contentNotifier.value = value;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.viewPaddingOf(context).bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
