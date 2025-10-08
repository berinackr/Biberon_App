import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseBoolPipe,
  ParseIntPipe,
  Patch,
  Post,
  Put,
  Query,
  Req,
  SerializeOptions,
  UseGuards,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import {
  ApiBadRequestResponse,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
  OmitType,
} from '@nestjs/swagger';
import { GeneralResponseDto } from '../common/dto/general-response.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { ResponseErrorDto } from '../common/dto/response-error.dto';
import { Request } from 'express';
import { AuthGuard } from '@nestjs/passport';
import { EmailVerifiedGuard } from '../common/guards/email-verifield.guard';
import { UserProfileEntity } from './entity/user-profile';
import { Roles } from '../common/decorators/roles.decorator';
import { UpdateUserProfileDto } from './dto/update-user-profile.dto';
import { RolesGuard } from '../common/guards/roles.guard';
import { BabyEntity } from './entity/baby';
import { CreateBabyDto } from './dto/create-baby.dto';
import { PaginationOptionsDto } from '../common/dto/pagination-options.dto';
import { UpdateBabyDto } from './dto/update-baby.dto';
import { CreatePregnancyDto } from './dto/create-pregnancy.dto';
import { PregnancyEntity } from './entity/pregnancy';
import { UpdatePregnancyDto } from './dto/update-pregnancy.dto';
import { BabyService } from './baby.service';
import { PregnancyService } from './pregnancy.service';
import { FetusEntity } from './entity/fetus';
import { CreateFetusDto } from './dto/create-fetus.dto';
import { UploadedImageDto } from './dto/uploaded-image.dto';
import { PresignedPostDto } from './dto/presigned-post.dto';
import { PresignedUrlDto } from './dto/presigned-url.dto';
import { LimitByUserGuard } from '../common/rate-limit/limit-by-user-guard';
import { ApiOkResponsePaginated } from '../common/decorators/swagger/ApiOkResponsePaginated.decorator';
import { BirthDto } from './dto/birth.dto';

@ApiTags('Users')
@Controller({
  path: 'users',
  version: '1',
})
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly babyService: BabyService,
    private readonly pregnancyService: PregnancyService,
  ) {}

  @Post('/password')
  @ApiCreatedResponse({
    description: 'Sends an email with a link to reset the password',
    type: GeneralResponseDto,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  async forgotPassword(@Body() forgotPasswordDto: ForgotPasswordDto) {
    return await this.usersService.forgotPassword(forgotPasswordDto);
  }

  @Patch('/password')
  @ApiOkResponse({
    description: 'Updates the password',
    type: GeneralResponseDto,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  async resetPassword(@Body() { token, password }: ResetPasswordDto) {
    return await this.usersService.resetPasswordConfirm(token, password);
  }

  @Roles('USER')
  @Put('/profile')
  @ApiCreatedResponse({
    description: 'Updates the user profile',
    type: OmitType(UserProfileEntity, ['pregnancies', 'babies']),
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async updateUserProfile(
    @Req() req: Request,
    @Body() profile: UpdateUserProfileDto,
  ) {
    return await this.usersService.updateUserProfile(profile, req.user.id);
  }

  @Get('/profile')
  @ApiOkResponse({
    description: 'Returns the user profile',
    type: UserProfileEntity,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard)
  @SerializeOptions({ groups: ['me'] })
  async getCurrentUserProfile(@Req() req: Request) {
    return this.usersService.getCurrentUserProfile(req.user.id);
  }

  @Post('/profile/photo')
  @ApiCreatedResponse({
    description: 'Updates the user profile photo',
    type: PresignedPostDto,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, LimitByUserGuard)
  @SerializeOptions({ groups: ['me'] })
  async updateUserProfilePhoto(@Req() req: Request) {
    return this.usersService.createUploadProfilePicturePresignedPost(
      req.user.id,
    );
  }

  @Put('/profile/photo')
  @ApiCreatedResponse({
    description: 'Save updated user profile photo on DB',
    type: PresignedUrlDto,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, LimitByUserGuard)
  @SerializeOptions({ groups: ['me'] })
  async saveUserProfilePhoto(
    @Req() req: Request,
    @Body() body: UploadedImageDto,
  ) {
    return this.usersService.saveUploadedProfilePicture(req.user.id, body.key);
  }

  // Baby related endpoints
  @Roles('USER')
  @Post('/baby')
  @ApiCreatedResponse({
    description: 'Creates a new baby',
    type: BabyEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async createBaby(@Req() req: Request, @Body() baby: CreateBabyDto) {
    return await this.babyService.createBaby(baby, req.user.id);
  }

  @Roles('USER')
  @Get('/baby')
  @ApiOkResponsePaginated(BabyEntity)
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async getBabies(@Req() req: Request, @Query() query: PaginationOptionsDto) {
    return await this.babyService.getBabies({
      ...query,
      userId: req.user.id,
    });
  }

  @Roles('USER')
  @Get('/baby/:id')
  @ApiOkResponse({
    description: 'Returns the baby',
    type: BabyEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async getBaby(@Req() req: Request, @Param('id', ParseIntPipe) id: number) {
    return await this.babyService.getBaby(req.user.id, id);
  }

  @Roles('USER')
  @Patch('/baby/:id')
  @ApiOkResponse({
    description: 'Updates the baby',
    type: BabyEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async updateBaby(
    @Req() req: Request,
    @Body() baby: UpdateBabyDto,
    @Param('id', ParseIntPipe) id: number,
  ) {
    return await this.babyService.updateBaby(req.user.id, id, baby);
  }

  @Roles('USER')
  @Delete('/baby/:id')
  @ApiNoContentResponse({
    description: 'Deletes the baby',
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @HttpCode(HttpStatus.NO_CONTENT)
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async deleteBaby(@Req() req: Request, @Param('id', ParseIntPipe) id: number) {
    return await this.babyService.deleteBaby(req.user.id, id);
  }

  // pregnancy related endpoints

  @Roles('USER')
  @Post('/pregnancy')
  @ApiCreatedResponse({
    description: 'Creates a new pregnancy',
    type: PregnancyEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async createPregnancy(
    @Req() req: Request,
    @Body() pregnancy: CreatePregnancyDto,
  ) {
    return await this.pregnancyService.createPregnancy(req.user.id, pregnancy);
  }

  @Roles('USER')
  @Get('/pregnancy')
  @ApiOkResponse({
    description: 'Returns the user pregnancies',
    type: [PregnancyEntity],
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async getPregnancies(
    @Req() req: Request,
    @Query() query: PaginationOptionsDto,
  ) {
    return await this.pregnancyService.getPregnancies({
      ...query,
      userId: req.user.id,
    });
  }

  @Roles('USER')
  @Get('/pregnancy/active')
  @ApiOkResponse({
    description: 'Returns the users active pregnancy',
    type: [PregnancyEntity],
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async getPregnancy(
    @Req() req: Request,
    @Query('include_fetuses', ParseBoolPipe) includeFetuses: boolean,
  ) {
    return await this.pregnancyService.getActivePregnancy(
      req.user.id,
      includeFetuses,
    );
  }

  @Roles('USER')
  @Patch('/pregnancy/active')
  @ApiOkResponse({
    description: 'Updates the active pregnancy',
    type: PregnancyEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async updateActivePregnancy(@Req() req: Request, @Body() data: BirthDto) {
    return await this.pregnancyService.giveBirth(req.user.id, data);
  }

  @Roles('USER')
  @Get('/pregnancy/:id')
  @ApiOkResponse({
    description: 'Returns the pregnancy',
    type: PregnancyEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async getPregnancyById(
    @Req() req: Request,
    @Param('id', ParseIntPipe) id: number,
    @Query('include_fetuses', ParseBoolPipe) includeFetuses: boolean,
  ) {
    return await this.pregnancyService.getPregnancy(
      req.user.id,
      id,
      includeFetuses,
    );
  }

  @Roles('USER')
  @Patch('/pregnancy/:id')
  @ApiOkResponse({
    description: 'Updates the pregnancy',
    type: PregnancyEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async updatePregnancy(
    @Req() req: Request,
    @Body() pregnancy: UpdatePregnancyDto,
    @Param('id', ParseIntPipe) id: number,
  ) {
    return await this.pregnancyService.updatePregnancy(
      req.user.id,
      id,
      pregnancy,
    );
  }

  @Roles('USER')
  @Patch('/pregnancy/fetus/:id')
  @ApiOkResponse({
    description: 'Updates the fetus',
    type: FetusEntity,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async setFetusGender(
    @Req() req: Request,
    @Body() fetus: CreateFetusDto,
    @Param('id', ParseIntPipe) id: number,
  ) {
    return await this.pregnancyService.setFetusGender(
      req.user.id,
      id,
      fetus.gender,
    );
  }

  @Roles('USER')
  @Delete('/pregnancy/:id')
  @ApiNoContentResponse({
    description: 'Deletes the pregnancy',
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @HttpCode(HttpStatus.NO_CONTENT)
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @SerializeOptions({ groups: ['me'] })
  async deletePregnancy(
    @Req() req: Request,
    @Param('id', ParseIntPipe) id: number,
  ) {
    return await this.pregnancyService.deletePregnancy(req.user.id, id);
  }
}
