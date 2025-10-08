import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/user/profile/data/models/models.dart'
    as postmodels;

abstract class ProfileApi {
  const ProfileApi();
  // POST - /v1/users/password Bu işlem authenticaitonApi'da kullanılmış. Kullanıcının şifresini unuttuğunda kullanıcıya mail göndermek için kullanılır.
  // PATCH - /v1/users/password Sanırım bu da şifreyi değiştirme isteği ancak token parametresi nedir?

  /// PUT - /v1/users/profile Bu işlem kullanıcının profil bilgilerini güncellemek için kullanılır.
  FutureProfile updateUserProfile({
    required postmodels.UpdateProfilePostModel updateProfilePostModel,
  });

  /// GET - /v1/users/profile Bu işlem kullanıcının profil bilgilerini getirmek için kullanılır.
  FutureProfile getUserProfile();

  /// POST - /v1/users/baby Bu işlem kullanıcının bebeğini eklemek için kullanılır.
  FutureBaby addBaby({required postmodels.BabyPostModel babyPostModel});

  /// GET - /v1/users/baby Bu işlem kullanıcının tüm bebeklerini getirmek için kullanılır.
  FutureBabies getBabies({String order, int page});

  /// GET - /v1/users/baby/{id} Bu işlem kullanıcının bebeğini getirmek için kullanılır.
  FutureBaby getBaby({required int babyId});

  /// PATCH - /v1/users/baby/{id} Bu işlem kullanıcının bebeğini güncellemek için kullanılır.
  FutureBaby updateBaby({
    required int babyId,
    required postmodels.BabyPostModel babyPostModel,
  });

  /// DELETE - /v1/users/baby/{babyId} Bu işlem kullanıcının bebeğini silmek için kullanılır.
  FutureVoid deleteBaby({
    required int babyId,
  });

  /// POST - /v1/users/pregnancy Bu işlem kullanıcının hamileliğini eklemek için kullanılır.
  FuturePregnancy addPregnancy({
    required postmodels.PregnancyPostModel pregnancyPostModel,
  });

  /// GET - /v1/users/pregnancy Bu işlem kullanıcının hamileliklerini getirmek için kullanılır.
  FuturePregnancies getPregnancies({String order, int page});

  // Include parametresi dönen modeli değiştiriyor mu?
  // Yoksa fetuses null mu dönüyor?
  /// GET - /v1/users/pregnancy/active Bu işlem kullanıcının aktif hamileliğini getirmek için kullanılır.
  FuturePregnancy getActivePregnancy({required bool includeFetuses});

  // PATCH - /v1/users/pregnancy/active Aktif hamileliği sonlandır.
  FuturePregnancy updateActivePregnancy({
    required DateTime birthDate,
  });

  /// GET - /v1/users/pregnancy/{id}
  FuturePregnancy getPregnancy({
    required int pregnancyId,
    required bool includeFetuses,
  });

  /// PATCH - /v1/users/pregnancy/{id}
  FuturePregnancy updatePregnancy({
    required int pregnancyId,
    required postmodels.PregnancyPostModel pregnancyPostModel,
  });

  /// DELETE - /v1/users/pregnancy/{id}
  FutureVoid deletePregnancy({
    required int pregnancyId,
  });

  /// PATCH - /v1/users/pregnancy/fetus/{id}
  FutureFetus updateFetus({
    required int fetusId,
    required postmodels.FetusPostModel fetus,
  });
}
