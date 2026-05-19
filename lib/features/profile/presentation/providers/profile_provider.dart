import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/models/app_user_model.dart';
import '../../../auth/data/services/user_firestore_service.dart';
import '../../data/models/address_model.dart';
import '../../data/services/address_firestore_service.dart';

class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String? avatarUrl;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    this.avatarUrl,
  });

  String get fullName => '$firstName $lastName';

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? avatarUrl,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
      : super(
          const UserProfile(
            firstName: 'Unknown',
            lastName: 'User',
            email: 'unknown@gmail.com',
            phone: '+923001234567',
            gender: 'Not specified',
          ),
        );

  void updateProfile(UserProfile profile) {
    state = profile;
  }

  void updateName(String firstName, String lastName) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
    );
  }
}

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier()
      : super([
          AddressModel(
            id: 'addr_1',
            name: 'Unknown User',
            phone: '+923001234567',
            street: 'House No 399, Hyderabad',
            city: 'Hyderabad',
            state: 'Sindh',
            postalCode: '71000',
            country: 'Pakistan',
            isDefault: true,
            createdAt: DateTime(2026, 1, 1),
            updatedAt: DateTime(2026, 1, 1),
          ),
          AddressModel(
            id: 'addr_2',
            name: 'Second Address',
            phone: '+923001234788',
            street: 'House No 399, Hyderabad',
            city: 'Hyderabad',
            state: 'Sindh',
            postalCode: '71000',
            country: 'Pakistan',
            isDefault: false,
            createdAt: DateTime(2026, 1, 1),
            updatedAt: DateTime(2026, 1, 1),
          ),
        ]);

  void addAddress(AddressModel address) {
    state = [...state, address];
  }

  void removeAddress(String id) {
    state = state.where((address) => address.id != id).toList();
  }

  void setDefault(String id) {
    state = state.map((address) {
      return address.copyWith(isDefault: address.id == id);
    }).toList();
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
  (ref) => ProfileNotifier(),
);

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<AddressModel>>(
  (ref) => AddressNotifier(),
);

final profileFirestoreServiceProvider = Provider<UserFirestoreService>((ref) {
  return UserFirestoreService();
});

final addressFirestoreServiceProvider =
    Provider<AddressFirestoreService>((ref) {
  return AddressFirestoreService();
});

final currentUserProfileProvider = FutureProvider<AppUserModel?>((ref) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  if (firebaseUser == null) {
    return null;
  }

  final firestoreService = ref.watch(profileFirestoreServiceProvider);

  return firestoreService.getUserProfile(firebaseUser.uid);
});

final currentUserAddressesProvider = StreamProvider<List<AddressModel>>((ref) {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  if (firebaseUser == null) {
    return const Stream.empty();
  }

  final addressService = ref.watch(addressFirestoreServiceProvider);

  return addressService.getUserAddresses(firebaseUser.uid);
});
