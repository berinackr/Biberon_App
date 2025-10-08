import { z } from 'zod';

export const envSchema = z.object({
  PORT: z.coerce.number().default(3000),
  NODE_ENV: z
    .enum(['development', 'production', 'test'])
    .default('development'),
  DATABASE_URL: z.string(),
  DATABASE_NAME: z.string(),
  DATABASE_USERNAME: z.string(),
  DATABASE_PASSWORD: z.string(),
  DATABASE_HOST: z.string(),
  APP_NAME: z.string(),
  APP_URL: z.string(),
  ORGANIZATION: z.string(),
  APP: z.string(),
  CONTEXT: z.string(),
  JWT_SECRET: z.string().min(32),
  JWT_ACCESS_TOKEN_EXPIRATION_TIME: z.string(),
  REFRESH_TOKEN_EXPIRATION_TIME: z.string(),
  COOKIE_DOMAIN: z.string(),
  GOOGLE_CLIENT_ID: z.string(),
  GOOGLE_CLIENT_SECRET: z.string(),
  MAIL_HOST: z.string().optional(),
  MAIL_PORT: z.coerce.number().optional(),
  MAIL_USER: z.string().optional(),
  MAIL_PASSWORD: z.string().optional(),
  MAIL_IGNORE_TLS: z
    .string()
    .transform((val) => {
      if (val === 'true') return true;
      if (val === 'false') return false;
      throw new Error('MAIL_SECURE must be a boolean');
    })
    .optional(),
  MAIL_SECURE: z
    .string()
    .transform((val) => {
      if (val === 'true') return true;
      if (val === 'false') return false;
      throw new Error('MAIL_SECURE must be a boolean');
    })
    .optional(),
  MAIL_REQUIRE_TLS: z
    .string()
    .transform((val) => {
      if (val === 'true') return true;
      if (val === 'false') return false;
      throw new Error('MAIL_SECURE must be a boolean');
    })
    .optional(),
  MAIL_DEFAULT_EMAIL: z.string().optional(),
  MAIL_DEFAULT_NAME: z.string().optional(),
  MAIL_CLIENT_PORT: z.coerce.number().optional(),
  AWS_SES_ACCESS_KEY: z.string().optional(),
  AWS_SES_SECRET_ACCESS_KEY: z.string().optional(),
  AWS_S3_ACCESS_KEY: z.string(),
  AWS_S3_SECRET_ACCESS_KEY: z.string(),
  AWS_S3_BUCKET: z.string(),
  AWS_REGION: z.string(),
  LOKI_URL: z.string().optional(),
  LOKI_USERNAME: z.string().optional(),
  LOKI_PASSWORD: z.string().optional(),
});

export type Env = z.infer<typeof envSchema>;
