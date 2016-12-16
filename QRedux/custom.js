
function diff(v1, v2) {
    if (v1 === v2) {
        return undefined;
    }

    if (typeof v1 === "object" &&
        typeof v2 === "object" &&
        !Array.isArray(v2)) { // Don't compare array element.

        var res = {};
        for (var k in v2) {
            var d = diff(v1[k], v2[k]);
            if (d !== undefined) {
                res[k] = d;
            }
        }

        return res;
    } else {
        return v2;
    }
}

function patch(dest, changes) {
    if (dest === undefined ||
        changes === undefined) {
        return dest;
    }

    for (var i in changes) {
        if (!dest.hasOwnProperty(i)) {
            continue;
        }

        if (typeof changes[i] === "object" && !Array.isArray(changes[i])){
            patch(dest[i], changes[i])
        } else {
            dest[i] = changes[i];
        }
    }

    return dest;
}

function mapReducers(table) {

    return function(state, action) {
        if (table.hasOwnProperty(action.type)) {
            return table[action.type](state, action);
        }

        return state;
    }

}

function chainReducers(reducers) {

    return function(state, action) {
        for (var i in reducers) {
            state = reducers[i](state, action);
        }

        return state;
    }

}
