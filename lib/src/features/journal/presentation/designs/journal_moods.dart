import 'package:flutter/material.dart';

class JournalMoods {
  static const List<String> allMoods = [
    'Happy',
    'Excited',
    'Neutral',
    'Sad',
    'Stressed',
    'Angry',
    'Cool',
    'Love',
  ];

  static const Map<String, String> _moodEmojiMap = {
    'Happy': '😊',
    'Excited': '🤩',
    'Neutral': '😐',
    'Sad': '😔',
    'Stressed': '😫',
    'Angry': '😡',
    'Cool': '😎',
    'Love': '😍',
  };

  static String getEmoji(String mood) {
    return _moodEmojiMap[mood] ?? '😐';
  }

  static IconData getIcon(String mood) {
    switch (mood) {
      case 'Happy':
        return Icons.sentiment_very_satisfied;
      case 'Excited':
        return Icons.star;
      case 'Neutral':
        return Icons.sentiment_neutral;
      case 'Sad':
        return Icons.sentiment_very_dissatisfied;
      case 'Stressed':
        return Icons.sentiment_dissatisfied;
      case 'Angry':
        return Icons.mood_bad;
      case 'Cool':
        return Icons.mood;
      case 'Love':
        return Icons.favorite;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
