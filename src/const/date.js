
export const createDateDataBefore = (years = 100) => {
  const date = [];
  const today = new Date();
  const fullYear = today.getFullYear();
  const fullMonth = today.getMonth() + 1;
  const fullDay = today.getDate();
  for (let i = fullYear - years; i <= fullYear; i++) {
    const month = [];
    for (let j = 1; j < (i == fullYear ? fullMonth + 1 : 13); j++) {
      const day = [];
      const nowDays = i == fullYear && j == fullMonth ? fullDay : 99;
      if (j === 2) {
        for (let k = 1; k < Math.min(29, nowDays + 1); k++) {
          day.push(`${k}日`);
        }
        // Leap day for years that are divisible by 4, such as 2000, 2004
        if (i % 4 === 0) {
          day.push(`${29}日`);
        }
      } else if (j in {
        1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1,
      }) {
        for (let k = 1; k < Math.min(32, nowDays + 1); k++) {
          day.push(`${k}日`);
        }
      } else {
        for (let k = 1; k < Math.min(31, nowDays + 1); k++) {
          day.push(`${k}日`);
        }
      }
      const _month = {};
      _month[`${j}月`] = day;
      month.push(_month);
    }
    const _date = {};
    _date[`${i}年`] = month;
    date.push(_date);
  }
  console.log(date);
  return date;
};


export const createDateDataFuture = (years = 50) => {
  const date = [];
  const today = new Date();
  const fullYear = today.getFullYear();
  const fullMonth = today.getMonth() + 1;
  const fullDay = today.getDate();
  for (let i = fullYear; i < fullYear + years; i++) {
    const month = [];
    for (let j = i == fullYear ? fullMonth : 1; j < 13; j++) {
      const day = [];
      const _day = {};
      const nowDays = i == fullYear && j == fullMonth ? fullDay : 1;
      if (j === 2) {
        for (let k = nowDays; k < 29; k++) {
          day.push(`${k}日`);
        }
        // Leap day for years that are divisible by 4, such as 2000, 2004
        if (i % 4 === 0) {
          day.push(`${29}日`);
        }
      } else if (j in {
        1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1,
      }) {
        for (let k = nowDays; k < 32; k++) {
          day.push(`${k}日`);
        }
      } else {
        for (let k = nowDays; k < 31; k++) {
          day.push(`${k}日`);
        }
      }
      const _month = {};
      _month[`${j}月`] = day;
      month.push(_month);
    }
    const _date = {};
    _date[`${i}年`] = month;
    date.push(_date);
  }
  return date;
};
