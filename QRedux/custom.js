
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

function _isQtObject(object) {
    if (typeof(object) !== "object" || typeof(object) === "string") {
        return false;
    }

    // Example Value:
    // QObject(0x7f8a69dcc940)
    // QQuickItem_QML_4(0x7f8a69dcc420)

    return String(object).match(/^[a-zA-Z0-9_]*\(0x[0-9a-fA-F]*\)$/) !== null;
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

        var recursiveMergeOnTargetQtObject = typeof changes[i] === "object"
                && !Array.isArray(changes[i])
                && _isQtObject(dest[i]);

        var bothAreObject = typeof changes[i] === "object" &&
                            typeof dest[i] === "object" &&
                            !Array.isArray(changes[i]) &&
                            !Array.isArray(dest[i]);

        if (recursiveMergeOnTargetQtObject) {
            patch(dest[i], changes[i])
        } else if (bothAreObject) {
            var mergedValue = merge(dest[i], changes[i]);
            dest[i] = mergedValue;
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

/// A lightweight implementation of _.merge
function merge() {
    var source = arguments[0];

    function copy(source, prop, value) {
        if (typeof value === "object") {
            var s = source[prop];

            if (s === undefined || s === null) {
                s = {};
            }

            source[prop] = merge(s, value);
        } else {
            source[prop] = value;
        }
    }

    for (var i = 1 ; i < arguments.length;i++) {
        var input = arguments[i];

        if (input === undefined || input === null) {
            continue;
        }

        for (var p in input) {
            var value = input[p];

            if (Array.isArray(value)) {
                var arr = value.slice(0);

                for (var j in arr) {
                    var arrValue = arr[j];
                    if (typeof arrValue === "object") {
                        arr[j] = merge({}, arrValue);
                    }
                }

                source[p] = arr;

            } else {
                copy(source, p, value);
            }
        }
    }

    return source;
}
