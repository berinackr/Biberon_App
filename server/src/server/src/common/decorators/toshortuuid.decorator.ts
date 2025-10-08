import { Transform, TransformFnParams } from 'class-transformer';
import { ShortUuid } from '../short-uuid/short-uuid';

export function ToShortUuid() {
  return Transform(({ value }: TransformFnParams) => {
    if (typeof value === 'string') {
      return ShortUuid.getInstance().fromUUID(value);
    }
    return value;
  });
}
