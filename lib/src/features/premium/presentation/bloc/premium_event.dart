import 'package:equatable/equatable.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object?> get props => [];
}

class LoadPremiumData extends PremiumEvent {}

class AddCoins extends PremiumEvent {
  final int amount;
  const AddCoins(this.amount);

  @override
  List<Object?> get props => [amount];
}

class BuyPremium extends PremiumEvent {}

class LoadRewardedAd extends PremiumEvent {}

class ShowRewardedAd extends PremiumEvent {
  final Function(int) onReward;
  const ShowRewardedAd({required this.onReward});

  // Equatable requires props, but Function isn't equatable nicely.
  // We generally act on the event.
  @override
  List<Object?> get props => [];
}

class ResetAdLoading extends PremiumEvent {}

class RewardedAdStatusChanged extends PremiumEvent {
  final bool isReady;
  final bool isLoading;
  const RewardedAdStatusChanged({
    required this.isReady,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [isReady, isLoading];
}
