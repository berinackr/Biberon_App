export const gender = {
  BOY: 'BOY',
  GIRL: 'GIRL',
  UNKNOWN: 'UNKNOWN',
} as const;
export type gender = (typeof gender)[keyof typeof gender];
export const pregnancyType = {
  SINGLE: 'SINGLE',
  TWIN: 'TWIN',
  TRIPLET: 'TRIPLET',
} as const;
export type pregnancyType = (typeof pregnancyType)[keyof typeof pregnancyType];
export const role = {
  USER: 'USER',
  ADMIN: 'ADMIN',
  DOCTOR: 'DOCTOR',
} as const;
export type role = (typeof role)[keyof typeof role];
export const provider = {
  LOCAL: 'LOCAL',
  GOOGLE: 'GOOGLE',
  ADMIN: 'ADMIN',
} as const;
export type provider = (typeof provider)[keyof typeof provider];
export const status = {
  PENDING: 'PENDING',
  APPROVED: 'APPROVED',
  CANCELLED: 'CANCELLED',
} as const;
export type status = (typeof status)[keyof typeof status];
export const deliveryType = {
  VAGINAL: 'VAGINAL',
  CESAREAN: 'CESAREAN',
  UNKNOWN: 'UNKNOWN',
} as const;
export type deliveryType = (typeof deliveryType)[keyof typeof deliveryType];
