import { ValidationError } from '@nestjs/common';

export function getErrorConstraintsRecursion(error: ValidationError) {
  if (error.constraints) {
    return Object.values(error.constraints).join(', ');
  }
  if (error.children && error.children.length > 0) {
    return getErrorConstraintsRecursion(error.children[0]);
  }
  return 'Geçerli bir değer girilmelidir.';
}
