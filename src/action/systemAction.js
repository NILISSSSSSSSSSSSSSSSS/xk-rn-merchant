export const syncQiniuToken = (callback = ()=>{}, isForce = false)=> {
    return (dispatch, getState)=> {
        app._store.dispatch({ type: "application/syncQiniuToken", payload: { callback, isForce }})
    }
}
