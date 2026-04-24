import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/nail_artist_profile.dart';
import '../../services/nail_artist_profile_service.dart';

part '../state/nail_artist_profile_state.dart';

/// Cubit for managing nail artist profile business logic
class NailArtistProfileCubit extends Cubit<NailArtistProfileState> {
  final NailArtistProfileService _nailArtistProfileService;

  NailArtistProfileCubit(this._nailArtistProfileService)
      : super(const NailArtistProfileInitial());

  /// Fetch all nail artist profiles
  Future<void> fetchNailArtistProfiles() async {
    try {
      emit(const NailArtistProfileLoading());
      final profiles = await _nailArtistProfileService.getAllNailArtistProfiles();
      emit(NailArtistProfileLoaded(profiles));
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error fetching nail artist profiles: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch a single nail artist profile by ID
  Future<void> fetchNailArtistProfile(String profileId) async {
    try {
      emit(const NailArtistProfileLoading());
      final profile = await _nailArtistProfileService.getNailArtistProfile(profileId);
      if (profile != null) {
        emit(NailArtistProfileDetailLoaded(profile));
      } else {
        emit(const NailArtistProfileError('Nail artist profile not found'));
      }
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error fetching nail artist profile: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch nail artist profile by user ID
  Future<void> fetchNailArtistProfileByUserId(String userId) async {
    try {
      emit(const NailArtistProfileLoading());
      final profile =
          await _nailArtistProfileService.getNailArtistProfileByUserId(userId);
      if (profile != null) {
        emit(NailArtistProfileDetailLoaded(profile));
      } else {
        emit(const NailArtistProfileError('Nail artist profile not found'));
      }
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error fetching nail artist profile by user ID: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Create a new nail artist profile
  Future<void> createNailArtistProfile({
    required String userId,
    required String salonName,
    required String address,
    required String phoneNumber,
    String? profileImageUrl,
    required Map<String, dynamic> workingHours,
  }) async {
    try {
      emit(const NailArtistProfileLoading());
      final profileId = await _nailArtistProfileService.createNailArtistProfile(
        userId: userId,
        salonName: salonName,
        address: address,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        workingHours: workingHours,
      );
      emit(NailArtistProfileCreated(profileId));
      // Refresh the list after creation
      await fetchNailArtistProfiles();
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error creating nail artist profile: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Update an existing nail artist profile
  Future<void> updateNailArtistProfile({
    required String profileId,
    String? salonName,
    String? address,
    String? phoneNumber,
    String? profileImageUrl,
    Map<String, dynamic>? workingHours,
  }) async {
    try {
      emit(const NailArtistProfileLoading());
      await _nailArtistProfileService.updateNailArtistProfile(
        profileId: profileId,
        salonName: salonName,
        address: address,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        workingHours: workingHours,
      );
      final updatedProfile =
          await _nailArtistProfileService.getNailArtistProfile(profileId);
      if (updatedProfile != null) {
        emit(NailArtistProfileUpdated(updatedProfile));
        // Refresh the list after update
        await fetchNailArtistProfiles();
      } else {
        emit(const NailArtistProfileError('Failed to fetch updated profile'));
      }
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error updating nail artist profile: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Delete a nail artist profile
  Future<void> deleteNailArtistProfile(String profileId) async {
    try {
      emit(const NailArtistProfileLoading());
      await _nailArtistProfileService.deleteNailArtistProfile(profileId);
      emit(NailArtistProfileDeleted(profileId));
      // Refresh the list after deletion
      await fetchNailArtistProfiles();
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error deleting nail artist profile: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch nail artist profiles as a stream
  void watchNailArtistProfiles() {
    try {
      emit(const NailArtistProfileLoading());
      _nailArtistProfileService.getNailArtistProfilesStream().listen((profiles) {
        emit(NailArtistProfileLoaded(profiles));
      }).onError((error, stackTrace) {
        emit(NailArtistProfileError(
          'Error watching nail artist profiles: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error setting up nail artist profiles stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch a single nail artist profile as a stream
  void watchNailArtistProfile(String profileId) {
    try {
      emit(const NailArtistProfileLoading());
      _nailArtistProfileService
          .getNailArtistProfileStream(profileId)
          .listen((profile) {
        if (profile != null) {
          emit(NailArtistProfileDetailLoaded(profile));
        } else {
          emit(const NailArtistProfileError('Nail artist profile not found'));
        }
      }).onError((error, stackTrace) {
        emit(NailArtistProfileError(
          'Error watching nail artist profile: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error setting up nail artist profile stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch nail artist profile by user ID as a stream
  void watchNailArtistProfileByUserId(String userId) {
    try {
      emit(const NailArtistProfileLoading());
      _nailArtistProfileService
          .getNailArtistProfileByUserIdStream(userId)
          .listen((profile) {
        if (profile != null) {
          emit(NailArtistProfileDetailLoaded(profile));
        } else {
          emit(const NailArtistProfileError('Nail artist profile not found'));
        }
      }).onError((error, stackTrace) {
        emit(NailArtistProfileError(
          'Error watching nail artist profile by user ID: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(NailArtistProfileError(
        'Error setting up nail artist profile by user ID stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }
}

