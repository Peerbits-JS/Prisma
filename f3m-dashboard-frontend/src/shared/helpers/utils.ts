import { encrypt, decrypt } from './encrypt';

export const isDefined = (v: any) => v !== undefined && v !== null;

export const stringToBool = (v: string) => Boolean(v !== undefined && v != null && v != '' && v.toUpperCase() === 'TRUE');

export const clone = (v: any) => JSON.parse(JSON.stringify(v));

export const firstElemOf = (array: any[]) => array[0];

export const lastElemOf = (array: any[]) => array[array.length - 1];

export const isEmpty = (v: any[]) => isDefined(v) && !v.length;

export const searchParams = (v: string) => new URLSearchParams(window.location.href).get(v);

export const fileExtensionOf = (v: string) => lastElemOf(v.split('.')).toLowerCase();

export const newOrdinalArrayOf = (v: number) => Array.from(Array(v), (_, i) => i + 1);

export const setLocalStorage = (n: string, v: any) =>
  localStorage.setItem(n, encrypt(JSON.stringify(v)));

export const getLocalStorage = (n: string, d: any) =>
  isDefined(localStorage.getItem(n)) ? JSON.parse(decrypt(localStorage.getItem(n))) : d;

export const getFileExtension = (n: string) => {
  const parts = n.split('.');
  return parts.pop()?.toLowerCase();
}
