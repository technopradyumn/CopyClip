import 'package:hive/hive.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_platform_selector.dart';

part 'social_post_model.g.dart';

@HiveType(typeId: 8) // Ensure this ID is unique
class SocialPost extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content; // Rich text JSON or plain text

  @HiveField(2)
  List<String> mediaPaths;

  @HiveField(3)
  int platformIndex; // Stores index of SocialPlatformType

  @HiveField(4)
  bool isFavorite;

  @HiveField(5)
  bool isDraft;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  SocialPost({
    required this.id,
    required this.content,
    required this.mediaPaths,
    required this.platformIndex,
    this.isFavorite = false,
    this.isDraft = false,
    required this.createdAt,
    required this.updatedAt,
  });

  SocialPlatformType get platform => SocialPlatformType.values[platformIndex];
}
