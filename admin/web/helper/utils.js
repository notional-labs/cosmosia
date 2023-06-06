import TimeAgo from 'javascript-time-ago';

// English.
import en from 'javascript-time-ago/locale/en'

TimeAgo.addDefaultLocale(en)
// Create formatter (English).
const timeAgo = new TimeAgo('en-US');


export const format2Decimal = (num) => {
  return (Math.round(num * 100) / 100).toFixed(2);
}

export const timeAgoFormat = (dt) => {
  if (typeof dt === 'string' || dt instanceof String) {
    const d = Date.parse(dt);
    return timeAgo.format(d, 'mini');
  }

  return timeAgo.format(dt, 'mini');
}

export const getRandomFloat = (min, max, decimals) => {
  const str = (Math.random() * (max - min) + min).toFixed(decimals);
  return parseFloat(str);
}
