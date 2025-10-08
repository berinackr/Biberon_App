import 'package:formz/formz.dart';

abstract class FormzInputWithErrorMessage<T, E> extends FormzInput<T, E> {
  const FormzInputWithErrorMessage.pure(super.value) : super.pure();
  const FormzInputWithErrorMessage.dirty(super.value) : super.dirty();

  String? get errorMessage;
}
