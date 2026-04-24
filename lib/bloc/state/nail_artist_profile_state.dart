part of '../cubit/nail_artist_profile_cubit.dart';

/// Base state for nail artist profile operations
abstract class NailArtistProfileState extends Equatable {
  const NailArtistProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NailArtistProfileInitial extends NailArtistProfileState {
  const NailArtistProfileInitial();
}

/// Loading state
class NailArtistProfileLoading extends NailArtistProfileState {
  const NailArtistProfileLoading();
}

/// State when profiles are loaded successfully
class NailArtistProfileLoaded extends NailArtistProfileState {
  final List<NailArtistProfile> profiles;

  const NailArtistProfileLoaded(this.profiles);

  @override
  List<Object?> get props => [profiles];
}

/// State when a single profile is loaded
class NailArtistProfileDetailLoaded extends NailArtistProfileState {
  final NailArtistProfile profile;

  const NailArtistProfileDetailLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// State when profile creation is successful
class NailArtistProfileCreated extends NailArtistProfileState {
  final String profileId;

  const NailArtistProfileCreated(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

/// State when profile is updated successfully
class NailArtistProfileUpdated extends NailArtistProfileState {
  final NailArtistProfile profile;

  const NailArtistProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// State when profile is deleted successfully
class NailArtistProfileDeleted extends NailArtistProfileState {
  final String profileId;

  const NailArtistProfileDeleted(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

/// Error state
class NailArtistProfileError extends NailArtistProfileState {
  final String message;
  final StackTrace? stackTrace;

  const NailArtistProfileError(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}

