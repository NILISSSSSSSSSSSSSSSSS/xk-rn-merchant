type TakeOrPickFunction = "take" | "pick";

export enum TakeOrPickCropEnum {
    NoCrop = 0,
    Crop = 1,
}

/** 1 图片 2 视频 3 选择图片或者视频 */
export enum PickTypeEnum {
    pickImage = 1,
    pickVideo = 2,
    pickImageOrVideo = 3,
}

/** 0:拍照，1:拍视频，2:既能拍照又能拍视频 */
export enum TakeTypeEnum {
    takeImage = 0,
    takeVideo = 1,
    takeImageOrVideo = 2,
}

interface TakeOrPickOptions {
    func: TakeOrPickFunction,
    type: PickTypeEnum | TakeTypeEnum,
    token: string,
    crop: TakeOrPickCropEnum,
    duration: number,
    totalNum: number,
    limit: number,
}

export class TakeOrPickParams {
    constructor(TakeOrPickOptions):void
    getOptions(): TakeOrPickOptions
    setType(type: PickTypeEnum | TakeTypeEnum): void
    setToken(token: string): void
    setCrop(type: TakeOrPickCropEnum): void
    setDuration(duration: number): void
    setTotalNum(totalNum: number): void
    setLimit(limit: number): void
    setFunction(func: TakeOrPickFunction): void
}