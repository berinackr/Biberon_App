import 'package:biberon/common/errors/exception.dart';
import 'package:biberon/common/models/response_model.dart';
import 'package:biberon/features/forum/domain/models/forum_feed_model.dart';
import 'package:biberon/features/user/profile/domain/models/models.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<AppException, T>>;
typedef FutureVoid = FutureEither<void>;
typedef FutureResponse = FutureEither<ResponseModel>;
typedef FutureProfile = FutureEither<ProfileModel>;
typedef FutureBaby = FutureEither<Baby>;
typedef FutureBabies = FutureEither<List<Baby>>;
typedef FuturePregnancy = FutureEither<Pregnancy>;
typedef FuturePregnancies = FutureEither<List<Pregnancy>>;
typedef FutureFetus = FutureEither<Fetus>;

typedef FutureFeed = FutureEither<Feed>;
