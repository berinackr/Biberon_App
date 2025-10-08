import { gender as enumGender } from 'src/database/enums';
import {
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'unknownGender', async: false })
export class IsGenderNotUnknown implements ValidatorConstraintInterface {
  validate(gender: string) {
    return gender !== enumGender.UNKNOWN; // for async validations you must return a Promise<boolean> here
  }

  defaultMessage() {
    // here you can provide default error message if validation failed
    return 'Cinsiyet bilinmiyor olamaz.';
  }
}
