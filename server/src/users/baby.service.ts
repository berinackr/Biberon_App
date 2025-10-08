import { Inject, Injectable, NotFoundException } from '@nestjs/common';

import Logger, { LoggerKey } from '../logging/types/logger.type';
import { CreateBabyDto } from './dto/create-baby.dto';
import { BabyEntity } from './entity/baby';
import { PaginatedResult } from '../common/pagination/paginator';
import { UpdateBabyDto } from './dto/update-baby.dto';
import { BabyRepository } from './baby.repository';
import { kpaginator } from '../common/pagination/k-paginator';
import { PaginationOptionsDto } from '../common/dto/pagination-options.dto';
@Injectable()
export class BabyService {
  constructor(
    private readonly babyRepository: BabyRepository,
    @Inject(LoggerKey) private logger: Logger,
  ) {}

  async createBaby(baby: CreateBabyDto, userId: string) {
    this.logger.debug('Creating baby', {
      props: {
        userId,
        baby,
      },
    });

    const babyInfo = await this.babyRepository.createBaby(baby, userId);

    this.logger.info('Baby created', {
      props: {
        userId,
      },
    });

    return new BabyEntity(babyInfo);
  }

  async getBabies({
    order,
    page,
    userId,
  }: PaginationOptionsDto & { userId: string }) {
    const result: PaginatedResult<BabyEntity> = await this.paginate(
      {
        data: this.babyRepository.getBabies(userId),
        count: this.babyRepository.getBabiesQuery(userId),
      },
      {
        orderBy: ['baby.dateOfBirth', 'baby.id'],
        order: order,
      },
      {
        page,
      },
    );

    return {
      ...result,
      data: result.data.map((baby) => new BabyEntity(baby)),
    };
  }

  async getBaby(userId: string, babyId: number) {
    this.logger.debug('Getting baby', {
      props: {
        userId,
        babyId,
      },
    });

    const baby = await this.babyRepository.getBaby(userId, babyId);

    if (!baby) {
      throw new NotFoundException('Böyle bir bebek bulunamadı.');
    }

    this.logger.info('Baby found', {
      props: {
        userId,
        babyId,
      },
    });

    return new BabyEntity(baby);
  }

  async updateBaby(userId: string, babyId: number, data: UpdateBabyDto) {
    const babyInfo = await this.babyRepository.updateBaby(data, userId, babyId);

    this.logger.debug('Baby updated', {
      props: {
        userId,
        babyId,
      },
    });

    return new BabyEntity(babyInfo);
  }

  async deleteBaby(userId: string, babyId: number) {
    this.logger.debug('Deleting baby', {
      props: {
        userId,
        babyId,
      },
    });

    await this.babyRepository.deleteBaby(userId, babyId);

    this.logger.info('Baby deleted', {
      props: {
        userId,
        babyId,
      },
    });
  }

  private paginate = kpaginator({ perPage: 10 });
}
