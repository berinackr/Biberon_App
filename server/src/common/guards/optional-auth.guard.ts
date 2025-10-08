import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class OptionalJwtAuthGuard extends AuthGuard('unprotected-jwt') {
  canActivate(context: ExecutionContext) {
    // Try to authenticate the user using the parent (default) method
    return super.canActivate(context);
  }

  handleRequest(err, user, info) {
    // If there's an error, log it and continue with the request
    if (err || info instanceof Error) {
      console.log(err || info);
    }
    return user;
  }
}
