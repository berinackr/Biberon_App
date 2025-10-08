import { Transform, TransformFnParams } from 'class-transformer';
import { ValidationOptions } from 'class-validator';

export function Trim(validationOptions?: ValidationOptions) {
  return Transform(
    ({ value }: TransformFnParams) =>
      typeof value === 'string' ? value?.trim() : value,
    validationOptions,
  );
}
