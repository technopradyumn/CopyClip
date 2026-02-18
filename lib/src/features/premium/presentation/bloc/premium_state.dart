import 'package:equatable/equatable.dart';

class PremiumState extends Equatable {
  final int coins;
  final DateTime? premiumExpiryDate;
  final bool isAdLoading;
  final bool isAdReady;
  final bool isPremiumOverride; // For testing

  const PremiumState({
    this.coins = 0,
    this.premiumExpiryDate,
    this.isAdLoading = false,
    this.isAdReady = false,
    this.isPremiumOverride = false,
  });

  bool get isPremium {
    if (isPremiumOverride) return true;
    if (premiumExpiryDate == null) return false;
    return premiumExpiryDate!.isAfter(DateTime.now());
  }

  PremiumState copyWith({
    int? coins,
    DateTime? premiumExpiryDate,
    bool? isAdLoading,
    bool? isAdReady,
    bool? isPremiumOverride,
  }) {
    return PremiumState(
      coins: coins ?? this.coins,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      isAdLoading: isAdLoading ?? this.isAdLoading,
      isAdReady: isAdReady ?? this.isAdReady,
      isPremiumOverride: isPremiumOverride ?? this.isPremiumOverride,
    );
  }

  @override
  List<Object?> get props => [
    coins,
    premiumExpiryDate,
    isAdLoading,
    isAdReady,
    isPremiumOverride,
  ];
}
