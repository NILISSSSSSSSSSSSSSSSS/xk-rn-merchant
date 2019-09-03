export class TakeOrPickParams {
  constructor(options = {}) {
    this.options = {
      func: TakeOrPickFunction.take,
      type: TakeTypeEnum.pickImage,
      totalNum: 0,
      limit: 0,
      crop: TakeOrPickCropEnum.NoCrop,
      duration: 0,
      token: '',
      ...options,
    };
  }

  getOptions() {
    const {
      func, type, totalNum, limit, crop, duration, token,
    } = this.options;
    return {
      func, type, totalNum, limit, crop, duration, token,
    };
  }

  setType(type) {
    this.options.type = type;
  }

  setCrop(crop) {
    this.options.crop = crop;
  }

  setToken(token) {
    this.options.token = token;
  }

  setLimit(limit) {
    this.options.limit = limit;
  }

  setDuration(duration) {
    this.options.duration = duration;
  }

  setTotalNum(totalNum) {
    this.options.totalNum = totalNum;
  }

  isTake() {
    return this.options.func === 'take';
  }
}

export const TakeOrPickCropEnum = {
  NoCrop: 0,
  Crop: 1,
};

export const TakeOrPickFunction = {
  take: 'take',
  pick: 'pick',
};

/** 1 图片 2 视频 3 选择图片或者视频 */
export const PickTypeEnum = {
  pickImage: 1,
  pickVideo: 2,
  pickImageOrVideo: 3,
};

/** 0:拍照，1:拍视频，2:既能拍照又能拍视频 */
export const TakeTypeEnum = {
  takeImage: 0,
  takeVideo: 1,
  takeImageOrVideo: 2,
};
