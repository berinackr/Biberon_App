import { faker } from '@faker-js/faker';

export function createRandomDeltaOp() {
  const insert = faker.lorem.sentence();
  const attributes = {
    bold: faker.datatype.boolean({ probability: 0.5 }) ? true : undefined,
    italic: faker.datatype.boolean({ probability: 0.5 }) ? true : undefined,
    strike: faker.datatype.boolean({ probability: 0.5 }) ? true : undefined,
    underline: faker.datatype.boolean({ probability: 0.5 }) ? true : undefined,
    list: (faker.datatype.boolean({ probability: 0.5 })
      ? faker.helpers.enumValue({ ordered: 'ordered', bullet: 'bullet' })
      : undefined) as 'ordered' | 'bullet' | undefined,
    blockquote: faker.datatype.boolean({ probability: 0.5 }) ? true : undefined,
    link: faker.datatype.boolean({ probability: 0.5 })
      ? faker.internet.url()
      : undefined,
  };

  return { insert, attributes };
}

export function createRandomDelta() {
  const numberOfOps = faker.number.int({ min: 1, max: 10 });
  const ops = Array.from({ length: numberOfOps }, createRandomDeltaOp);
  return ops;
}
