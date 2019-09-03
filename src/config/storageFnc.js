
export default storageFnc = (key, status = 'save', data = null, expires = null) => {
    let params = {
        key
    };

    if (status === 'save') {
        storage.save({
            ...params,
            data,
            expires
        });
    } else if (status === 'load') {
        return storage.load({
            ...params
        });
    } else if (status === 'remove') {
        storage.remove({
            ...params
        });
    }
}
