import 'package:booknails/bloc/cubit/auth_cubit.dart';
import 'package:booknails/bloc/cubit/service_cubit.dart';
import 'package:booknails/models/appointment.dart';
import 'package:booknails/models/category.dart';
import 'package:booknails/models/nail_artist_profile.dart';
import 'package:booknails/models/service.dart';
import 'package:booknails/models/user.dart';
import 'package:booknails/screens/admin/admin_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User model', () {
    test('fromFirestore maps all fields and defaults the role', () {
      final createdAt = DateTime(2026, 4, 24, 10, 30);
      final updatedAt = DateTime(2026, 4, 24, 11, 0);

      final user = User.fromFirestore({
        'name': 'Kiss Mária',
        'email': 'maria@example.com',
        'phoneNumber': '+361234567',
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      }, 'uid-1');

      expect(user.uid, 'uid-1');
      expect(user.name, 'Kiss Mária');
      expect(user.email, 'maria@example.com');
      expect(user.role, 'user');
      expect(user.phoneNumber, '+361234567');
      expect(user.createdAt.isAtSameMomentAs(createdAt), isTrue);
      expect(user.updatedAt!.isAtSameMomentAs(updatedAt), isTrue);
    });

    test('toJson exports the expected Firestore payload', () {
      final createdAt = DateTime(2026, 4, 24, 10, 30);
      final updatedAt = DateTime(2026, 4, 24, 11, 0);
      final user = User(
        uid: 'uid-2',
        name: 'Admin Anna',
        email: 'admin@example.com',
        role: 'admin',
        phoneNumber: '+361111111',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final json = user.toJson();

      expect(json['name'], 'Admin Anna');
      expect(json['email'], 'admin@example.com');
      expect(json['role'], 'admin');
      expect(json['phoneNumber'], '+361111111');
      expect(json['createdAt'], same(createdAt));
      expect(json['updatedAt'], same(updatedAt));
    });

    test('copyWith keeps unchanged fields and overrides selected ones', () {
      final original = User(
        uid: 'uid-3',
        name: 'Név',
        email: 'user@example.com',
        role: 'user',
        phoneNumber: null,
        createdAt: DateTime(2026, 4, 24),
      );

      final copied = original.copyWith(
        name: 'Új név',
        role: 'admin',
      );

      expect(copied.uid, 'uid-3');
      expect(copied.name, 'Új név');
      expect(copied.email, 'user@example.com');
      expect(copied.role,  'admin');
      expect(copied.phoneNumber, isNull);
    });
  });

  group('Service model', () {
    test('fromFirestore parses numeric fields and defaults booleans', () {
      final createdAt = DateTime(2026, 4, 23, 9, 15);
      final service = Service.fromFirestore({
        'nailArtistProfileId': 'profile-1',
        'categoryId': 'cat-1',
        'name': 'Gél lakkozás',
        'description': 'Tartós szín és fényes felület',
        'price': 12500,
        'durationMinutes': 90,
        'createdAt': Timestamp.fromDate(createdAt),
      }, 'service-1');

      expect(service.id, 'service-1');
      expect(service.nailArtistProfileId, 'profile-1');
      expect(service.categoryId, 'cat-1');
      expect(service.name, 'Gél lakkozás');
      expect(service.price, 12500.0);
      expect(service.durationMinutes, 90);
      expect(service.isActive, isTrue);
      expect(service.createdAt.isAtSameMomentAs(createdAt), isTrue);
    });

    test('copyWith updates only the requested service fields', () {
      final original = Service(
        id: 'service-2',
        nailArtistProfileId: 'profile-1',
        categoryId: 'cat-1',
        name: 'Manikűr',
        description: 'Klasszikus manikűr',
        price: 9000,
        durationMinutes: 60,
        isActive: true,
        createdAt: DateTime(2026, 4, 20),
      );

      final copied = original.copyWith(
        price: 10500,
        isActive: false,
      );

      expect(copied.id, 'service-2');
      expect(copied.name, 'Manikűr');
      expect(copied.price, 10500);
      expect(copied.isActive, isFalse);
      expect(copied.durationMinutes, 60);
    });
  });

  group('Category model', () {
    test('fromFirestore reads name and createdAt correctly', () {
      final createdAt = DateTime(2026, 4, 22, 8, 0);
      final category = Category.fromFirestore({
        'name': 'Műköröm',
        'createdAt': Timestamp.fromDate(createdAt),
      }, 'cat-99');

      expect(category.id, 'cat-99');
      expect(category.name, 'Műköröm');
      expect(category.createdAt.isAtSameMomentAs(createdAt), isTrue);
    });

    test('toJson serializes category fields', () {
      final createdAt = DateTime(2026, 4, 22, 8, 0);
      final category = Category(
        id: 'cat-100',
        name: 'Pedikűr',
        createdAt: createdAt,
      );

      final json = category.toJson();

      expect(json['name'], 'Pedikűr');
      expect(json['createdAt'], same(createdAt));
    });
  });

  group('NailArtistProfile model', () {
    test('fromFirestore loads salon profile values and working hours', () {
      final createdAt = DateTime(2026, 4, 21, 14, 45);
      final profile = NailArtistProfile.fromFirestore({
        'userId': 'user-1',
        'salonName': 'Nails Studio',
        'address': 'Budapest, Fő utca 1.',
        'phoneNumber': '+3620111222',
        'profileImageUrl': 'https://example.com/image.jpg',
        'workingHours': {
          'monday': {'start': '09:00', 'end': '18:00'},
        },
        'createdAt': Timestamp.fromDate(createdAt),
      }, 'profile-1');

      expect(profile.id, 'profile-1');
      expect(profile.userId, 'user-1');
      expect(profile.salonName, 'Nails Studio');
      expect(profile.address, 'Budapest, Fő utca 1.');
      expect(profile.phoneNumber, '+3620111222');
      expect(profile.profileImageUrl, 'https://example.com/image.jpg');
      expect(profile.workingHours, containsPair('monday', containsPair('start', '09:00')));
      expect(profile.createdAt.isAtSameMomentAs(createdAt), isTrue);
    });

    test('copyWith can update the image url and address', () {
      final original = NailArtistProfile(
        id: 'profile-2',
        userId: 'user-2',
        salonName: 'Studio',
        address: 'Régi cím',
        phoneNumber: '12345',
        workingHours: const {},
        createdAt: DateTime(2026, 4, 20),
      );

      final copied = original.copyWith(
        address: 'Új cím',
        profileImageUrl: 'https://example.com/new.jpg',
      );

      expect(copied.id, 'profile-2');
      expect(copied.address, 'Új cím');
      expect(copied.profileImageUrl, 'https://example.com/new.jpg');
      expect(copied.salonName, 'Studio');
    });
  });

  group('Appointment model', () {
    test('fromFirestore maps appointment metadata and status', () {
      final appointmentDate = DateTime(2026, 5, 1, 13, 30);
      final createdAt = DateTime(2026, 4, 24, 12, 0);
      final appointment = Appointment.fromFirestore({
        'userId': 'user-1',
        'nailArtistProfileId': 'profile-1',
        'serviceId': 'service-1',
        'appointmentDate': Timestamp.fromDate(appointmentDate),
        'startTime': '13:30',
        'requestedDurationMinutes': 90,
        'estimatedDurationMinutes': 95,
        'note': 'Please call me',
        'status': 'confirmed',
        'createdAt': Timestamp.fromDate(createdAt),
      }, 'apt-1');

      expect(appointment.id, 'apt-1');
      expect(appointment.userId, 'user-1');
      expect(appointment.nailArtistProfileId, 'profile-1');
      expect(appointment.serviceId, 'service-1');
      expect(appointment.appointmentDate.isAtSameMomentAs(appointmentDate), isTrue);
      expect(appointment.startTime, '13:30');
      expect(appointment.requestedDurationMinutes, 90);
      expect(appointment.estimatedDurationMinutes, 95);
      expect(appointment.note, 'Please call me');
      expect(appointment.status, 'confirmed');
      expect(appointment.createdAt.isAtSameMomentAs(createdAt), isTrue);
    });

    test('toJson exports appointment scheduling data', () {
      final appointmentDate = DateTime(2026, 5, 1, 13, 30);
      final createdAt = DateTime(2026, 4, 24, 12, 0);
      final updatedAt = DateTime(2026, 4, 24, 13, 0);
      final appointment = Appointment(
        id: 'apt-2',
        userId: 'user-2',
        nailArtistProfileId: 'profile-2',
        serviceId: 'service-2',
        appointmentDate: appointmentDate,
        startTime: '13:30',
        requestedDurationMinutes: 60,
        estimatedDurationMinutes: 60,
        note: null,
        status: 'pending',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final json = appointment.toJson();

      expect(json['userId'], 'user-2');
      expect(json['nailArtistProfileId'], 'profile-2');
      expect(json['serviceId'], 'service-2');
      expect(json['appointmentDate'], same(appointmentDate));
      expect(json['startTime'], '13:30');
      expect(json['requestedDurationMinutes'], 60);
      expect(json['estimatedDurationMinutes'], 60);
      expect(json['status'], 'pending');
      expect(json['createdAt'], same(createdAt));
      expect(json['updatedAt'], same(updatedAt));
    });
  });

  group('ServicePagedLoaded state', () {
    test('copyWith preserves loaded services and updates metadata', () {
      final service = Service(
        id: 'service-1',
        nailArtistProfileId: 'profile-1',
        categoryId: 'cat-1',
        name: 'Manikűr',
        description: 'Leírás',
        price: 10000,
        durationMinutes: 60,
        isActive: true,
        createdAt: DateTime(2026, 4, 20),
      );

      final state = ServicePagedLoaded(
        [service],
        hasMore: true,
        isLoadingMore: false,
        loadMoreError: 'régi hiba',
      );

      final copied = state.copyWith(
        hasMore: false,
        isLoadingMore: true,
        loadMoreError: 'új hiba',
      );

      expect(copied.services, same(state.services));
      expect(copied.hasMore, isFalse);
      expect(copied.isLoadingMore, isTrue);
      expect(copied.loadMoreError, 'új hiba');
    });
  });

  group('Auth state equality', () {
    test('AuthAuthenticated compares uid and email', () {
      expect(
        const AuthAuthenticated(uid: 'uid-1', email: 'a@example.com'),
        equals(const AuthAuthenticated(uid: 'uid-1', email: 'a@example.com')),
      );
      expect(
        const AuthAuthenticated(uid: 'uid-1', email: 'a@example.com'),
        isNot(equals(const AuthAuthenticated(uid: 'uid-2', email: 'a@example.com'))),
      );
    });

    test('AuthError includes message and stackTrace in equality', () {
      final stackTrace = StackTrace.current;
      expect(
        AuthError('hiba', stackTrace: stackTrace),
        equals(AuthError('hiba', stackTrace: stackTrace)),
      );
      expect(
        AuthError('hiba', stackTrace: stackTrace),
        isNot(equals(AuthError('más hiba', stackTrace: stackTrace))),
      );
    });
  });

  group('Admin dashboard section mapping', () {
    test('routeValue maps profile section correctly', () {
      expect(AdminManagementSection.profile.routeValue, 'profile');
      expect(AdminManagementSectionX.fromRouteValue('profile'), AdminManagementSection.profile);
    });

    test('routeValue maps services section correctly', () {
      expect(AdminManagementSection.services.routeValue, 'services');
      expect(AdminManagementSectionX.fromRouteValue('services'), AdminManagementSection.services);
    });

    test('routeValue maps appointments section correctly', () {
      expect(AdminManagementSection.appointments.routeValue, 'appointments');
      expect(AdminManagementSectionX.fromRouteValue('appointments'), AdminManagementSection.appointments);
    });

    test('unknown route value returns null and labels stay descriptive', () {
      expect(AdminManagementSectionX.fromRouteValue('unknown'), isNull);
      expect(AdminManagementSection.profile.title, contains('Nail artist profil'));
      expect(AdminManagementSection.services.subtitle, contains('szolgáltatásokat'));
    });
  });
}

