import short from 'short-uuid';

export class ShortUuid {
  private static instance: ShortUuid;
  private translator = short();

  private constructor() {}

  static getInstance() {
    if (!ShortUuid.instance) {
      ShortUuid.instance = new ShortUuid();
    }
    return ShortUuid.instance;
  }

  fromUUID(uuid: string) {
    return this.translator.fromUUID(uuid);
  }

  toUUID(shortUuid: string) {
    return this.translator.toUUID(shortUuid);
  }

  validate(shortUuid: string) {
    return this.translator.validate(shortUuid);
  }
}
