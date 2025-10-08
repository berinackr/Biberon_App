import { ApiProperty } from '@nestjs/swagger';

export class DeltaOperation {
  @ApiProperty({ description: 'The text to be inserted' })
  insert!: string;

  @ApiProperty({
    description: 'Formatting attributes',
    required: false,
    type: 'object',
    properties: {
      bold: { type: 'boolean', description: 'Whether the text is bold' },
      italic: { type: 'boolean', description: 'Whether the text is italic' },
      strike: { type: 'boolean', description: 'Whether the text is striked' },
      underline: {
        type: 'boolean',
        description: 'Whether the text is underlined',
      },
      list: {
        type: 'string',
        enum: ['ordered', 'bullet'],
        description: 'Whether the text is part of a list',
      },
      blockquote: {
        type: 'boolean',
        description: 'Whether the text is a blockquote',
      },
      link: { type: 'string', description: 'The link URL' },
    },
  })
  attributes?: {
    bold?: boolean;
    italic?: boolean;
    strike?: boolean;
    underline?: boolean;
    list?: 'ordered' | 'bullet';
    blockquote?: boolean;
    link?: string;
  };
}
