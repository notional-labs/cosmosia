import TimeAgo from 'javascript-time-ago';

// English.
import en from 'javascript-time-ago/locale/en';

let timeAgo = null;



export const format2Decimal = (num) => {
  return (Math.round(num * 100) / 100).toFixed(2);
}

export const timeAgoFormat = (dt) => {
  if (!timeAgo) {
    // init TimeAgo if needed
    TimeAgo.addDefaultLocale(en);
    TimeAgo.addLocale(en);

    // Create formatter (English).
    timeAgo = new TimeAgo('en-US');
  }

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
