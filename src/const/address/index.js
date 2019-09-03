import Province from './province.json';
import City from './city.json';
import District from './area.json';

export const regionMap = {
  provinces: Province,
  cities: City,
  districts: District,
};

export const pickerArea = {
  area: [],
  allArea: [],
  provinces: regionMap.provinces,
  cities: regionMap.cities,
  districts: regionMap.districts,
  provinceName: regionMap.provinces.map(item => [item.name, item.code]),
  cityName: regionMap.cities.map(item => [item.name, item.code]),
  provinceCode: regionMap.provinces.map(item => [item.code, item]),
  cityCode: regionMap.cities.map(item => [item.code, item]),
  districtCode: regionMap.districts.map(item => [item.code, item]),
};

const province = regionMap.provinces;
const city = regionMap.cities;
const district = regionMap.districts;

const area = [];
const allArea = [];
for (let i = 0; i < province.length; i++) {
  const cityOfProvince = [];
  const allCityOfProvince = [];
  for (let j = 0; j < city.length; j++) {
    if (city[j].parentCode == province[i].code) {
      const districtOfCity = [];
      const allAistrictOfCity = [];
      for (let k = 0; k < district.length; k++) {
        if (district[k].parentCode == city[j].code) {
          districtOfCity.push(district[k].name);
          allAistrictOfCity.push(district[k]);
        }
      }
      cityOfProvince.push({ [city[j].name]: districtOfCity });
      allCityOfProvince.push({ ...city[j], children: allAistrictOfCity });
    }
  }
  area.push({ [province[i].name]: cityOfProvince });
  allArea.push({
    ...province[i],
    children: allCityOfProvince,
  });
}
pickerArea.allArea = allArea;
pickerArea.area = area;

export const addressMap = {
  provinceNameMap: new Map(pickerArea.provinceName),
  cityNameMap: new Map(pickerArea.cityName),
  provinceCodeMap: new Map(pickerArea.provinceCode),
  cityCodeMap: new Map(pickerArea.cityCode),
  districtCodeMap: new Map(pickerArea.districtCode),
};

/**
 * 根据名称获取省市区编码
 * @param {string[]} names
 */
export const getCodesByNames = (names) => {
  const provinceCode = addressMap.provinceNameMap.get(names[0]);
  const cityCode = addressMap.cityNameMap.get(names[1]);
  const district = pickerArea.districts.filter(item => item.name == names[2] && item.parentCode == cityCode) || [];
  const districtCode = district.length > 0 ? district[0].code : '';
  return [provinceCode, cityCode, districtCode];
};

/**
 * 根据地区编码获取省市区地址信息
 * @param {string} districtCode 地区编码
 */
export const getAddressByDistrictCode = (districtCode) => {
  if (!districtCode) return '--';
  const _district = addressMap.districtCodeMap.get(districtCode);
  if (_district) {
    const _city = addressMap.cityCodeMap.get(_district.parentCode);
    const _province = addressMap.provinceCodeMap.get(_city.parentCode);
    return `${_province.name}-${_city.name}-${_district.name}`;
  }
  return '--';
};

/**
 * 根据地区编码获取省市区地址信息数组
 * @param {string} districtCode 地区编码
 */
export const getNamesByDistrictCode = (districtCode) => {
  if (!districtCode) return null;
  const _district = addressMap.districtCodeMap.get(districtCode);
  if (_district) {
    const _city = addressMap.cityCodeMap.get(_district.parentCode);
    const _province = addressMap.provinceCodeMap.get(_city.parentCode);
    return [_province.name, _city.name, _district.name];
  }
  return [];
};

/**
 * 根据地区编码获取区地址信息
 * @param {string} districtCode
 */
export const getDistrictNameByCode = (districtCode) => {
  const _district = addressMap.districtCodeMap.get(districtCode) || {};
  return _district.name || '';
};

/**
 * 根据地区编码获取省市区地址编码数组
 * @param {string} districtCode 地区编码
 */
export const getCodesByDistrictCode = (districtCode) => {
  if (!districtCode) return null;
  const _district = addressMap.districtCodeMap.get(districtCode);
  if (_district) {
    const _city = addressMap.cityCodeMap.get(_district.parentCode);
    const _province = addressMap.provinceCodeMap.get(_city.parentCode);
    return [_province.code, _city.code, _district.code];
  }
  return [];
};
