import { deliveryType, pregnancyType } from '../../database/enums';
import { CreateFetusDto } from '../dto/create-fetus.dto';

export type CreatePregnancyInput = {
  isActive: boolean;
  endDate: Date | null | undefined;
  lastPeriodDate: Date | null | undefined;
  dueDate: Date;
  birthGiven: boolean;
  notes?: string | undefined;
  deliveryType?: deliveryType | undefined;
  type: pregnancyType;
  fetuses: CreateFetusDto[];
};
