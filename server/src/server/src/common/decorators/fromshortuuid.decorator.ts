import { Transform, TransformFnParams } from 'class-transformer';
import { ShortUuid } from '../short-uuid/short-uuid';

export function FromShortUuid() {
  return Transform(({ value }: TransformFnParams) => {
    if (ShortUuid.getInstance().validate(value)) {
      return ShortUuid.getInstance().toUUID(value);
    } else {
      return value;
    }
  });
}
