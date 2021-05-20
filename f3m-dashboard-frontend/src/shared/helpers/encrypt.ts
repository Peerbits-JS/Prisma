const aes = require('crypto-js/aes');
const enc = require('crypto-js/enc-utf8');

const secretKey = 'F3MPIUInfanciaTopSecretKey';

export const encrypt = (v: string) => {
  return aes.encrypt(v, secretKey);
};

export const decrypt = (v: any) => {
  return aes.decrypt(v, secretKey).toString(enc);
};
