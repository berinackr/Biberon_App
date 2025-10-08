import { SelectQueryBuilder } from 'kysely';
import { DB } from '../../database/types';

export interface PaginatedResult<T> {
  data: T[];
  meta: {
    total: number;
    lastPage: number;
    currentPage: number;
    perPage: number;
    prev: number | null;
    next: number | null;
  };
}

export type PaginateOptions = {
  page?: number | string;
  perPage?: number | string;
};
export type PaginateFunction = <T, R>(
  query: {
    data: (
      eb: SelectQueryBuilder<DB, keyof DB, R>,
    ) => SelectQueryBuilder<DB, keyof DB, any>;
    count: SelectQueryBuilder<DB, keyof DB, any>;
  },
  args: {
    orderBy: string[];
    order: 'asc' | 'desc';
  },
  options?: PaginateOptions,
) => Promise<PaginatedResult<T>>;

export const kpaginator = (
  defaultOptions: PaginateOptions,
): PaginateFunction => {
  return async (query, args, options) => {
    const page = Number(options?.page || defaultOptions?.page) || 1;
    const perPage = Number(options?.perPage || defaultOptions?.perPage) || 10;

    const skip = page > 0 ? perPage * (page - 1) : 0;
    const getQuery = query.count
      .orderBy(args.orderBy[0], args.order)
      .orderBy(args.orderBy[1], args.order)
      .$if(!!args.orderBy[2], (qb) => qb.orderBy(args.orderBy[2], args.order))
      .limit(perPage)
      .offset(skip);
    const { total, data } = await query.data(getQuery).executeTakeFirst();

    const lastPage = Math.ceil(total / perPage);

    return {
      data,
      meta: {
        total: Number(total),
        lastPage,
        currentPage: page,
        perPage,
        prev: page > 1 ? page - 1 : null,
        next: page < lastPage ? page + 1 : null,
      },
    };
  };
};
