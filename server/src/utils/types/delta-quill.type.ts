export type QuillDeltaOperation = {
  insert: string;
  attributes?: {
    bold?: boolean;
    italic?: boolean;
    strike?: boolean;
    underline?: boolean;
    list?: 'ordered' | 'bullet';
    blockquote?: boolean;
    link?: string;
  };
};

export type QuillDelta = QuillDeltaOperation[];
