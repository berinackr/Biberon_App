import { DeltaOperation } from '../../forum/dto/quill-delta.dto';

export function getTextsFromDelta(delta: DeltaOperation[]): string {
  return delta
    .filter((op) => typeof op.insert === 'string')
    .map((op) => op.insert)
    .join('');
}
