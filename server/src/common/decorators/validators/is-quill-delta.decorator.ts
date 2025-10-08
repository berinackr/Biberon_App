import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
  ValidationArguments,
} from 'class-validator';

@ValidatorConstraint({ name: 'isQuillDelta', async: false })
export class IsQuillDeltaConstraint implements ValidatorConstraintInterface {
  validate(value: any) {
    if (!value || typeof value !== 'object') {
      return false;
    }

    if (!Array.isArray(value)) {
      return false;
    }

    for (const op of value) {
      if (typeof op !== 'object') {
        return false;
      }

      if (typeof op.insert === 'undefined') {
        return false;
      }

      if (op.attributes) {
        if (typeof op.attributes !== 'object') {
          return false;
        }
        const allowedAttributes = [
          'bold',
          'italic',
          'strike',
          'underline',
          'list',
          'blockquote',
          'link',
        ];
        const allowedList = ['ordered', 'bullet'];
        const attributeKeys = Object.keys(op.attributes);
        if (attributeKeys.some((key) => !allowedAttributes.includes(key))) {
          return false;
        }
        // refactor this to check only attributekeys that are present loop through attributeKeys
        for (let i = 0; i < attributeKeys.length; i++) {
          if (attributeKeys[i] === 'list') {
            if (typeof op.attributes.list !== 'string') {
              return false;
            }
            if (!allowedList.includes(op.attributes.list)) {
              return false;
            }
          } else if (attributeKeys[i] === 'link') {
            if (typeof op.attributes.link !== 'string') {
              return false;
            }
          } else {
            if (typeof op.attributes[attributeKeys[i]] !== 'boolean') {
              return false;
            }
          }
        }
      }
    }

    return true;
  }

  defaultMessage(args: ValidationArguments) {
    return `${args.property} must be a valid Quill Delta object`;
  }
}

export function IsQuillDelta(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'isQuillDelta',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsQuillDeltaConstraint,
    });
  };
}
