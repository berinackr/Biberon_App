declare namespace Express {
  export interface Request {
    user: {
      id: string;
      role: 'USER' | 'ADMIN' | 'DOCTOR';
      emailVerified: boolean;
      email: string;
      name: string;
      iat: number;
      exp: number;
    };
  }
}
