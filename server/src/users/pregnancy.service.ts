import {
  Inject,
  Injectable,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import { PaginatedResult } from '../common/pagination/paginator';
import { PregnancyEntity } from './entity/pregnancy';
import { UpdatePregnancyDto } from './dto/update-pregnancy.dto';
import { CreatePregnancyDto } from './dto/create-pregnancy.dto';
import { GeneralResponseDto } from '../common/dto/general-response.dto';
import { PregnancyRepository } from './pregnancy.repository';
import { kpaginator } from '../common/pagination/k-paginator';
import { PaginationOptionsDto } from '../common/dto/pagination-options.dto';
import { gender, pregnancyType } from '../database/enums';
import { BirthDto } from './dto/birth.dto';
@Injectable()
export class PregnancyService {
  constructor(
    @Inject(LoggerKey) private logger: Logger,
    private readonly pregnancyRepository: PregnancyRepository,
  ) {}

  async createPregnancy(userId: string, pregnancy: CreatePregnancyDto) {
    this.logger.debug('Creating pregnancy', {
      props: {
        userId,
        pregnancy,
      },
    });

    if (!pregnancy.lastPeriodDate && !pregnancy.dueDate) {
      throw new UnprocessableEntityException(
        'Son adet tarihi veya doğum tarihi boş bırakılamaz.',
      );
    }

    const fetusNumber = this.getFetusCount(pregnancy.type);

    if (fetusNumber !== pregnancy.fetuses.length) {
      throw new UnprocessableEntityException(
        'Hamilelik tipine uygun bilgi girilmemiş.',
      );
    }

    const data = {
      ...pregnancy,
      isActive: !pregnancy.birthGiven,
      endDate: pregnancy.birthGiven ? pregnancy.dueDate : null,
      lastPeriodDate: pregnancy.dueDate ? null : pregnancy.lastPeriodDate,
      dueDate: pregnancy.dueDate
        ? pregnancy.dueDate
        : this.calculateDueDate(pregnancy.lastPeriodDate!),
    };

    const pregnancyInfo = await this.pregnancyRepository.createPregnancy(
      userId,
      data,
    );

    return new PregnancyEntity(pregnancyInfo);
  }

  async getPregnancies({
    order,
    page,
    userId,
  }: PaginationOptionsDto & { userId: string }) {
    const result: PaginatedResult<PregnancyEntity> = await this.paginate(
      {
        data: this.pregnancyRepository.getPregnancies(userId),
        count: this.pregnancyRepository.getPregnanciesQuery(userId),
      },
      {
        orderBy: ['pregnancy.isActive', 'pregnancy.dueDate', 'pregnancy.id'],
        order,
      },
      {
        page,
      },
    );

    return {
      ...result,
      data: result.data.map((pregnancy) => new PregnancyEntity(pregnancy)),
    };
  }

  async getPregnancy(
    userId: string,
    pregnancyId: number,
    includeFetuses: boolean,
  ) {
    this.logger.debug('Getting pregnancy', {
      props: {
        userId,
        pregnancyId,
      },
    });

    const pregnancy = await this.pregnancyRepository.getPregnancy(
      userId,
      pregnancyId,
      includeFetuses,
    );

    if (!pregnancy) {
      throw new NotFoundException('Böyle bir hamilelik bulunamadı.');
    }

    this.logger.info('Pregnancy found', {
      props: {
        userId,
        pregnancyId,
      },
    });

    return new PregnancyEntity(pregnancy);
  }

  async getActivePregnancy(userId: string, includeFetuses: boolean) {
    this.logger.debug('Getting active pregnancy', {
      props: {
        userId,
      },
    });

    const pregnancy = await this.pregnancyRepository.getActivePregnancy(
      userId,
      includeFetuses,
    );

    if (!pregnancy) {
      throw new NotFoundException('Aktif bir hamilelik bulunamadı.');
    }

    this.logger.info('Active pregnancy found', {
      props: {
        userId,
      },
    });

    return new PregnancyEntity(pregnancy);
  }

  async updatePregnancy(
    userId: string,
    pregnancyId: number,
    data: UpdatePregnancyDto,
  ) {
    this.logger.debug('Updating pregnancy', {
      props: {
        userId,
        pregnancyId,
        data,
      },
    });

    if (!data.lastPeriodDate && !data.dueDate) {
      throw new UnprocessableEntityException(
        'Son adet tarihi veya tahmini doğum tarihi boş bırakılamaz.',
      );
    }

    const fetusNumber = this.getFetusCount(data.type);

    if (fetusNumber !== data.fetuses.length) {
      throw new UnprocessableEntityException(
        'Hamilelik tipine uygun bilgi girilmemiş.',
      );
    }

    const updatedData = {
      ...data,
      isActive: !data.birthGiven,
      endDate: data.birthGiven
        ? data.dueDate
          ? data.dueDate
          : this.calculateDueDate(data.lastPeriodDate!)
        : null,
      dueDate: data.dueDate
        ? data.dueDate
        : this.calculateDueDate(data.lastPeriodDate!),
      lastPeriodDate: data.dueDate ? null : data.lastPeriodDate,
    };

    const pregnancyInfo = await this.pregnancyRepository.updatePregnancy(
      userId,
      pregnancyId,
      updatedData,
    );

    this.logger.info('Pregnancy updated', {
      props: {
        userId,
        pregnancyId,
      },
    });

    return new PregnancyEntity(pregnancyInfo);
  }

  async deletePregnancy(userId: string, pregnancyId: number) {
    this.logger.debug('Deleting pregnancy', {
      props: {
        userId,
        pregnancyId,
      },
    });

    await this.pregnancyRepository.deletePregnancy(userId, pregnancyId);

    this.logger.info('Pregnancy deleted', {
      props: {
        userId,
        pregnancyId,
      },
    });
  }

  async setFetusGender(
    userId: string,
    fetusId: number,
    gender: gender,
  ): Promise<GeneralResponseDto> {
    this.logger.debug('Setting fetus gender', {
      props: {
        userId,
        fetusId,
        gender,
      },
    });

    await this.pregnancyRepository.setFetusGender(userId, fetusId, gender);

    return new GeneralResponseDto({
      message: 'Cinsiyet başarıyla güncellendi.',
      status: 'success',
    });
  }

  async giveBirth(userId: string, data: BirthDto) {
    this.logger.debug('Giving birth', {
      props: {
        userId,
      },
    });

    const pregnancy = await this.pregnancyRepository.setPregnancyUnactive(
      userId,
      data.birthDate,
    );

    this.logger.info('Pregnancy ended', {
      props: {
        userId,
      },
    });

    return new PregnancyEntity(pregnancy);
  }

  private paginate = kpaginator({ perPage: 10 });

  private getFetusCount(type?: pregnancyType) {
    switch (type) {
      case 'SINGLE':
        return 1;
      case 'TWIN':
        return 2;
      case 'TRIPLET':
        return 3;
      default:
        return 1;
    }
  }

  calculateDueDate(lastPeriod: Date | string) {
    const dueDate = new Date(lastPeriod);
    dueDate.setDate(dueDate.getDate() + 280);
    return dueDate;
  }
}
