#!/usr/bin/env bash
set -e

/opt/wait-for-it.sh postgres:5432
npx prisma migrate deploy 
npm run prisma:seed 
npm run start:dev
