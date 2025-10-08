import 'package:formz/formz.dart';

enum UserAgreementValidationError { invalid }

class UserAgreement extends FormzInput<bool, UserAgreementValidationError> {
  const UserAgreement.pure() : super.pure(false);
  const UserAgreement.dirty({bool value = false}) : super.dirty(value);

  @override
  UserAgreementValidationError? validator(bool value) {
    if (value == false) {
      return UserAgreementValidationError.invalid;
    }
    return null;
  }

  String? get errorMessage {
    if (error == UserAgreementValidationError.invalid) {
      return 'Üyelik sözleşmesini kabul etmelisiniz';
    }
    return null;
  }
}
