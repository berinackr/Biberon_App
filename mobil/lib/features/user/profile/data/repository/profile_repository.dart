import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/user/profile/data/datasources/profile_api.dart';
import 'package:biberon/features/user/profile/data/models/models.dart'
    as postmodel;

class ProfileRepository {
  const ProfileRepository({
    required ProfileApi profileApi,
  }) : _profileApi = profileApi;

  final ProfileApi _profileApi;

  //Update user profile
  FutureProfile updateUserProfile(
    postmodel.UpdateProfilePostModel updateProfilePostModel,
  ) =>
      _profileApi.updateUserProfile(
        updateProfilePostModel: updateProfilePostModel,
      );

  // Get profile
  FutureProfile getUserProfile() => _profileApi.getUserProfile();

  FutureBaby addBaby(postmodel.BabyPostModel babyPostModel) =>
      _profileApi.addBaby(babyPostModel: babyPostModel);

  FutureBabies getBabies(String order, int page) => _profileApi.getBabies(
        order: order,
        page: page,
      );

  FutureBaby getBaby(int babyId) => _profileApi.getBaby(babyId: babyId);

  FutureBaby updateBaby(int babyId, postmodel.BabyPostModel babyPostModel) =>
      _profileApi.updateBaby(
        babyId: babyId,
        babyPostModel: babyPostModel,
      );

  FutureVoid deleteBaby({required int babyId}) =>
      _profileApi.deleteBaby(babyId: babyId);

  FuturePregnancy addPregnancy({
    required postmodel.PregnancyPostModel pregnancyPostModel,
  }) =>
      _profileApi.addPregnancy(
        pregnancyPostModel: pregnancyPostModel,
      );

  FuturePregnancies getPregnancies(String order, int page) =>
      _profileApi.getPregnancies(
        order: order,
        page: page,
      );

  FuturePregnancy getActivePregnancy({required bool includeFetuses}) =>
      _profileApi.getActivePregnancy(
        includeFetuses: includeFetuses,
      );

  FuturePregnancy getPregnancy({
    required int pregnancyId,
    required bool includeFetuses,
  }) =>
      _profileApi.getPregnancy(
        pregnancyId: pregnancyId,
        includeFetuses: includeFetuses,
      );

  FuturePregnancy updatePregnancy({
    required int pregnancyId,
    required postmodel.PregnancyPostModel pregnancyPostModel,
  }) =>
      _profileApi.updatePregnancy(
        pregnancyId: pregnancyId,
        pregnancyPostModel: pregnancyPostModel,
      );

  FutureVoid deletePregnancy({required int pregnancyId}) =>
      _profileApi.deletePregnancy(
        pregnancyId: pregnancyId,
      );

  // Burada data gelirken hata olursa FetusPostModel classının ismini
  // Change all occurences veya rename symbol ile Fetus yap
  FutureFetus updateFetus({
    required int pregnancyId,
    required int fetusId,
    required postmodel.FetusPostModel fetusPostModel,
  }) =>
      _profileApi.updateFetus(
        fetusId: fetusId,
        fetus: fetusPostModel,
      );

  FuturePregnancy completeActivePregnancy({required DateTime birthDate}) =>
      _profileApi.updateActivePregnancy(
        birthDate: birthDate,
      );
}
