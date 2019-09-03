import Axios from 'axios';
import { Buffer } from 'buffer';
import { qiniuUrlAdd } from '../config/utils';

const protocol = 'https:';
let uploadToken = '';
let qiniuUploadUrls = [
  'http://upload.qiniu.com',
  'http://up.qiniu.com',
];

const qiniuUpHosts = {
  http: [
    'http://upload.qiniu.com',
    'http://up.qiniu.com',
  ],
  https: [
    'https://up.qbox.me',
  ],
};

let qiniuUploadUrl;
if (protocol === 'https:') {
  qiniuUploadUrl = 'https://up.qbox.me';
} else {
  qiniuUploadUrl = 'http://upload.qiniu.com';
}

const ImageExtList = ['jpg', 'png', 'jpeg', 'gif', 'bmp'];
const VideoExtList = ['mp4', 'wmv'];

/**
 * encode string in url by base64
 * @param {String} string in url
 * @return {String} encoded string
 */
const URLSafeBase64Encode = (v) => {
  v = Buffer.from(v, 'utf8').toString('base64');
  return v.replace(/\//g, '_').replace(/\+/g, '-');
};

const URLSafeBase64Decode = function (v) {
  v = v.replace(/_/g, '/').replace(/-/g, '+');
  return Buffer.from(v, 'base64').toString('utf8');
};

const getPutPolicy = (uptoken) => {
  const segments = uptoken.split(':');
  const ak = segments[0];
  const putPolicy = JSON.parse(URLSafeBase64Decode(segments[2]));
  putPolicy.ak = ak;
  if (putPolicy.scope.indexOf(':') >= 0) {
    putPolicy.bucket = putPolicy.scope.split(':')[0];
    putPolicy.key = putPolicy.scope.split(':')[1];
  } else {
    putPolicy.bucket = putPolicy.scope;
  }
  return putPolicy;
};

const getHosts = (hosts) => {
  const result = [];
  for (let i = 0; i < hosts.length; i++) {
    const host = hosts[i];
    if (host.indexOf('-H') === 0) {
      result.push(host.split(' ')[2]);
    } else {
      result.push(host);
    }
  }
  return result;
};

export const getUpHosts = async (uptoken) => {
  const putPolicy = getPutPolicy(uptoken);
  const uphosts_url = `${protocol}//uc.qbox.me/v1/query?ak=${putPolicy.ak}&bucket=${putPolicy.bucket}`;
  const res = await Axios.get(uphosts_url);
  console.log(res, putPolicy);
  qiniuUpHosts.http = getHosts(res.data.http.up);
  qiniuUpHosts.https = getHosts(res.data.https.up);
  resetUploadUrl(true);
};

let changeUrlTimes = 0;
export const resetUploadUrl = (isFirst) => {
  qiniuUploadUrls = protocol === 'https:' ? qiniuUpHosts.https : qiniuUpHosts.http;
  if (isFirst) {
    changeUrlTimes = qiniuUploadUrls.findIndex(url => url.includes('upload'));
  }
  const i = changeUrlTimes % qiniuUploadUrls.length;
  qiniuUploadUrl = qiniuUploadUrls[i];
  changeUrlTimes++;
};

export const compareQiniuToken = async (qiniuToken) => {
  if (uploadToken !== qiniuToken) {
    await getUpHosts(qiniuToken);
    uploadToken = qiniuToken;
  }
};

export const calUploadProgress = (uploadProgress) => {
  const allFiles = Object.keys(uploadProgress.objFiles).map(key => ({ uri: key, ...uploadProgress.objFiles[key] }));
  uploadProgress.totalSize = allFiles.reduce((sum, item) => sum + item.total, 0);
  uploadProgress.loadedSize = allFiles.reduce((sum, item) => sum + item.loaded, 0);
  uploadProgress.loadedFileNum = allFiles.filter(item => item.total === item.loaded).length;
};

export const QiniuUploadFile = (filePath, qiniuToken, onUploadProgress = () => {}, deep = 0) => new Promise(async (resolve, reject) => {
  if (deep > qiniuUploadUrls.length) {
    reject('七牛上传失败');
    return;
  }
  await compareQiniuToken(qiniuToken);
  const formData = new FormData();
  const splits = filePath.split('.');
  const ext = (splits[splits.length - 1] || 'unkown').toLowerCase();
  let encodeName = encodeFileName(filePath)
  formData.append('file', {
    uri: encodeName,
    type: 'application/octet-stream',
    name: `upload.${Date.now()}.${ext}`,
  });
  formData.append('token', qiniuToken);
  Axios.post(qiniuUploadUrl, formData, {
    onUploadProgress,
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  }).then((res) => {
    const url = qiniuUrlAdd(res.data.key);
    const type = ImageExtList.includes(ext) ? 'images' : VideoExtList.includes(ext) ? 'video' : 'unkown';
    resolve({ url, type, cover: type === 'video' ? `${url}?vframe/jpg/offset/0` : null });
  }).catch(async (error) => {
    console.log('qiniuUpload.QiniuUploadFile', error);
    resetUploadUrl();
    resolve(await QiniuUploadFile(filePath, qiniuToken, onUploadProgress, deep + 1));
  });
});

export const QiniuUploadFiles = async (filePaths, qiniuToken, onUploadProgress = () => {}) => {
  await compareQiniuToken(qiniuToken);
  console.log('qiniuUpload.resetUploadUrl', qiniuUploadUrl);
  const uploadProgress = {
    totalSize: 0,
    loadedSize: 0,
    totalFileNum: filePaths.length,
    loadedFileNum: 0,
    objFiles: {},
  };
  return Promise.all(filePaths.map(filePath => QiniuUploadFile(filePath, qiniuToken, (progressEvent) => {
    console.log(progressEvent);
    const loaded = progressEvent.loaded;
    const total = progressEvent.total;
    uploadProgress.objFiles[filePath] = { loaded, total };
    calUploadProgress(uploadProgress);
    onUploadProgress(uploadProgress);
  })));
};

encodeFileName = (filePath) => {
  let path = filePath.slice(0, filePath.lastIndexOf('/'))
  let fileName = filePath.slice(filePath.lastIndexOf('/'), filePath.lastIndexOf('.'))
  let suffix = filePath.slice(filePath.lastIndexOf('.'), filePath.length);
  return `${path}${encodeURIComponent(fileName)}${suffix}`
}