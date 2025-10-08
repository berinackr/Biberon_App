import { ThrottlerGuard } from '@nestjs/throttler';

export class LimitByUserGuard extends ThrottlerGuard {
  protected getTracker(req: Record<string, any>): Promise<string> {
    return req.user.id;
  }

  protected getErrorMessage(): Promise<string> {
    return Promise.resolve('Rate limit exceeded');
  }
}
