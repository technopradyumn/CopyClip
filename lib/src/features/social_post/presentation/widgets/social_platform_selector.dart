import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Enhanced Enum to support more platforms than social_sharing_plus defaults
enum SocialPlatformType {
  facebook,
  twitter,
  instagram,
  whatsapp,
  linkedin,
  telegram,
  reddit,
  tiktok,
  snapchat,
  pinterest,
  youtube,
  discord,
  medium,
  tumblr,
  wechat,
  line,
  kakaoTalk,
  viber,
  sms,
  email,
  skype,
  zoom,
  trello,
  slack,
  notion,
  github,
  gitlab,
  bitbucket,
  generic, // System Share
}

class SocialPlatformSelector extends StatelessWidget {
  final SocialPlatformType selectedPlatform;
  final ValueChanged<SocialPlatformType> onPlatformChanged;

  const SocialPlatformSelector({
    super.key,
    required this.selectedPlatform,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Custom Order: Most popular/important apps first
    final platforms = [
      SocialPlatformType.instagram,
      SocialPlatformType.facebook,
      SocialPlatformType.whatsapp,
      SocialPlatformType.twitter,
      SocialPlatformType.tiktok,
      SocialPlatformType.youtube,
      SocialPlatformType.linkedin,
      SocialPlatformType.snapchat,
      SocialPlatformType.pinterest,
      SocialPlatformType.telegram,
      SocialPlatformType.reddit,
      SocialPlatformType.discord,
      SocialPlatformType.generic,
      // Add others sorted by likely usage
      SocialPlatformType.medium,
      SocialPlatformType.tumblr,
      SocialPlatformType.wechat,
      SocialPlatformType.line,
      SocialPlatformType.kakaoTalk,
      SocialPlatformType.viber,
      SocialPlatformType.sms,
      SocialPlatformType.email,
      SocialPlatformType.skype,
      SocialPlatformType.zoom,
      SocialPlatformType.trello,
      SocialPlatformType.slack,
      SocialPlatformType.notion,
      SocialPlatformType.github,
      SocialPlatformType.gitlab,
      SocialPlatformType.bitbucket,
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: platforms.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final platform = platforms[index];
          final isSelected = platform == selectedPlatform;
          final theme = Theme.of(context);
          final platformData = getPlatformData(platform, theme);

          return GestureDetector(
            onTap: () => onPlatformChanged(platform),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? platformData.color
                        : theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: platformData.color.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? platformData.color
                          : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      width: 2,
                    ),
                  ),
                  child: FaIcon(
                    platformData.icon,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  platformData.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? platformData.color
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static PlatformData getPlatformData(
    SocialPlatformType type,
    ThemeData theme,
  ) {
    switch (type) {
      case SocialPlatformType.facebook:
        return PlatformData(
          "Facebook",
          FontAwesomeIcons.facebookF,
          const Color(0xFF1877F2),
        );
      case SocialPlatformType.twitter:
        return PlatformData(
          "X / Twitter",
          FontAwesomeIcons.twitter,
          Colors.black,
        );
      case SocialPlatformType.instagram:
        return PlatformData(
          "Instagram",
          FontAwesomeIcons.instagram,
          const Color(0xFFE4405F),
        );
      case SocialPlatformType.whatsapp:
        return PlatformData(
          "WhatsApp",
          FontAwesomeIcons.whatsapp,
          const Color(0xFF25D366),
        );
      case SocialPlatformType.linkedin:
        return PlatformData(
          "LinkedIn",
          FontAwesomeIcons.linkedinIn,
          const Color(0xFF0077B5),
        );
      case SocialPlatformType.telegram:
        return PlatformData(
          "Telegram",
          FontAwesomeIcons.telegram,
          const Color(0xFF0088CC),
        );
      case SocialPlatformType.reddit:
        return PlatformData(
          "Reddit",
          FontAwesomeIcons.redditAlien,
          const Color(0xFFFF4500),
        );
      case SocialPlatformType.tiktok:
        return PlatformData("TikTok", FontAwesomeIcons.tiktok, Colors.black);
      case SocialPlatformType.snapchat:
        return PlatformData(
          "Snapchat",
          FontAwesomeIcons.snapchat,
          const Color(0xFFFFFC00),
        );
      case SocialPlatformType.pinterest:
        return PlatformData(
          "Pinterest",
          FontAwesomeIcons.pinterestP,
          const Color(0xFFBD081C),
        );
      case SocialPlatformType.youtube:
        return PlatformData(
          "YouTube",
          FontAwesomeIcons.youtube,
          const Color(0xFFFF0000),
        );
      case SocialPlatformType.discord:
        return PlatformData(
          "Discord",
          FontAwesomeIcons.discord,
          const Color(0xFF5865F2),
        );
      case SocialPlatformType.medium:
        return PlatformData("Medium", FontAwesomeIcons.medium, Colors.black);
      case SocialPlatformType.tumblr:
        return PlatformData(
          "Tumblr",
          FontAwesomeIcons.tumblr,
          const Color(0xFF36465D),
        );
      case SocialPlatformType.wechat:
        return PlatformData(
          "WeChat",
          FontAwesomeIcons.weixin,
          const Color(0xFF7BB32E),
        );
      case SocialPlatformType.line:
        return PlatformData(
          "LINE",
          FontAwesomeIcons.line,
          const Color(0xFF00C300),
        );
      case SocialPlatformType.kakaoTalk:
        return PlatformData(
          "KakaoTalk",
          FontAwesomeIcons.solidComment,
          const Color(0xFFFFE812),
        );
      case SocialPlatformType.viber:
        return PlatformData(
          "Viber",
          FontAwesomeIcons.viber,
          const Color(0xFF665CAC),
        );
      case SocialPlatformType.sms:
        return PlatformData("SMS", Icons.sms, const Color(0xFF4CAF50));
      case SocialPlatformType.email:
        return PlatformData("Email", Icons.email, const Color(0xFFEA4335));
      case SocialPlatformType.skype:
        return PlatformData(
          "Skype",
          FontAwesomeIcons.skype,
          const Color(0xFF00AFF0),
        );
      case SocialPlatformType.zoom:
        return PlatformData("Zoom", Icons.videocam, const Color(0xFF2D8CFF));
      case SocialPlatformType.trello:
        return PlatformData(
          "Trello",
          FontAwesomeIcons.trello,
          const Color(0xFF0079BF),
        );
      case SocialPlatformType.slack:
        return PlatformData(
          "Slack",
          FontAwesomeIcons.slack,
          const Color(0xFF4A154B),
        );
      case SocialPlatformType.notion:
        return PlatformData("Notion", Icons.edit_document, Colors.black);
      case SocialPlatformType.github:
        return PlatformData("GitHub", FontAwesomeIcons.github, Colors.black);
      case SocialPlatformType.gitlab:
        return PlatformData(
          "GitLab",
          FontAwesomeIcons.gitlab,
          const Color(0xFFFC6D26),
        );
      case SocialPlatformType.bitbucket:
        return PlatformData(
          "Bitbucket",
          FontAwesomeIcons.bitbucket,
          const Color(0xFF0052CC),
        );
      case SocialPlatformType.generic:
        return PlatformData(
          "More",
          Icons.share_rounded,
          theme.colorScheme.primary,
        );
    }
  }
}

class SocialPlatformGridSelector extends StatelessWidget {
  final SocialPlatformType selectedPlatform;
  final ValueChanged<SocialPlatformType> onPlatformChanged;

  const SocialPlatformGridSelector({
    super.key,
    required this.selectedPlatform,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Same customized order as the horizontal selector
    final platforms = [
      SocialPlatformType.instagram,
      SocialPlatformType.facebook,
      SocialPlatformType.whatsapp,
      SocialPlatformType.twitter,
      SocialPlatformType.tiktok,
      SocialPlatformType.youtube,
      SocialPlatformType.linkedin,
      SocialPlatformType.snapchat,
      SocialPlatformType.pinterest,
      SocialPlatformType.telegram,
      SocialPlatformType.reddit,
      SocialPlatformType.discord,
      SocialPlatformType.generic,
      // Others
      SocialPlatformType.medium,
      SocialPlatformType.tumblr,
      SocialPlatformType.wechat,
      SocialPlatformType.line,
      SocialPlatformType.kakaoTalk,
      SocialPlatformType.viber,
      SocialPlatformType.sms,
      SocialPlatformType.email,
      SocialPlatformType.skype,
      SocialPlatformType.zoom,
      SocialPlatformType.trello,
      SocialPlatformType.slack,
      SocialPlatformType.notion,
      SocialPlatformType.github,
      SocialPlatformType.gitlab,
      SocialPlatformType.bitbucket,
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                "Select Platform",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: platforms.length,
                  itemBuilder: (context, index) {
                    final platform = platforms[index];
                    final isSelected = platform == selectedPlatform;
                    final theme = Theme.of(context);
                    // Reusing the static method from main class if possible, but it's private.
                    // We need to make _getPlatformData accessible or duplicate logic.
                    // For now, let's assume we refactor SocialPlatformSelector to make it public or mixin.
                    // Actually, let's just create a static helper.
                    final platformData = SocialPlatformSelector.getPlatformData(
                      platform,
                      theme,
                    );

                    return GestureDetector(
                      onTap: () => onPlatformChanged(platform),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? platformData.color
                                  : theme.colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? platformData.color
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.1,
                                      ),
                                width: 2,
                              ),
                            ),
                            child: FaIcon(
                              platformData.icon,
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            platformData.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? platformData.color
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PlatformData {
  final String name;
  final IconData icon;
  final Color color;

  PlatformData(this.name, this.icon, this.color);
}
