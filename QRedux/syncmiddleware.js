
function createSyncMiddleware(provider) {

    return function (store) {

        return function(next) {

            return function (action) {
                var prevState = store.getState();
                next(action);
                var nextState = store.getState();
                var changes = diff(prevState, nextState);
                patch(provider, changes);
            }
        }

    }
}
