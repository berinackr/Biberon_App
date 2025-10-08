import { execSync } from 'child_process';

module.exports = () => {
  execSync('docker-compose -f docker-compose.integration.yml down -v');
};
